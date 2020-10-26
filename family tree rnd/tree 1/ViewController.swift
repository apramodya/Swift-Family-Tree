//
//  ViewController.swift
//  family tree rnd
//
//  Created by Pramodya Abeysinghe on 10/7/20.
//

import UIKit

enum PathStyle {
    case VerticalDownToUp
    case VerticalUpToDown
    case HorizontalLevel
}

class ViewController: UIViewController {
    
    // MARK: IBOutlets
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
    
    // MARK: Properties
    var vm = ViewModel()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMySelf()
    }
}

extension ViewController {
    private func configUI() {
        [mainCard, mainFatherCard, mainMotherCard, spouseCard, spouceFatherCard, spouceMotherCard].forEach {
            $0?.isHidden = true
            $0?.alpha = 0
        }
        childrenStackView.alpha = 0
        scrollView.delegate = self
    }
    
    private func fetchMySelf() {
        configCardWithMember(for: mainCard, with: ViewModel.main)
        
        UIView.animate(withDuration: 0.5) { [self] in
            mainCard.isHidden = false
            mainCard.alpha = 1
            spouseCard.isHidden = ViewModel.main.spouse == nil
            spouseCard.alpha = ViewModel.main.spouse != nil ? 1 : 0
            mainFatherCard.isHidden = ViewModel.main.father == nil
            mainFatherCard.alpha = ViewModel.main.father != nil ? 1 : 0
            mainMotherCard.isHidden = ViewModel.main.mother == nil
            mainMotherCard.alpha = ViewModel.main.mother != nil ? 1 : 0
            spouceFatherCard.isHidden = ViewModel.main.spouse?.father == nil
            spouceFatherCard.alpha = ViewModel.main.spouse?.father != nil ? 1 : 0
            spouceMotherCard.isHidden = ViewModel.main.spouse?.father == nil
            spouceMotherCard.alpha = ViewModel.main.spouse?.father != nil ? 1 : 0
        }
        
        fetchRelationsTree()
    }
    
    private func configCardWithMember(for card: MemberCard, with member: Member?) {
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
    
    private func fetchRelationsTree() {
        configCardWithMember(for: spouseCard, with: ViewModel.tree.spouse)
        configCardWithMember(for: mainFatherCard, with: ViewModel.tree.father)
        configCardWithMember(for: mainMotherCard, with: ViewModel.tree.mother)
        configCardWithMember(for: spouceMotherCard, with: ViewModel.tree.spouse?.mother)
        configCardWithMember(for: spouceFatherCard, with: ViewModel.tree.spouse?.father)
        
        //create cards for children
        if let _children = ViewModel.tree.children {
            for child in _children {
                let card = MemberCard(frame: CGRect(x: 0, y: 0, width: 70, height: 95))
                card.heightAnchor.constraint(equalToConstant: 95).isActive = true
                card.widthAnchor.constraint(equalToConstant: 70).isActive = true
                configCardWithMember(for: card, with: child)
                childrenStackView.spacing = 50
                childrenStackView.addArrangedSubview(card)
            }
            //display children cards with fade animation
            UIView.animate(withDuration: 0.7, animations: {
                self.childrenStackView.alpha = 1
            })
        }
        
        zoomView.isUserInteractionEnabled = true
        
        if let _ = ViewModel.tree.father, let _ = ViewModel.tree.mother {
            drawRelationshipPath(from: [mainFatherCard], to: [mainMotherCard], style: .HorizontalLevel)
            drawRelationshipPath(from: [mainCard], to: [mainFatherCard, mainMotherCard], style: .VerticalDownToUp)
        }
        
        if let _ = ViewModel.tree.spouse?.father, let _ = ViewModel.tree.spouse?.mother {
            drawRelationshipPath(from: [spouceFatherCard], to: [spouceMotherCard], style: .HorizontalLevel)
            drawRelationshipPath(from: [spouseCard], to: [spouceFatherCard, spouceMotherCard], style: .VerticalDownToUp)
        }
        
        if let _ = ViewModel.tree.spouse {
            drawRelationshipPath(from: [mainCard], to: [spouseCard], style: .HorizontalLevel)
        }
        
        if let _ = ViewModel.tree.children {
            drawRelationshipPath(from: [mainCard, spouseCard], to: childrenStackView.arrangedSubviews, style: .VerticalUpToDown)
        }
    }
    
    private func calculateStartPoint(_ fromViews: [UIView]) -> CGPoint {
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
    
    private func calculateEndPoint(_ toViews: [UIView]) -> CGPoint {
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
    
    private func drawRelationshipPath(from fromViews: [UIView], to toViews: [UIView], style: PathStyle) {
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
}

// MARK: UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
}

// MARK: CGPoint
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
