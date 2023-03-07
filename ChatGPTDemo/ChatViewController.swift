//
// MIT License
//
// Copyright (c) 2017-2020 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Softw                                                                                                                                                                                                                                                                                                                                                                                                        are without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// TH·E SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import InputBarAccessoryView
import MessageKit
import UIKit
import SafariServices


// MARK: - ChatViewController

/// A base class for the example controllers

class ChatViewController: MessagesViewController {
  
    
    
    var currentSender: SenderType {
        MockUser(senderId: "1", displayName:"刘大6")
    }
    var imgPathArr = [String]()
    var imgArr = [UIImage]()
    
    var avatar : String = "avatar"
    var userName : String = "刘大6"
    var userId : String = "1"
    
    var chatGPTAvatar : String = "chatGPTAvatar"
    var chatGTPName : String = "ChatGPT"
    var ChatGPTId : String = "2"
  
  lazy var messageList: [MockMessage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMessageCollectionView()
        self.configureMessageInputBar()
        self.messagesCollectionView.backgroundColor = .white
  }
 
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
    
    // MARK: 输入工具栏
    
  func configureMessageCollectionView() {
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messageCellDelegate = self
    scrollsToLastItemOnKeyboardBeginsEditing = true // default false
    maintainPositionOnInputBarHeightChanged = true // default false
    showMessageTimestampOnSwipeLeft = true // default false
  }

    func configureMessageInputBar() {
        if #available(iOS 16.0, *) {
            messageInputBar.delegate = self
        } else {
            // Fallback on earlier versions
        }
    messageInputBar.inputTextView.tintColor = .black
    messageInputBar.inputTextView.textColor = .black
    messageInputBar.inputTextView.delegate = self
    messageInputBar.separatorLine.backgroundColor = .white
    messageInputBar.sendButton.setTitleColor(.black, for: .normal)
    messageInputBar.sendButton.setTitle("发送", for: UIControl.State.normal)
    messageInputBar.setLeftStackViewWidthConstant(to: 10, animated: true)
    messageInputBar.inputTextView.placeholderLabel.text = "请输入..."
    messageInputBar.contentView.backgroundColor = .white
    messageInputBar.backgroundView.backgroundColor = .white
    messageInputBar.backgroundColor = .white
      //定义view的角度
      messageInputBar.layer.cornerRadius = 1
      //定义view的阴影颜色
        messageInputBar.layer.shadowColor = UIColor.black.cgColor
      //阴影偏移量
      messageInputBar.layer.shadowOffset = CGSize(width:0, height:1)
      //定义view的阴影宽度，模糊计算的半径
      messageInputBar.layer.shadowRadius = 6
      //定义view的阴影透明度，注意:如果view没有设置背景色阴影也是不会显示的
      messageInputBar.layer.shadowOpacity = 0.2
      
    messageInputBar.sendButton.setTitleColor(
      UIColor.black.withAlphaComponent(0.3),
      for: .highlighted)
  }
    func sendMessage(str:String){

    }
    func insertMessages(_ data: [Any]) {
      for component in data {
        let user = MockUser(senderId: userId, displayName: userName)
        if let str = component as? String {
          let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
          insertMessage(message)
          sendMessage(str: str)
        } else if let img = component as? UIImage {
          let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
          insertMessage(message)
        }else{
            let message = MockMessage(custom: component, user: user, messageId: UUID().uuidString, date: Date())
            insertMessage(message)
        }
      }
    }
    
  // MARK: - Helpers

  func insertMessage(_ message: MockMessage) {
      
      DispatchQueue.main.async { [self] in
          messageList.append(message)
          // Reload last section to update header/footer labels and insert a new one
          messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
              messagesCollectionView.reloadSections([messageList.count - 2])
            }
          }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
              self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
          })
                        

      }
   
  }

  func isLastSectionVisible() -> Bool {
    guard !messageList.isEmpty else { return false }

    let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)

    return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
  }

  func numberOfSections(in _: MessagesCollectionView) -> Int {
    messageList.count
  }

  func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
    messageList[indexPath.section]
  }

  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    if indexPath.section % 3 == 0 {
      return NSAttributedString(
        string: MessageKitDateFormatter.shared.string(from: message.sentDate),
        attributes: [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
          NSAttributedString.Key.foregroundColor: UIColor.darkGray,
        ])
    }
    return nil
  }

  func cellBottomLabelAttributedText(for _: MessageType, at _: IndexPath) -> NSAttributedString? {
    NSAttributedString(
      string: "",//Read
      attributes: [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
        NSAttributedString.Key.foregroundColor: UIColor.darkGray,
      ])
    
  }

  func messageTopLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
      let name = message.sender.displayName
    return NSAttributedString(
        string: name,
      attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
  }

  func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
    return NSAttributedString(
      string: "",//dateString
      attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
  }

  func textCell(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UICollectionViewCell? {
    nil
  }
  private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
  }()
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource{
    
}
// MARK: MessageCellDelegate
extension ChatViewController: MessageCellDelegate {
  func didTapAvatar(in _: MessageCollectionViewCell) {
    print("Avatar tapped")
  }

  func didTapMessage(in _: MessageCollectionViewCell) {
    print("Message tapped")
  }

  func didTapImage(in cell: MessageCollectionViewCell) {
    print("Image tapped")
  }

  func didTapCellTopLabel(in _: MessageCollectionViewCell) {
    print("Top cell label tapped")
  }

  func didTapCellBottomLabel(in _: MessageCollectionViewCell) {
    print("Bottom cell label tapped")
  }

  func didTapMessageTopLabel(in _: MessageCollectionViewCell) {
    print("Top message label tapped")
  }

  func didTapMessageBottomLabel(in _: MessageCollectionViewCell) {
    print("Bottom label tapped")
  }

  func didTapPlayButton(in cell: AudioMessageCell) {

  }

  func didStartAudio(in _: AudioMessageCell) {
    print("Did start playing audio sound")
  }

  func didPauseAudio(in _: AudioMessageCell) {
    print("Did pause audio sound")
  }

  func didStopAudio(in _: AudioMessageCell) {
    print("Did stop audio sound")
  }

  func didTapAccessoryView(in _: MessageCollectionViewCell) {
    print("Accessory view tapped")
  }
}

// MARK: MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
  func didSelectAddress(_ addressComponents: [String: String]) {
    print("Address Selected: \(addressComponents)")
  }

  func didSelectDate(_ date: Date) {
    print("Date Selected: \(date)")
  }

  func didSelectPhoneNumber(_ phoneNumber: String) {
    print("Phone Number Selected: \(phoneNumber)")
  }

  func didSelectURL(_ url: URL) {
    print("URL Selected: \(url)")
      let safari = SFSafariViewController(url: url)
      self.present(safari, animated: true, completion: nil)
  }

  func didSelectTransitInformation(_ transitInformation: [String: String]) {
    print("TransitInformation Selected: \(transitInformation)")
  }

  func didSelectHashtag(_ hashtag: String) {
    print("Hashtag selected: \(hashtag)")
  }

  func didSelectMention(_ mention: String) {
    print("Mention selected: \(mention)")
  }

  func didSelectCustom(_ pattern: String, match _: String?) {
    print("Custom data detector patter selected: \(pattern)")
  }
}

// MARK: InputBarAccessoryViewDelegate

@available(iOS 16.0, *)
extension ChatViewController: InputBarAccessoryViewDelegate {
  // MARK: Internal

  @objc
  func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
    processInputBar(messageInputBar)
  }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String){
        
    }

  func processInputBar(_ inputBar: InputBarAccessoryView) {
    // Here we can parse for which substrings were autocompleted
    let attributedText = inputBar.inputTextView.attributedText!
    let range = NSRange(location: 0, length: attributedText.length)
    attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in

      let substring = attributedText.attributedSubstring(from: range)
      let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
      print("Autocompleted: `", substring, "` with context: ", context ?? [])
    }

    let components = inputBar.inputTextView.components
    inputBar.inputTextView.text = String()
    inputBar.invalidatePlugins()
    inputBar.sendButton.startAnimating()
//    inputBar.inputTextView.placeholder = "Sending..."
    // Resign first responder for iPad split view
    inputBar.inputTextView.resignFirstResponder()
    DispatchQueue.global(qos: .default).async {
      // fake send request task
//      sleep(1)
      DispatchQueue.main.async { [weak self] in
        inputBar.sendButton.stopAnimating()
          inputBar.inputTextView.placeholderLabel.text = "请输入..."
        self?.insertMessages(components)
        self?.messagesCollectionView.scrollToLastItem(animated: true)
      }
    }
  }
}
extension ChatViewController: UITextViewDelegate{
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
    
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{

        return true
    }
}
