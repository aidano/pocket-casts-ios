import SwiftUI
import PocketCastsServer

struct SearchHistoryEntry: Codable, Hashable {
    var searchTerm: String?
    var episode: EpisodeSearchResult?
    var podcast: PodcastFolderSearchResult?
}

class SearchHistoryModel: ObservableObject {
    @Published var entries: [SearchHistoryEntry] = []

    private let defaults: UserDefaults
    private let maxNumberOfEntries = 20

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.defaults = userDefaults

        self.entries = userDefaults.data(forKey: "SearchHistoryEntries").flatMap {
            try? JSONDecoder().decode([SearchHistoryEntry].self, from: $0)
        } ?? []
    }

    func add(searchTerm: String) {
        add(entry: SearchHistoryEntry(searchTerm: searchTerm))
    }

    func add(episode: EpisodeSearchResult) {
        add(entry: SearchHistoryEntry(episode: episode))
    }

    func add(podcast: PodcastFolderSearchResult) {
        add(entry: SearchHistoryEntry(podcast: podcast))
    }

    func remove(entry: SearchHistoryEntry) {
        entries.removeAll(where: { $0 == entry })

        save()
    }

    func removeAll() {
        entries = []

        save()
    }

    private func add(entry: SearchHistoryEntry) {
        entries.removeAll(where: { $0 == entry })
        entries.insert(entry, at: 0)

        save()
    }

    private func save() {
        entries = Array(entries.prefix(maxNumberOfEntries))
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            defaults.set(encoded, forKey: Constants.UserDefaults.searchHistoryEntried)
        }
    }
}
