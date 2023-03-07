//
//  ZHChatSettingViewController.swift
//  swiftDemo2
//
//  Created by zhanghao on 2023/3/7.
//  Copyright © 2023 张浩. All rights reserved.
//

import UIKit

class ZHChatSettingViewController: UIViewController {
    typealias ChatSettingCompletion = (_ on:Bool,_ imgSize:String,_ modelStr:String,_ system:String)->Void
    var itemArr : NSMutableArray = []
    var modelItemArr : NSMutableArray = []
    var chatSettingCompletion : ChatSettingCompletion?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(voiceL)
        view.addSubview(voiceSwitch)
        view.addSubview(modelL)
        view.addSubview(modelBtn)
        view.addSubview(questionmarkBtn)
        view.addSubview(systemL)
        view.addSubview(systeTF)
        view.addSubview(questionmarkBtn2)
    
        voiceL.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.left.equalTo(20)
        }
        voiceSwitch.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(voiceL)
        }
        modelL.snp.makeConstraints { make in
            make.left.equalTo(voiceL)
            make.top.equalTo(voiceL.snp.bottom).offset(50)
        }
        questionmarkBtn.snp.makeConstraints { make in
            make.left.equalTo(modelL.snp.right).offset(10)
            make.centerY.equalTo(modelL)
            make.height.width.equalTo(20)
        }
        modelBtn.snp.makeConstraints { make in
            make.height.right.equalTo(voiceSwitch)
            make.centerY.equalTo(modelL)
            make.width.equalTo(180)
        }
        systemL.snp.makeConstraints { make in
            make.left.equalTo(modelL)
            make.top.equalTo(modelL.snp.bottom).offset(50)
        }
        questionmarkBtn2.snp.makeConstraints { make in
            make.left.equalTo(systemL.snp.right).offset(10)
            make.centerY.equalTo(systemL)
            make.height.width.equalTo(20)
        }
        systeTF.snp.makeConstraints { make in
            make.height.right.equalTo(voiceSwitch)
            make.left.equalTo(systemL.snp.right).offset(50)
            make.centerY.equalTo(systemL)
        }
        systemL.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
    }
    lazy var modelBtn: UIButton = {
        var modelBtn = UIButton()
        modelBtn.backgroundColor = .lightGray
        modelBtn.layer.cornerRadius = 8.0
        modelBtn.setTitleColor(.black, for: UIControl.State.normal)
        modelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        modelBtn.setTitle("text-davinci-003", for: UIControl.State.normal)
        return modelBtn
    }()
    lazy var voiceL: UILabel = {
        var voiceL = UILabel()
        voiceL.textColor = .black
        voiceL.font = UIFont.systemFont(ofSize: 15)
        voiceL.text = "文本朗读"
        return voiceL
    }()
    lazy var modelL: UILabel = {
        var modelL = UILabel()
        modelL.textColor = .black
        modelL.font = UIFont.systemFont(ofSize: 15)
        modelL.text = "模型"
        return modelL
    }()
    lazy var systemL: UILabel = {
        var systemL = UILabel()
        systemL.textColor = .black
        systemL.font = UIFont.systemFont(ofSize: 15)
        systemL.text = "ChatGPT角色"
        return systemL
    }()
    lazy var systeTF: UITextField = {
        var inputTF = UITextField(frame: CGRectMake(0, 0, UIScreen.main.bounds.size.width-130, 36))
        inputTF.backgroundColor = .lightGray
        inputTF.font = UIFont.systemFont(ofSize: 15)
        inputTF.textColor = .black
        inputTF.placeholder = "请输入..."
//        inputTF.delegate = self
        inputTF.returnKeyType = .done
        inputTF.layer.cornerRadius = 5
//        inputTF.addTarget(self, action: #selector(inputTFAction(textTF:)), for: UIControl.Event.editingChanged)
        inputTF.leftViewMode = UITextField.ViewMode.always
        let leftView = UIView()
        leftView.backgroundColor = .clear
        leftView.frame = CGRect.init(x: 0, y: 0, width: 10, height: 30)
        inputTF.leftView = leftView
        return inputTF
    }()
    lazy var voiceSwitch: UISwitch = {
        var voiceSwitch = UISwitch()
        voiceSwitch.onTintColor = .black
//        voiceSwitch.isOn = self.voiceOn
        voiceSwitch.addTarget(self, action: #selector(voiceSwitchAction(sender:)), for: .valueChanged)
        return voiceSwitch
    }()
    lazy var questionmarkBtn: UIButton = {
        var questionmarkBtn = UIButton()
        questionmarkBtn.setImage(UIImage(systemName: "questionmark.circle"), for: UIControl.State.normal)
        questionmarkBtn.addTarget(self, action: #selector(questionmarkBtnAction), for: UIControl.Event.touchUpInside)
        return questionmarkBtn
    }()
    @objc func questionmarkBtnAction() {
        let vc: PanModalPresentable.LayoutType = ZHChatModelIntroduceViewController()
        let introduceVC : ZHChatModelIntroduceViewController = vc as! ZHChatModelIntroduceViewController
        introduceVC.titleL.text = "gpt-3.5-turbo: 最强大的GPT-3.5模型，并以text-davinci-003的1/10的成本优化聊天。将使用我们最新的模型迭代进行更新，总之速快更快了，价格更便宜了。"
        self.presentPanModal(vc)
    }
    lazy var questionmarkBtn2: UIButton = {
        var questionmarkBtn = UIButton()
        questionmarkBtn.setImage(UIImage(systemName: "questionmark.circle"), for: UIControl.State.normal)
        questionmarkBtn.addTarget(self, action: #selector(questionmarkBtnAction2), for: UIControl.Event.touchUpInside)
        return questionmarkBtn
    }()
    @objc func questionmarkBtnAction2() {
        let vc: PanModalPresentable.LayoutType = ZHChatModelIntroduceViewController()
        let introduceVC : ZHChatModelIntroduceViewController = vc as! ZHChatModelIntroduceViewController
        introduceVC.titleL.text = "你可以指定ChatGPT的角色，例如：你可以让ChatGPT扮演一个翻译的角色，将你说的中文翻译成英文。"
        self.presentPanModal(vc)
    }
    @objc func voiceSwitchAction(sender:UISwitch) {
//        self.voiceOn = sender.isOn
    }
    @objc func vibrateSwitchAction(sender:UISwitch) {
//        self.vibrateOn = sender.isOn
    }
}
extension ZHChatSettingViewController: PanModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var panScrollable: UIScrollView? {
        return nil
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.size.width/5)
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    func panModalWillDismiss(){
//        settingCompletion!(voiceSwitch.isOn,vibrateSwitch.isOn)
//        colorBtnClick!(type!,currentColor!)
        chatSettingCompletion!(voiceSwitch.isOn,"",(modelBtn.titleLabel?.text!)!,systeTF.text!)
    }
}

