import Foundation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    private let network = NetworkManager()
    
    @Published var isLoading = false
    @Published var events: [FactEvent] = []
    @Published var errorText: String?
    
    func generate() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date.now)
        let day = calendar.component(.day, from: Date.now)
        
        do {
            let response = try await network.request(body: FactRequest(month: month, day: day))
            events = (response.events ?? []).sorted{
                // MARK: Sorted by Years
                Int($1.year ?? "") ?? 0 < Int($0.year ?? "") ?? 0
            }
            if events.isEmpty {
                errorText = "Empty file"
            }
        } catch {
            errorText = "Error: \(error.localizedDescription)"
        }
    }
}
