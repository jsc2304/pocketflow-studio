import AppKit

/// One local, read-only presentation session. A compatible shelf must answer
/// before audio levels are published or the floating recording panel is hidden.
@MainActor final class NotchShelfMeter: NSObject {
    static let prefix = "io.github.jsc2304.pocketflow-studio.meter.v1."
    private let bus = DistributedNotificationCenter.default()
    private var session: String?
    private var timer: Timer?
    private var lastReply: ContinuousClock.Instant?
    private var nextProbe = ContinuousClock.now
    private var sample: (() -> Float?)?
    var presentationChanged: (() -> Void)?
    private(set) var presented = false {
        didSet { if presented != oldValue { presentationChanged?() } }
    }

    override init() {
        super.init()
        bus.addObserver(self, selector: #selector(ready(_:)), name: .init(Self.prefix + "ready"), object: nil)
    }

    func start(sample: @escaping () -> Float?) {
        self.sample = sample
        guard session == nil else { return }
        session = UUID().uuidString
        nextProbe = .now
        let timer = Timer(timeInterval: 0.125, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.tick() }
        }
        self.timer = timer
        RunLoop.main.add(timer, forMode: .common)
        tick()
    }

    @objc private func ready(_ note: Notification) {
        guard let session, note.object as? String == session else { return }
        lastReply = .now
    }

    private func tick() {
        guard let session, let level = sample?() else { stop(); return }
        let now = ContinuousClock.now
        if now >= nextProbe {
            nextProbe = now.advanced(by: .seconds(1))
            post("probe", session)
        }
        let available = lastReply.map { $0.duration(to: now) < .seconds(2) } ?? false
        if available { post("level", session, ["level": max(0, min(1, level))]) }
        presented = available
    }

    private func post(_ event: String, _ id: String, _ info: [String: Any]? = nil) {
        bus.postNotificationName(.init(Self.prefix + event), object: id, userInfo: info, deliverImmediately: true)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        if let session { post("end", session) }
        session = nil
        sample = nil
        lastReply = nil
        presented = false
    }
}
