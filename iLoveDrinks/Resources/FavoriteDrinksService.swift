//
//  FavoriteDrinksService.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 27/10/2022.
//

import CoreData
import Foundation
import RxSwift

protocol FavoriteDrinksDataServicable {
    var savedEntities: [FavoriteDrink] { get set }
    var savedFavoriteDrinksSubjectObservable: Observable<[FavoriteDrink]> { get }
    func updateFavorites(drink: Drink)
    func isDrinkFavorite(drink: Drink) -> Bool
    func getFavorites()
}

/// Implementation of FavoriteDrinksDataServicable protocol. Managing container with saved-to-favorites drinks.
///
///  This particular object manages it with the use of Core Data.
///  Object provides capability of CRUD funcionalities:
///  - Creating new drink entity in Favorites
///  - Reading all saved drinks
///  - Updating entities
///  - Deleting drinks from favorites
final class FavoriteDrinksDataService: FavoriteDrinksDataServicable {
    
    // MARK: Core Data properties
    private var container: NSPersistentContainer
    private var containerName: String = "FavoriteDrinks"
    private let entityName: String = "FavoriteDrink"
    
    // MARK: RxSwift properties
    private let disposeBag = DisposeBag()
    private var savedFavoriteDrinksSubject = PublishSubject<[FavoriteDrink]>()
    var savedFavoriteDrinksSubjectObservable: Observable<[FavoriteDrink]> {
        return savedFavoriteDrinksSubject.asObservable()
    }
    var savedEntities: [FavoriteDrink] = []
    
    // MARK: Singleton design
    
    static let shared = FavoriteDrinksDataService()
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print(error)
            } else {
                print("No errors loading core data container")
                self.getFavorites()
            }
        }
    }
    
    
    /// Is drink already in favorite container?
    /// - Parameter drink: drink wanted to be checked
    /// - Returns: whether given drink exists in container
    func isDrinkFavorite(drink: Drink) -> Bool {
        if savedEntities.first(where: { $0.id == drink.id }) != nil {
            return true
        } else {
            return false
        }
    }
    
    
    /// Fetch favorite drinks from container and publish fetched data
    func getFavorites() {
        let request = NSFetchRequest<FavoriteDrink>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            savedFavoriteDrinksSubject.onNext(savedEntities)
        } catch {
            print("Error fetching Favorite drinks: \(error)")
        }
    }
    
    
    /// Updating container with current drink
    ///
    /// Method checks if given drink already exists in container. If so - it will be deleted. Otherwise, add it.
    /// - Parameter drink: drink wanted to be updated
    func updateFavorites(drink: Drink) {
        if let entity = savedEntities.first(where: { $0.id == drink.id }) {
            delete(entity: entity)
        } else {
            add(drink: drink)
        }
    }
    
    
    /// Forming new entity with values of given drink, adding to context and saving it.
    /// - Parameter drink: drink wanted to be added.
    private func add(drink: Drink) {
        let entity = FavoriteDrink(context: container.viewContext)
        
        entity.id = drink.id
        entity.name = drink.name
        entity.imagePath = drink.imageURL
        
        applyChanges()
    }
    
    /// Deleting drink from container and saving changes
    /// - Parameter drink: drink wanted to be added.
    private func delete(entity: FavoriteDrink) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    /// Saving current context of container
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to Core Data!!! \(error)")
        }
    }
    
    /// Applying changes in container
    ///
    /// Applying changes contains saving container's context and immediately fetch updated container
    /// Updating it will also propagate newly saved drinks to the subject's subscribers.
    private func applyChanges() {
        save()
        getFavorites()
    }
    
}
