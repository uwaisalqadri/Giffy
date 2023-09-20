//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 20/9/23.
//

import CoreData
import Combine

final class CoreDataHelper {
  static let shared = CoreDataHelper()
  
  private static var persistentContainer: NSPersistentContainer = {
    let modelURL = Bundle.module.url(forResource: "Giphy", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    let container = NSPersistentContainer(name: "Giphy", managedObjectModel: model)
    container.loadPersistentStores { _, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()
  
  var context: NSManagedObjectContext {
    return Self.persistentContainer.viewContext
  }
  
  func isGiphyFavorited(with id: String) -> Future<Bool, Error> {
    let fetchRequest: NSFetchRequest<GiphyEntity>
    fetchRequest = GiphyEntity.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(
      format: "id == %@", "\(id)"
    )
    
    return Future { promise in
      if let favoriteItems = try? self.context.fetch(fetchRequest) {
        promise(.success(!favoriteItems.isEmpty))
      }
    }
  }
  
  func addFavoriteGiphy(item: Giphy) -> Future<Bool, Error> {
    let entity = GiphyEntity(context: context)
    entity.embedUrl = item.embedUrl
    entity.id = item.id
    entity.rating = item.rating
    entity.title = item.title
    entity.trendingDateTime = item.trendingDateTime
    entity.type = item.type
    entity.url = item.url
    entity.username = item.username
    let imageEntity = ImageOriginalEntity(context: context)
    imageEntity.url = item.image.url
    imageEntity.height = item.image.height
    imageEntity.width = item.image.width
    entity.image = imageEntity
    
    return Future { promise in
      do {
        try self.context.save()
        promise(.success(true))
      } catch {
        promise(.failure(error))
      }
    }
  }
  
  func deleteFavoriteGiphy(with id: String) -> Future<Bool, Error> {
    let fetchRequest: NSFetchRequest<GiphyEntity>
    fetchRequest = GiphyEntity.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(
      format: "id == %@", "\(id)"
    )
    
    fetchRequest.includesPropertyValues = false
    
    if let objects = try? context.fetch(fetchRequest) {
      for object in objects {
        context.delete(object)
      }
    }
    
    return Future { promise in
      do {
        try self.context.save()
        promise(.success(true))
      } catch {
        promise(.failure(error))
      }
    }
  }
  
  func getFavoriteGiphys() -> Future<[GiphyEntity], Error> {
    let fetchRequest: NSFetchRequest<GiphyEntity>
    fetchRequest = GiphyEntity.fetchRequest()
    
    return Future { promise in
      do {
        let items = try self.context.fetch(fetchRequest)
        promise(.success(items))
      } catch {
        promise(.failure(error))
      }
    }
  }
}
