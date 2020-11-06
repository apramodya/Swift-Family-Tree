//
//  TreeVC.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/22/20.
//

import UIKit

class TreeVC: UIViewController {
    
    var mainMember: FamilyMember?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var zoomView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var centerStackView: UIStackView!
    @IBOutlet weak var mainCard: MemberCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 3.0
        
        mainMember = makeFamily()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configCardWithMember(for: mainCard, with: mainMember)
        addMemberCards(for: mainMember)
    }
    
    private func makeFamily() -> FamilyMember {
        let person = FamilyMember(name: "Person", birthDate: "1995/06/14")
        let personMother = FamilyMember(name: "Mother")
        let personFather = FamilyMember(name: "Father")
        
        let grandMotherF = FamilyMember(name: "Father's mom")
        let grandFatherF = FamilyMember(name: "Father's dad")
        personFather.addParent(mother: grandMotherF, father: grandFatherF)
        
        let grandMotherM = FamilyMember(name: "Mother's mom")
        let grandFatherM = FamilyMember(name: "Mother's dad")
        personMother.addParent(mother: grandMotherM, father: grandFatherM)
        
        let personSibling1 = FamilyMember(name: "Sibling 1")
        let personSibling2 = FamilyMember(name: "Sibling 2")
        
        let personSpouse = FamilyMember(name: "Person spouse", birthDate: "1995/10/14")
        let personSpouseMother = FamilyMember(name: "Person spouse mother")
        let personSpouseFather = FamilyMember(name: "Person spouse father")
        
        let personSon1 = FamilyMember(name: "Person son 1")
        let personSon2 = FamilyMember(name: "Person son 2")
        
        person.addParent(mother: personMother, father: personFather)
        person.addSibling(sibling: personSibling1)
        person.addSibling(sibling: personSibling2)
        person.addSpouse(spouse: personSpouse)
        personSpouse.addParent(mother: personSpouseMother, father: personSpouseFather)
        person.addChild(child: personSon1)
        person.addChild(child: personSon2)
        
        return person
    }
}

extension TreeVC {
    private func configCardWithMember(for card: MemberCard, with member: FamilyMember?) {
        guard let member = member else {
            UIView.animate(withDuration: 0.5) {
                card.isHidden = true
                card.alpha = 0
            }
            return
        }
        
        card.config(with: member)
        
        card.tapActionHandler = {
        }
    }
    
    private func addMemberCards(for member: FamilyMember?) {
        guard let member = member else { return }
        
        populateSpouse(for: member)
        
        populateParents(for: member)
        
        populateChildren(for: member)
        
        populateSiblings(for: member)
    }
    
    private func populateParents(for member: FamilyMember, view: UIStackView? = nil) {
        if member.haveParents() {
            let parentsSV = createStackView(.horizontal)
            
            if let view = view {
                view.insertArrangedSubview(parentsSV, at: 0)
            } else {
                containerStackView.insertArrangedSubview(parentsSV, at: 0)
            }
            
            if let father = member.getFather() {
                let fatherSV = createStackView(.vertical)
                let card = createCard(for: father)
                fatherSV.addArrangedSubview(card)
                
                parentsSV.addArrangedSubview(fatherSV)
                
                if father.haveParents() {
                    populateParents(for: father, view: fatherSV)
                }
            }
            
            if let mother = member.getMother() {
                let motherSV = createStackView(.vertical)
                let card = createCard(for: mother)
                motherSV.addArrangedSubview(card)
                parentsSV.addArrangedSubview(motherSV)
                
                if mother.haveParents() {
                    populateParents(for: mother, view: motherSV)
                }
            }
        }
    }
    
    private func populateSpouse(for member: FamilyMember) {
        if let spouse = member.getSpouse() {
            let card = createCard(for: spouse)
            centerStackView.spacing = 20
            centerStackView.addArrangedSubview(card)
            
            let views = centerStackView.arrangedSubviews
            drawRelationshipPath(from: [views[0]], to: [views[1]], style: .HorizontalLevel)
        }
    }
    
    private func populateChildren(for member: FamilyMember) {
        if member.childrenCount() > 0 {
            let childrenStackView = createStackView(.horizontal)
            containerStackView.addArrangedSubview(childrenStackView)
            
            let children = member.getChildren().compactMap{ $0 }
            
            children.forEach { child in
                let card = createCard(for: child)
                childrenStackView.addArrangedSubview(card)
            }
        }
    }
    
    private func populateSiblings(for member: FamilyMember) {
        if member.getSiblingsCount() > 0 {
            let siblingsStackView = createStackView(.horizontal)
            centerStackView.addArrangedSubview(siblingsStackView)
            
            let siblings = member.getSiblings().compactMap{ $0 }
            
            siblings.forEach { sibling in
                let card = createCard(for: sibling)
                siblingsStackView.addArrangedSubview(card)
            }
        }
    }
    
    private func createCard(for member: FamilyMember?) -> MemberCard {
        let card = MemberCard(frame: CGRect(x: 0, y: 0, width: 70, height: 95))
        card.heightAnchor.constraint(equalToConstant: 95).isActive = true
        card.widthAnchor.constraint(equalToConstant: 70).isActive = true
        configCardWithMember(for: card, with: member)
        
        return card
    }
    
    private func createStackView(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = .fill
        stackView.alignment = axis == .vertical ? .center : .bottom
        stackView.spacing = 20
        
        return stackView
    }
}

extension TreeVC {
    private func drawRelationshipPath(from fromViews: [UIView], to toViews: [UIView], style: PathStyle) {
        func calculateStartPoint(_ fromViews: [UIView]) -> CGPoint {
            var startPoint: CGPoint!
            
            if fromViews.count == 1, let fromView = fromViews.first {
                startPoint = fromView.superview!.convert(fromView.center, to: zoomView)
            } else if fromViews.count == 2 {
                let fromView1Point = fromViews[0].superview!.convert(fromViews[0].center, to: zoomView)
                let fromView2Point = fromViews[1].superview!.convert(fromViews[1].center, to: zoomView)
                
                startPoint = CGPoint(x: (fromView1Point.x + fromView2Point.x) / 2, y: fromView1Point.y)
            }
            
            return startPoint
        }
        
        func calculateEndPoint(_ toViews: [UIView]) -> CGPoint {
            var endPoint: CGPoint!
            
            if toViews.count == 1, let toView = toViews.first {
                endPoint = toView.superview!.convert(toView.center, to: zoomView)
            } else {
                let firstIndex = 0
                let lastIndex = toViews.count - 1
                let toView1Point = toViews[firstIndex].superview!.convert(toViews[firstIndex].center, to: zoomView)
                let toView2Point = toViews[lastIndex].superview!.convert(toViews[lastIndex].center, to: zoomView)
                
                endPoint = CGPoint(x: (toView1Point.x + toView2Point.x) / 2, y: toView1Point.y)
            }
            
            return endPoint
        }
        
        var startPoint: CGPoint!
        var endPoint: CGPoint!
        
        startPoint =  calculateStartPoint(fromViews)
        endPoint = calculateEndPoint(toViews)
        
        // draw lines
        let bezierPath = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        
        bezierPath.move(to: CGPoint(x: startPoint.x, y: startPoint.y ))
        bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y ))
        
        switch style {
        case .HorizontalLevel, .VerticalDownToUp:
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y ))
        case .VerticalUpToDown:
            let centrePoint = CGPoint(x: endPoint.x, y: endPoint.y - 50)
            bezierPath.addLine(to: centrePoint)
            
            toViews.forEach { toView in
                let finalPoint = toView.superview!.convert(toView.center, to: zoomView)
                bezierPath.move(to: centrePoint)
                bezierPath.addLine(to: CGPoint(x: finalPoint.x, y: finalPoint.y - 50))
                bezierPath.addLine(to: CGPoint(x: finalPoint.x, y: finalPoint.y))
            }
        }
        
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .bevel
        
        zoomView.layer.insertSublayer(shapeLayer, below: containerStackView.layer)
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.5
        
        shapeLayer.add(animation, forKey: "myStroke")
        CATransaction.commit()
    }
    
    private func makeDot(startPoint: CGPoint, color: UIColor) -> CAShapeLayer {
        let xCoord = startPoint.x
        let yCoord = startPoint.y

        let xx = CGRect(x: xCoord, y: yCoord, width: 8, height: 8)
        let dotPath = UIBezierPath(ovalIn: xx)

        let layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.strokeColor = color.cgColor
        
        return layer
    }
}

// MARK: UIScrollViewDelegate
extension TreeVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
}
