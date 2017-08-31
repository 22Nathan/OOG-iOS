//
//  TelLoginViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class TelLoginViewController: UIViewController,UITextFieldDelegate {

    //Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var cellPhoneTextField: UITextField!{
        didSet{
            cellPhoneTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
