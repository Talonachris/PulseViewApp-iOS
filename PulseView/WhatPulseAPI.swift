import Foundation

struct WhatPulseAPI {
    static func fetchUser(username: String, completion: @escaping (WhatPulseUser?) -> Void) {
        let urlString = "https://whatpulse.org/api/v1/users/\(username)"
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let bearerToken = Secrets.whatPulseAPIKey

        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(WhatPulseAPIResponse.self, from: data)
                completion(response.user)
            } catch {
                print("⚠️ Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
