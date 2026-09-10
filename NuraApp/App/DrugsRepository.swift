import Foundation

public struct DrugInfo: Codable, Equatable, Identifiable {
    public let id: String
    public let name: String
    public let description: String?
    public let aliases: [String]?
}

final class DrugsRepository {
    private var itemsById: [String: DrugInfo] = [:]
    private var isLoaded = false

    func info(for id: String) -> DrugInfo? {
        if !isLoaded { load() }
        return itemsById[id]
    }

    private func load() {
        defer { isLoaded = true }
        guard let url = Bundle.main.url(forResource: "drugs", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let list = try JSONDecoder().decode([DrugInfo].self, from: data)
            itemsById = Dictionary(uniqueKeysWithValues: list.map { ($0.id, $0) })
        } catch {
            // Silent fail; caller will get nil
        }
    }
}
