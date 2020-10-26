//
//  FamilyMember.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/22/20.
//

import Foundation

class FamilyMember {
    var name: String
    var birthDate: String? = nil
    private var mother: FamilyMember?
    private var father: FamilyMember?
    private var spouse: FamilyMember?
    private var siblings = [FamilyMember]()
    private var children = [FamilyMember]()
    
    init(name: String, birthDate: String? = nil) {
        self.name = name
        self.birthDate = birthDate
    }
    
    // Set methods
    func addParent(mother: FamilyMember?, father: FamilyMember?) {
        if let mother = mother {
            self.mother = mother
        }
        
        if let father = father {
            self.father = father
        }
    }
    
    func addSibling(sibling: FamilyMember) {
        self.siblings.append(sibling)
    }
    
    func addChild(child: FamilyMember) {
        self.children.append(child)
    }
    
    func addSpouse(spouse: FamilyMember) {
        self.spouse = spouse
    }
    
    // Get methods
    func getMother() -> FamilyMember? {
        return mother
    }
    
    func getFather() -> FamilyMember? {
        return father
    }
    
    func haveParents() -> Bool {
        return mother != nil || father != nil
    }
    
    func getSpouse() -> FamilyMember? {
        return spouse
    }
    
    func childrenCount() -> Int {
        return children.count
    }
    
    func getChildren() -> [FamilyMember?] {
        return children
    }
    
    func getSiblingsCount() -> Int {
        return siblings.count
    }
    
    func getSiblings() -> [FamilyMember?] {
        return siblings
    }
}
