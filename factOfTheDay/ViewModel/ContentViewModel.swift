import Foundation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    private let network = NetworkManager()
    
    @Published var isLoading = false
    @Published var events: [FactEvent] = []
    @Published var errorText: String?
    
    @Published var isToday: Bool = true
    @Published var selectedDate: Date = Date()
    
    func generate() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }
        
        let targetDate = isToday ? Date() : selectedDate
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: targetDate)
        let day = calendar.component(.day, from: targetDate)
        
        do {
            let response = try await network.request(body: FactRequest(month: month, day: day))
            
            events = (response.events ?? []).sorted {
                Int($1.year ?? "") ?? 0 < Int($0.year ?? "") ?? 0
            }
            
            if events.isEmpty {
                errorText = "No facts found for this date."
            }
        } catch {
            errorText = "Error: \(error.localizedDescription)"
        }
    }
}
