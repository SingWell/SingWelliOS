//
//  ProfileViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 11/8/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: AnimatableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"

        // Do any additional setup after loading the view.
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        profileImageView.image = profileImage
    }
    
//    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
//        let imageView: UIImageView = UIImageView(image: image)
//        let layer = imageView.layer
//        layer.masksToBounds = true
//        layer.cornerRadius = radius
//        UIGraphicsBeginImageContext(imageView.bounds.size)
//        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return roundedImage!
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
