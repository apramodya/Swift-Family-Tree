//
//  ViewModel.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/7/20.
//

import Foundation

class ViewModel {
    
    static var mainFather: Member = Member(_id: 1, name: "Father 1", fatherId: nil, motherId: nil, spouseId: nil, father: nil, mother: nil, spouse: nil)
    static var mainMother: Member = Member(_id: 2, name: "Mother 2", fatherId: nil, motherId: nil, spouseId: nil, father: nil, mother: nil, spouse: nil)
    
    static var main: Member = Member(_id: 0, name: "Husband", fatherId: 1, motherId: 2, spouseId: 5, father: mainFather, mother: mainMother, spouse: spouce)
    
    static var spouceFather: Member = Member(_id: 3, name: "Father 2", fatherId: nil, motherId: nil, spouseId: nil, father: nil, mother: nil, spouse: nil)
    static var spouceMother: Member = Member(_id: 4, name: "Mother 2", fatherId: nil, motherId: nil, spouseId: nil, father: nil, mother: nil, spouse: nil)
    
    static var spouce: Member = Member(_id: 5, name: "Wife", fatherId: 3, motherId: 4, spouseId: 0, father: spouceFather, mother: spouceMother, spouse: nil)
    
    static var son1: Member = Member(_id: 6, name: "Son 1", fatherId: 0, motherId: 5, spouseId: nil, father: main, mother: spouce, spouse: nil)
    static var son2: Member = Member(_id: 7, name: "Son 2", fatherId: 0, motherId: 5, spouseId: nil, father: main, mother: spouce, spouse: nil)
    
    static var tree: Tree = Tree(_id: 00, father: mainFather, mother: mainMother, spouse: spouce, children: [son1, son2])
}
