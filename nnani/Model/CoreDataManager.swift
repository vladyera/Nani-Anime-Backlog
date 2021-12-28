//
//  CoreDataManager.swift
//  nnani
//
//  Created by Uladzislau Yerashevich on 12/22/21.
//

import Foundation
import CoreData

class CoreDataManager {
    private let entityName = "Anime"
    
    init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AnimeDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        return container
    }()
    
    func saveAnime(anime: Anime,isWatched: Bool) {
        let context = persistentContainer.viewContext
        if let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            let animeMO = AnimeShowMO(entity: entityDescription, insertInto: context)
            animeMO.id = UUID()
            animeMO.isWatched = isWatched
            animeMO.idForSearch = anime.apiID
            animeMO.title = anime.title
            animeMO.largePosterURL = anime.largePoster
            animeMO.smallPosterURL = anime.smallPoster
            animeMO.summary = anime.summary
            try? context.save()
            print("Saved")
        }
    }
    
    func updateStatus(anime: Anime, isWatched: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = persistentContainer.viewContext
        guard let result = try? persistentContainer.viewContext.fetch(request) as? [AnimeShowMO] else { return }
        for fetchedAnime in result {
            if fetchedAnime.id == anime.id {
                fetchedAnime.isWatched = isWatched
            }
        }
        try? context.save()
    }
    
    func fetchAnime() -> [Anime] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        guard let result = try? persistentContainer.viewContext.fetch(request) as? [AnimeShowMO] else { return [] }
        let mappedResult = result.map { animeMO in
            Anime(id: animeMO.id!, apiID: animeMO.idForSearch!, title: animeMO.title!, summary: animeMO.summary!, smallPoster: animeMO.smallPosterURL!, largePoster: animeMO.largePosterURL!, isWatched: animeMO.isWatched)
        }
        return mappedResult
    }
    
    func deleteAnime(anime: Anime) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = persistentContainer.viewContext
        guard let result = try? persistentContainer.viewContext.fetch(request) as? [AnimeShowMO] else { return }
        for fetchedAnime in result {
            if fetchedAnime.id == anime.id {
                context.delete(fetchedAnime)
            }
        }
        try? context.save()
    }
}
