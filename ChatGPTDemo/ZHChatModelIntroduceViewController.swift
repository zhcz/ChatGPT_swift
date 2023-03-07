//
//  ZHChatModelIntroduceViewController.swift
//  swiftDemo2
//
//  Created by zhanghao on 2023/3/7.
//  Copyright © 2023 张浩. All rights reserved.
//

import UIKit
import SnapKit
class ZHChatModelIntroduceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }
    
    lazy var titleL: UILabel = {
        var titleL = UILabel()
        titleL.textColor = .black
        titleL.font = UIFont.systemFont(ofSize: 15)
        titleL.numberOfLines = 0
//        titleL.text = "gpt-3.5-turbo: 最强大的GPT-3.5模型，并以text-davinci-003的1/10的成本优化聊天。将使用我们最新的模型迭代进行更新。"
        return titleL
    }()

}
extension ZHChatModelIntroduceViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.size.width/3)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    func panModalWillDismiss(){
        
        
    }
}
