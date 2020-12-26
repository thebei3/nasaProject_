//
//  popUpView.swift
//  nasaProject
//
//  Created by orhun akmil on 24.12.2020.
//

import UIKit

@IBDesignable
final class popUpView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateOfPhotoCapture: UILabel!
    @IBOutlet weak var cameraName: UILabel!
    @IBOutlet weak var missionStatus: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var landingDate: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var view:UIView!

    
    override init(frame:CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder : NSCoder) {
        super.init(coder: coder)
        commonInit()
    }


    private func commonInit() {
        guard let view = self.loadViewFromNib(nibName: "popUpView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
    }
   
}
    


