//
//  ViewController.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/7/20.
//

import UIKit

enum PathStyle {
    case CenterLevelToUp
    case CenterLevelToDown
    case BetweenCenterLevel
}

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainCard: MemberCard!
    @IBOutlet weak var spouseCard: MemberCard!
    @IBOutlet weak var mainFatherCard: MemberCard!
    @IBOutlet weak var mainMotherCard: MemberCard!
    @IBOutlet weak var spouceFatherCard: MemberCard!
    @IBOutlet weak var spouceMotherCard: MemberCard!
    @IBOutlet weak var zoomView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var parentsStackView: UIStackView!
    @IBOutlet weak var centerCoupleStackView: UIStackView!
    @IBOutlet weak var childrenStackView: UIStackView!
    
    var vm = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configUI()
        fetchMySelf()
    }
}

extension ViewController {
    func configUI() {
        [mainCard, mainFatherCard, mainMotherCard, spouseCard, spouceFatherCard, spouceMotherCard].forEach {
            $0?.isHidden = true
            $0?.alpha = 0
        }
        self.childrenStackView.alpha = 0
    }
    
    func fetchMySelf() {
        configCardWithMember(for: self.mainCard, with: ViewModel.main, isCenterMember: true)
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.mainCard.isHidden = false
            self.mainCard.alpha = 1
            
            if let _ = ViewModel.main.spouse {
                self.spouseCard.isHidden = false
                self.spouseCard.alpha = 1
            }
            if let _ = ViewModel.main.father {
                self.mainFatherCard.isHidden = false
                self.mainFatherCard.alpha = 1
            }
            if let _ = ViewModel.main.mother {
                self.mainMotherCard.isHidden = false
                self.mainMotherCard.alpha = 1
            }
            if let _ = ViewModel.main.spouse?.father {
                self.spouceFatherCard.isHidden = false
                self.spouceFatherCard.alpha = 1
            }
            if let _ = ViewModel.main.spouse?.father {
                self.spouceMotherCard.isHidden = false
                self.spouceMotherCard.alpha = 1
            }
        }
        fetchRelationsTree()
    }
    
    func configCardWithMember(for card: MemberCard, with member: Member?, isCenterMember: Bool = false) {
        guard let _member = member else {
            UIView.animate(withDuration: 0.5) {
                card.isHidden = true
                card.alpha = 0
            }
            return
        }
        card.cardPresentationStyle = .normal
        card.config(member: _member)
        if isCenterMember {
        }
        card.tapActionHandler = {
            
        }
    }
    
    func fetchRelationsTree() {
        self.configCardWithMember(for: self.spouseCard, with: ViewModel.tree.spouse)
        self.configCardWithMember(for: self.mainFatherCard, with: ViewModel.tree.father)
        self.configCardWithMember(for: self.mainMotherCard, with: ViewModel.tree.mother)
        self.configCardWithMember(for: self.spouceMotherCard, with: ViewModel.tree.spouse?.mother)
        self.configCardWithMember(for: self.spouceFatherCard, with: ViewModel.tree.spouse?.father)
        
        //create cards for children
        if let _children = ViewModel.tree.children {
            for child in _children {
                let card = MemberCard(frame: CGRect(x: 0, y: 0, width: 70, height: 95))
                card.heightAnchor.constraint(equalToConstant: 95).isActive = true
                card.widthAnchor.constraint(equalToConstant: 70).isActive = true
                self.configCardWithMember(for: card, with: child)
                self.childrenStackView.spacing = 50
                self.childrenStackView.addArrangedSubview(card)
            }
            //display children cards with fade animation
            UIView.animate(withDuration: 0.7, animations: {
                self.childrenStackView.alpha = 1
            })
        }
        
        self.zoomView.isUserInteractionEnabled = true
        
        if let _ = ViewModel.tree.father, let _ = ViewModel.tree.mother {
            self.drawRelationshipPath(from: self.mainFatherCard, to: self.mainMotherCard, style: .BetweenCenterLevel)
        }
        if let _ = ViewModel.tree.spouse?.father, let _ = ViewModel.tree.spouse?.mother {
            self.drawRelationshipPath(from: self.spouceFatherCard, to: self.spouceMotherCard, style: .BetweenCenterLevel)
        }
        if let _ = ViewModel.tree.spouse {
            self.drawRelationshipPath(from: self.mainCard, to: self.spouseCard, style: .BetweenCenterLevel)
        }
        
        //create paths for childs
        for card in self.childrenStackView.arrangedSubviews {
            self.drawRelationshipPath(from: self.mainCard, to: card, style: .CenterLevelToDown)
        }
    }
    
    func drawRelationshipPath(from fromView: UIView, to toView: UIView, style: PathStyle) {
        let startPoint = fromView.superview!.convert(fromView.center, to: zoomView)
        let endPoint = style == PathStyle.BetweenCenterLevel ?
            toView.superview!.convert(toView.center, to: zoomView) :
            CGPoint(x: (toView.center.x) , y: toView.center.y)
        
        let BezierPath = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        
        switch style {
        case .CenterLevelToUp:
            BezierPath.move(to: CGPoint(x: startPoint.x, y: startPoint.y ))
            BezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y ))
            BezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y ))
        case .CenterLevelToDown:
            return
        case .BetweenCenterLevel:
            BezierPath.move(to: CGPoint(x: startPoint.x, y: startPoint.y ))
            BezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y ))
            BezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y ))
        }
        
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.path = BezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .bevel
        
        zoomView.layer.insertSublayer(shapeLayer, below: containerStackView.layer)
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.5
        
        CATransaction.setCompletionBlock{
            print("Animation completed")
        }
        
        shapeLayer.add(animation, forKey: "myStroke")
        CATransaction.commit()
        
    }
}

extension ViewController {
    
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
