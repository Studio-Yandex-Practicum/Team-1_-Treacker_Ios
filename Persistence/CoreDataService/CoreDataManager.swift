//
//  CoreDataManager.swift
//  Persistence
//
//  Created by Глеб Хамин on 04.04.2025.
//

import CoreData
import Core

protocol CoreDataManagerProtocol {
    func fetch<T: NSManagedObject>(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func save<T: NSManagedObject>(_ block: (T, NSManagedObjectContext) -> Void)
    func delete<T: NSManagedObject>(_ object: T)
}

final class CoreDataManager {
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        guard let modelURL = Bundle(for: CoreDataManager.self).url(forResource: "SpendWise", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            Logger.shared.log(.error, message: "❌ 💾 Не удалось найти или загрузить модель CoreData SpendWise")
            fatalError("❌ 💾 Не удалось найти или загрузить модель CoreData SpendWise")
        }
        persistentContainer = NSPersistentContainer(name: "SpendWise", managedObjectModel: model)

        let semaphore = DispatchSemaphore(value: 0)
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                Logger.shared.log(.error, message: "❌ 💾 Ошибка загрузки Core Data: \(error.localizedDescription)")
                fatalError("❌ 💾 Ошибка загрузки Core Data: \(error.localizedDescription)")
            }
            semaphore.signal()
        }

        semaphore.wait()
        Logger.shared.log(.info, message: "✅ 💾 Core Data загружена успешно")
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else {
            Logger.shared.log(.info, message: "🟡 💾 Нет изменений в переданном context Core Data ")
            return
        }

        do {
            try context.save()
            Logger.shared.log(.info, message: "✅ 💾 Данные успешно сохранены в Core Data ")
        } catch {
            Logger.shared.log(.error, message: "❌ 💾 Ошибка сохранения в Core Data: \(error.localizedDescription)")
        }
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    func fetch<T: NSManagedObject>(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors == [] ? nil : sortDescriptors

        do {
            let result = try context.fetch(request) as? [T]
            Logger.shared.log(.info, message: "✅ 💾 Запрос данных в CoreData прошел успешно")
            return result ?? []
        } catch {
            Logger.shared.log(.error, message: "❌ 💾 Ошибка получения данных из Core Data: \(error.localizedDescription)")
            return []
        }
    }

    func save<T: NSManagedObject>(_ block: (T, NSManagedObjectContext) -> Void) {
        let entityName = String(describing: T.self)

        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context),
              let object = NSManagedObject(entity: entity, insertInto: context) as? T else {
            Logger.shared.log(.error, message: "❌ 💾 Не удалось получить описание сущности \(entityName)")
            return
        }

        block(object, context)
        saveContext(context)
    }

    func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
        saveContext(context)
        Logger.shared.log(.info, message: "✅ 🗑️ 💾 Объект \(T.self) удалён")
    }
}
