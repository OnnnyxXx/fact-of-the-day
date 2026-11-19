import Foundation

final class NetworkManager {
    private let urlString = "https://gateway.pipeworx.io/v1/tools/onthisday_get_events"

    func request(body: FactRequest) async throws -> FactResponse {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: req)
        print("RAW:", String(data: data, encoding: .utf8) ?? "nil")
        return try JSONDecoder().decode(FactResponse.self, from: data)
    }
}
