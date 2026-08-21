import Foundation
@preconcurrency import MultipeerConnectivity
import UIKit

@MainActor
final class NearbySession: NSObject, ObservableObject {
    private static let serviceType = "max-ptt"

    @Published private(set) var isDiscovering = false
    @Published private(set) var connectionStatus = "Nearby sharing is off"
    @Published private(set) var discoveredPeerNames: [String] = []
    @Published private(set) var connectedPeerNames: [String] = []
    @Published var errorMessage: String?

    private let peerID: MCPeerID
    nonisolated(unsafe) private let session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    private var discoveredPeers: [String: MCPeerID] = [:]

    override init() {
        let displayName = String(UIDevice.current.name.prefix(30))
        peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()

        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: nil,
            serviceType: Self.serviceType
        )
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: Self.serviceType)
        advertiser.delegate = self
        browser.delegate = self
    }

    func startDiscovery() {
        guard !isDiscovering else { return }

        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
        isDiscovering = true
        connectionStatus = "Looking for nearby MAX devices"
    }

    func stopDiscovery() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        isDiscovering = false
        discoveredPeers.removeAll()
        discoveredPeerNames = []
        connectionStatus = connectedPeerNames.isEmpty ? "Nearby sharing is off" : "Connected"
    }

    func connect(to peerName: String) {
        guard let peer = discoveredPeers[peerName] else { return }

        connectionStatus = "Inviting \(peerName)"
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 20)
    }

    private func refreshConnectedPeers() {
        connectedPeerNames = session.connectedPeers.map(\.displayName).sorted()
        connectionStatus = connectedPeerNames.isEmpty
            ? (isDiscovering ? "Looking for nearby MAX devices" : "Nearby sharing is off")
            : "Connected to \(connectedPeerNames.joined(separator: ", "))"
    }
}

extension NearbySession: MCNearbyServiceBrowserDelegate {
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.discoveredPeers[peerID.displayName] = peerID
            self.discoveredPeerNames = self.discoveredPeers.keys.sorted()
        }
    }

    nonisolated func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.discoveredPeers.removeValue(forKey: peerID.displayName)
            self.discoveredPeerNames = self.discoveredPeers.keys.sorted()
        }
    }
}

extension NearbySession: MCNearbyServiceAdvertiserDelegate {
    nonisolated func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
}

extension NearbySession: MCSessionDelegate {
    nonisolated func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        Task { @MainActor [weak self] in
            self?.refreshConnectedPeers()
        }
    }

    nonisolated func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}

    nonisolated func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {}

    nonisolated func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {}

    nonisolated func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: Error?
    ) {}
}
