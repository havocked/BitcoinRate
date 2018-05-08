//
//  NibSettable.swift
//  The Grid
//
//  Created by Anonymous
//

import UIKit

/// This class allow to easily instantiate a view with its .xib file in the project
class NibSettable: UIView {
    
    var contentView: UIView!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    fileprivate func xibSetup() {
        self.contentView = loadViewFromNib()
        self.addSubview(self.contentView)
        self.contentView.frame = bounds
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth .union(.flexibleHeight)
        setupUI()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setupUI() {}
}
