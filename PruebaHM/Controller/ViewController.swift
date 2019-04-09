//
//  ViewController.swift
//  PruebaHM
//
//  Created by Omar Aldair Romero Pérez on 4/9/19.
//  Copyright © 2019 Omar Aldair Romero Pérez. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOrInButton: UIButton!
    @IBOutlet weak var changeModeButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var isSignUpMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsUI()
        
        
    }
    
    
    func settingsUI(){
        let redColor = UIColor(red: CGFloat(211)/255, green: CGFloat(47)/255, blue: CGFloat(47)/255, alpha: 1.0)
        container.layer.cornerRadius = 16.0
        self.view.backgroundColor = redColor
        signUpOrInButton.backgroundColor = redColor
        
        
        
    }


    @IBAction func signUpOrInAction(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0){
            
            
            if isSignUpMode{
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        self.performSegue(withIdentifier: "mainToMap", sender: nil)
                    }
                }
            }else{
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        self.performSegue(withIdentifier: "mainToMap", sender: nil)
                    }
                }
            }
            
            
            
        }else{
            showAlert(title: "Campos vacíos", message: "Lllena todos los campos")
        }
    }
    
    
    
    @IBAction func changeModeAction(_ sender: UIButton) {
        
        if isSignUpMode{
            signUpOrInButton.setTitle("Iniciar sesión", for: .normal)
            changeModeButton.setTitle("Registrarse", for: .normal)
            isSignUpMode = false
            infoLabel.text = "¿No tienes cuenta?"
            
        }else{
            signUpOrInButton.setTitle("Registrarse", for: .normal)
            changeModeButton.setTitle("Iniciar sesión", for: .normal)
            isSignUpMode = true
            infoLabel.text = "¿Ya tienes cuenta?"
        }
        
    }
    
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

