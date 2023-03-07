//
//  ViewController.swift
//  ChatGPTDemo
//
//  Created by zhanghao on 2023/3/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(logoImgV)
        view.addSubview(organizationIdInputTF)
        view.addSubview(openAiKeyTF)
        view.addSubview(startBtn)
        
        logoImgV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.top.equalTo(150)
        }
        organizationIdInputTF.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(50)
            make.centerY.equalToSuperview().offset(-50)
        }
        openAiKeyTF.snp.makeConstraints { make in
            make.height.left.right.equalTo(organizationIdInputTF)
            make.top.equalTo(organizationIdInputTF.snp.bottom).offset(20)
        }
        startBtn.snp.makeConstraints { make in
            make.top.equalTo(openAiKeyTF.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var logoImgV: UIImageView = {
        let logoImgV = UIImageView()
        logoImgV.image = UIImage.init(named: "chatGPTAvatar")
        logoImgV.layer.masksToBounds = true
        logoImgV.layer.cornerRadius = 8
        return logoImgV
    }()
    lazy var startBtn: UIButton = {
        var startBtn = UIButton()
        startBtn.setTitle("Start", for: UIControl.State.normal)
        startBtn.layer.cornerRadius = 8
        startBtn.backgroundColor = .black
        startBtn.setTitleColor(.white, for: UIControl.State.normal)
        startBtn.addTarget(self, action: #selector(btnAction), for: UIControl.Event.touchUpInside)
        return startBtn
    }()
    
    lazy var organizationIdInputTF: UITextField = {
        var inputTF = setTF()
        inputTF.placeholder = "input organizationId..."
        return inputTF
    }()
    lazy var openAiKeyTF: UITextField = {
        var inputTF = setTF()
        inputTF.placeholder = "input openAiKey..."
        return inputTF
    }()
    
    func setTF() -> UITextField {
        let inputTF = UITextField(frame: CGRectMake(0, 0, UIScreen.main.bounds.size.width-100, 50))
        inputTF.backgroundColor = .lightGray
        inputTF.font = UIFont.systemFont(ofSize: 15)
        inputTF.textColor = .black
        inputTF.returnKeyType = .done
        inputTF.layer.cornerRadius = 8
//        inputTF.addTarget(self, action: #selector(inputTFAction(textTF:)), for: UIControl.Event.editingChanged)
        inputTF.leftViewMode = UITextField.ViewMode.always
        let leftView = UIView()
        leftView.backgroundColor = .clear
        leftView.frame = CGRect.init(x: 0, y: 0, width: 10, height: 50)
        inputTF.leftView = leftView
        return inputTF
    }
    
    @objc func btnAction() {
        let vc = BasicExampleViewController()
        vc.openAIKey = openAiKeyTF.text!
        vc.organizationId = organizationIdInputTF.text!
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true)
    }

}

