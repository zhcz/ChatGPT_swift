// MIT License
//
// Copyright (c) 2017-2019 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import MessageKit
import UIKit

import OpenAIKit
import AVFAudio
//import YYImage
// MARK: - BasicExampleViewController

class BasicExampleViewController: ChatViewController {
    
    var answer : String = ""
    var openAIKey : String = ""
    var system : String = ""//ChatGPT角色
    var organizationId : String = ""
    
    var sub: String!
    var region: String!
    var voiceOn : Bool = false
    var imgSizeType : String = "小"
    var modelStr : String = "gpt-3.5-turbo"//"text-davinci-003"
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    fileprivate let avSpeech = AVSpeechSynthesizer()
    
  override func configureMessageCollectionView() {
    super.configureMessageCollectionView()
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }
    
  func textCellSizeCalculator(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CellSizeCalculator? {
    nil
  }
    override func viewDidLoad() {
      super.viewDidLoad()
        title = chatGTPName
            let user = MockUser(senderId: ChatGPTId, displayName: chatGTPName)
            let message = MockMessage(text: "我能做什么？\n\n起草电子邮件或其他文字\n编写 Python 代码\n回答有关一组文件的问题\n创建会话代理\n为您的软件提供自然语言界面\n一系列学科的导师\n翻译语言\n模拟视频游戏中的角色等等", user: user, messageId: UUID().uuidString, date: Date())
            self.insertMessage(message)
        
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .small)
            let settingBtn = UIButton()
            settingBtn.setImage(UIImage.init(systemName: "gearshape",withConfiguration: largeConfig), for: UIControl.State.normal)
            settingBtn.tintColor = .black
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: settingBtn)
            settingBtn.addTarget(self, action: #selector(settingBtnAction), for: UIControl.Event.touchUpInside)
            setupSpinner()
    }
    @objc func settingBtnAction(){
        
        let settingVC: PanModalPresentable.LayoutType = ZHChatSettingViewController()
        let setVC = settingVC as! ZHChatSettingViewController
        self.presentPanModal(settingVC)
        setVC.voiceSwitch.isOn = voiceOn
        setVC.modelBtn.setTitle(modelStr, for: UIControl.State.normal)
        setVC.systeTF.text = self.system
        setVC.chatSettingCompletion = { [self] on,imgSize,modelStr,system in
            voiceOn = on
            imgSizeType = imgSize
            self.system = system
            self.modelStr = modelStr
        }
    }
    private func setupSpinner() {
        let titleV = UIView()
        titleV.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        titleV.backgroundColor = .clear
        titleV.addSubview(spinner)
        spinner.color = .white
        spinner.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        navigationItem.titleView = titleV
    }
   override func sendMessage(str:String){
         super.sendMessage(str: str)
            Task {
                await requestChatGPTData(text: str)
            }
    }
    func requestChatGPTData(text:String) async {
        let config = Configuration(organizationId: organizationId, apiKey: openAIKey)
        let openAI = OpenAI(config)
        spinner.startAnimating()
        let chat: [ChatMessage] = [
            ChatMessage(role: .system, content: system),
            ChatMessage(role: .user, content: text),
            ChatMessage(role: .assistant, content: answer)
        ]
        do {
            let chatParameters = ChatParameters(model: "gpt-3.5-turbo", messages: chat)
            let chatCompletion = try await openAI.generateChatCompletion(
                parameters: chatParameters
            )
            answer = chatCompletion.choices[0].message.content
                                self.userName = chatGTPName
                                let user = MockUser(senderId: ChatGPTId, displayName: chatGTPName)
                                let message = MockMessage(text: answer, user: user, messageId: UUID().uuidString, date: Date())
                                self.insertMessage(message)
                            if voiceOn {
                                startTranslattion(str: answer)
                            }
            
                        DispatchQueue.main.async { [self] in
                            spinner.stopAnimating()
                        }
        } catch {
            // Insert your own error handling method here.
        }
    }
}

// MARK: MessagesDisplayDelegate

extension BasicExampleViewController: MessagesDisplayDelegate {
  // MARK: - Text Messages
    
  func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
    isFromCurrentSender(message: message) ? .white : .darkText
  }

  func detectorAttributes(for detector: DetectorType, and _: MessageType, at _: IndexPath) -> [NSAttributedString.Key: Any] {
    switch detector {
    case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
    default: return MessageLabel.defaultAttributes
    }
  }
    
  func enabledDetectors(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> [DetectorType] {
    [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
  }

  // MARK: - All Messages
  func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
    isFromCurrentSender(message: message) ? UIColor(red: 69 / 255, green: 193 / 255, blue: 89 / 255, alpha: 1) : UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
  }

  func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
    let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(tail, .curved)
  }

  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at index: IndexPath, in _: MessagesCollectionView) {

      let userId : String = userId
//
      
      if message.sender.senderId != userId {
          avatarView.image = UIImage.init(named: chatGPTAvatar)
      }else{
          avatarView.image = UIImage.init(named: avatar)
      }
  }
  func configureMediaMessageImageView(
    _ imageView: UIImageView,
    for message: MessageType,
    at _: IndexPath,
    in _: MessagesCollectionView)
  {
  }
    
  // MARK: - Audio Messages

  func audioTintColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
      return UIColor.white
  }

  func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
   
  }
}

// MARK: MessagesLayoutDelegate

extension BasicExampleViewController: MessagesLayoutDelegate {
  func cellTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
    18
  }

  func cellBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
    17
  }

  func messageTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
    20
  }

  func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
    16
  }
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator{
        return CustomMessageSizeCalculator(layout: CustomMessagesFlowLayout())
    }
}

open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return typingIndicatorSizeCalculator
        }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
//MARK: 开始/停止转换
extension BasicExampleViewController{
    //开始转换
    fileprivate func startTranslattion(str : String){
        //1. 创建需要合成的声音类型
        let voice = AVSpeechSynthesisVoice(language: "zh-CN")
        //2. 创建合成的语音类
        let utterance = AVSpeechUtterance(string: str)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = voice
        utterance.volume = 10
        utterance.postUtteranceDelay = 0.1
        utterance.pitchMultiplier = 1
        //开始播放
        avSpeech.speak(utterance)
    }
    //暂停播放
    fileprivate func pauseTranslation(){
        avSpeech.pauseSpeaking(at: .immediate)
    }
    //继续播放
    fileprivate func continueSpeek(){
        avSpeech.continueSpeaking()
    }
    //取消播放
    fileprivate func cancleSpeek(){
        avSpeech.stopSpeaking(at: .immediate)
    }
}
