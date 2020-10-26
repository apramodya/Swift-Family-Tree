//
//  ViewModel.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/7/20.
//

import Foundation

class ViewModel {
    
    static var mainFather: Member = Member(name: "Father 1", father: nil, mother: nil, spouse: nil)
    static var mainMother: Member = Member(name: "Mother 2", father: nil, mother: nil, spouse: nil)
    
    static var main: Member = Member(name: "Husband", father: mainFather, mother: mainMother, spouse: spouce)
    
    static var spouceFather: Member = Member(name: "Father 2", father: nil, mother: nil, spouse: nil)
    static var spouceMother: Member = Member(name: "Mother 2", father: nil, mother: nil, spouse: nil)
    
    static var spouce: Member = Member(name: "Wife", father: spouceFather, mother: spouceMother, spouse: nil)
    
    static var son1: Member = Member(name: "Son 1", father: main, mother: spouce, spouse: nil)
    static var son2: Member = Member(name: "Son 2", father: main, mother: spouce, spouse: nil)
    static var son3: Member = Member(name: "Son 3", father: main, mother: spouce, spouse: nil)
    
    static var tree: Tree = Tree(_id: nil, father: mainFather, mother: mainMother, spouse: spouce, children: [son1, son2, son3, son1])
}
