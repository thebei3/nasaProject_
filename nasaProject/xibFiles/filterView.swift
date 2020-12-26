//
//  filterView.swift
//  nasaProject
//
//  Created by orhun akmil on 26.12.2020.
//

import UIKit

class filterView: UIView {

   
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder : NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        guard let view = self.loadViewFromNib(nibName: "filterView") else {return}
        settingViews()
        view.frame = self.bounds
        self.addSubview(view)
    }

    func settingViews() {
        
        
        button1.layer.borderWidth = 0.5
        button1.layer.cornerRadius = 5
        
        button2.layer.borderWidth = 0.5
        button2.layer.cornerRadius = 5
        
        button3.layer.borderWidth = 0.5
        button3.layer.cornerRadius = 5
        
        button4.layer.borderWidth = 0.5
        button4.layer.cornerRadius = 5
        
        button5.layer.borderWidth = 0.5
        button5.layer.cornerRadius = 5
        
        button6.layer.borderWidth = 0.5
        button6.layer.cornerRadius = 5
        
        button7.layer.borderWidth = 0.5
        button7.layer.cornerRadius = 5
        
        button8.layer.borderWidth = 0.5
        button8.layer.cornerRadius = 5
        
        button9.layer.borderWidth = 0.5
        button9.layer.cornerRadius = 5
        
        button10.layer.borderWidth = 0.5
        button10.layer.cornerRadius = 5
        
    }
}
