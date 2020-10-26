//
//  MemberCard.swift
//  FamilyTree
//
//  Created by chanaka kasun bandara on 9/10/19.
//  Copyright © 2019 Elegant media. All rights reserved.
//

import UIKit

class MemberCard: UIView {
    
    // MARK: IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profilePhotoImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var viewBottomBar: UIView!
    @IBOutlet weak var frontContainerView: UIView!
    
    // MARK: Properties
    var member: Member!
    var tapActionHandler: (() -> Void)?
    
    // MARK: Life cycle
    init(frame: CGRect, member: Member) {
        super.init(frame: frame)
        
        self.member = member
        nibSetup()
        setupUI()
        config(with: member)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nibSetup()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        nibSetup()
        setupUI()
    }
    
    // MARK: IBActions
    @IBAction func btnCardPressed(_ sender: UIButton) {
        if let handler = tapActionHandler {
            handler()
        }
    }
}

extension MemberCard {
    func config(with member: Member) {
        self.member = member
        nameLbl.text = member.name ?? "N/A"
    }
    
    func config(with member: FamilyMember) {
        nameLbl.text = member.name
        dobLbl.text = member.birthDate
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func setupUI() {
        profilePhotoImgView.layer.cornerRadius = profilePhotoImgView.frame.width / 2
        profilePhotoImgView.clipsToBounds = true
        
        viewBottomBar.layer.cornerRadius = 2
        viewBottomBar.clipsToBounds = true
        
        frontContainerView.layer.cornerRadius = 2
        frontContainerView.clipsToBounds = true
        
        // set the shadow of the card
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
}
