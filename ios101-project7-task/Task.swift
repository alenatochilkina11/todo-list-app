//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    
    static var taskKey: String {
        return "task"
    }
    
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(tasks)
        // 3.
        defaults.set(encodedData, forKey: Task.taskKey)
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        if let data = defaults.data(forKey: Task.taskKey) {
            // 3.
            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
            // 4.
            return decodedTasks
        } else {
            // 5.
            return []
        }
    }

    // Add a new task or update an existing task with the current task.
    func save() {
        // 1. get array of tasks
        var tasks = Task.getTasks()
        // 2. check if the task already exists
        // 2.1: if exists, update the task
        // 2.2: if doesn't add the task to the list
        if let i = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks.remove(at: i)
            tasks.insert(self, at: i)
        } else {
            tasks.append(self)
        }
        // 3. save the array to user defaults
        Task.save(tasks)
    }
}
