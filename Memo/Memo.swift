//
//  Memo.swift
//  Memo
//
//  Created by jylee-mac on 2021/05/05.
//

import UIKit

// TODO: Codable과 Equatable 추가
struct Memo: Codable, Equatable {
    let id: Int
    var isDone: Bool
    var detail: String
    var isToday: Bool
    
    mutating func update(isDone: Bool, detail: String, isToday: Bool) {
        // TODO: update 로직 추가
        
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        // TODO: 동등 조건 추가
        return true
    }
}

class MemoManager {
    
    static let shared = MemoManager()
    
    static var lastId: Int = 0
    
    var memoes: [Memo] = []
    
    func createMemo(detail: String, isToday: Bool) -> Memo {
        //TODO: create로직 추가
        return Memo(id: 1, isDone: false, detail: "2", isToday: true)
    }
    
    func addMemo(_ memo: Memo) {
        //TODO: add로직 추가
    }
    
    func deleteMemo(_ memo: Memo) {
        //TODO: delete 로직 추가
        
    }
    
    func updateMemo(_ memo: Memo) {
        //TODO: updatee 로직 추가
        
    }
    
    func saveMemo() {
        Storage.store(memoes, to: .documents, as: "memoes.json")
    }
    
    func retrieveMemo() {
        memoes = Storage.retrive("memoes.json", from: .documents, as: [Memo].self) ?? []
        
        let lastId = memoes.last?.id ?? 0
        MemoManager.lastId = lastId
    }
}

class MemoViewModel {
    
    enum Section: Int, CaseIterable {
        case today
        case upcoming
        
        var title: String {
            switch self {
            case .today: return "Today"
            default: return "Upcoming"
            }
        }
    }
    
    private let manager = MemoManager.shared
    
    var memoes: [Memo] {
        return manager.memoes
    }
    
    var todayMemoes: [Memo] {
        return memoes.filter { $0.isToday == true }
    }
    
    var upcompingMemoes: [Memo] {
        return memoes.filter { $0.isToday == false }
    }
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    func addMemoe(_ memo: Memo) {
        manager.addMemo(memo)
    }
    
    func deleteMemo(_ memo: Memo) {
        manager.deleteMemo(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        manager.updateMemo(memo)
    }
    
    func loadTasks() {
        manager.retrieveMemo()
    }
}
