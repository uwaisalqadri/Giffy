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
  
  func isGiphyFavorited(with id: String) async throws -> Bool {
    let fetchRequest: NSFetchRequest<GiphyEntity>
    fetchRequest = GiphyEntity.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(
      format: "id == %@", "\(id)"
    )
    
    return try await self.getFavoriteGiphys().map { $0.id }.contains(id)
  }
  
  func addFavoriteGiphy(item: Giffy) async throws -> Bool {
    let entity = GiphyEntity(context: context)
    entity.id = item.id
    entity.rating = item.rating
    entity.title = item.title
    entity.trendingDateTime = item.trendingDateTime
    entity.url = item.url
    entity.username = item.username
    let imageEntity = ImageOriginalEntity(context: context)
    imageEntity.url = item.image.url
    imageEntity.height = item.image.height
    imageEntity.width = item.image.width
    entity.image = imageEntity
    
    return try await withCheckedThrowingContinuation { promise in
      do {
        try self.context.save()
        promise.resume(with: .success(true))
      } catch {
        promise.resume(with: .failure(error))
      }
    }
  }
  
  func deleteFavoriteGiphy(with id: String) async throws -> Bool {
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
    
    return try await withCheckedThrowingContinuation { promise in
      do {
        try self.context.save()
        promise.resume(with: .success(true))
      } catch {
        promise.resume(with: .failure(error))
      }
    }
  }
  
  func getFavoriteGiphys() async throws -> [GiphyEntity] {
    let fetchRequest: NSFetchRequest<GiphyEntity>
    fetchRequest = GiphyEntity.fetchRequest()
    
    return try await withCheckedThrowingContinuation { promise in
      do {
        let items = try self.context.fetch(fetchRequest)
        promise.resume(with: .success(items))
      } catch {
        promise.resume(with: .failure(error))
      }
    }
  }
}
