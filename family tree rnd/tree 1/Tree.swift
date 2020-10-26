//
//  Tree.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/7/20.
//

import Foundation

public struct Tree: Codable {

    public var _id: Int?
    public var father: Member?
    public var mother: Member?
    public var spouse: Member?
    public var children: [Member]?

    public init(_id: Int?, father: Member?, mother: Member?, spouse: Member?, children: [Member]?) {
        self._id = _id
        self.father = father
        self.mother = mother
        self.spouse = spouse
        self.children = children
    }

    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case father
        case mother
        case spouse
        case children
    }
}
