//
//  EditChannelViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/15/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import Closures
import PopBounceButton
import JGProgressHUD
import ImagePicker


class EditChannelViewController : UIViewController, ImagePickerDelegate {
    
    var back:BackButton!
    var profilePicture:PopBounceButton!
    var textfield:TextField!
    var instructions:UILabel = UILabel.body()
    var privateKey:PopBounceButton!
    var convo:ConvoItem!
    
    init() {
        self.convo = ConvoItem(id: UUID(), username: "Stephan", image: UIImage(), lastMessageDate: Date(), lastMessageText: "HellO!")
        super.init(nibName: nil, bundle: nil)
    }
    
    init(convo:ConvoItem) {
        self.convo = convo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
        self.hero.isEnabled = true
        self.view.addTapGesture { tap in
            self.view.endEditing(true)
        }
        setupUI()
        snap()
        
        Backend.shared.getConvoName(id: convo.id.uuidString) { name in
            DispatchQueue.main.async {
                self.textfield.textfield.text = name
            }
        }
        
        self.profilePicture.alpha = 0
        Backend.shared.getImage(id: convo.id.uuidString) { image in
            self.profilePicture.setImage(image, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 0.5) {
                self.profilePicture.alpha = 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Backend.shared.setConvoName(id: self.convo.id.uuidString, name: self.textfield.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? .random())
    }
    
    func setupUI() {
        back = BackButton(tap: {
            self.hero.modalAnimationType = .zoom
            self.hero.dismissViewController()
        })
        view.addSubview(back)
        
        profilePicture = PopBounceButton()
        profilePicture.addAction(UIAction(handler: { tap in
            Impact.button()
            self.showImagePicker()
        }), for: .touchUpInside)
        profilePicture.imageView?.contentMode = .scaleAspectFill
        profilePicture.setImage(UIImage(named: "Placeholder") ?? UIImage(), for: .normal)
        profilePicture.backgroundColor = .lightShadow
        profilePicture.layer.cornerRadius = 70 / 2
        profilePicture.layer.masksToBounds = true
        view.addSubview(profilePicture)
        
        textfield = TextField(imageName: "LockIcon", placeholder: "Channel Name")
        textfield.key()
        textfield.textfield.font = .mini
        view.addSubview(textfield)
        
        instructions.text = "Edit your channel’s name and photo."
        instructions.alpha = 0.4
        view.addSubview(instructions)
        
        privateKey = PopBounceButton()
        privateKey.setTitle(self.convo.id.uuidString, for: .normal)
        privateKey.titleLabel?.font = .mini
        privateKey.titleLabel?.alpha = 0.5
        privateKey.addAction(UIAction(handler: { tap in
            self.showCopied()
            Impact.hint()
        }), for: .touchUpInside)
        view.addSubview(privateKey)
    }
    
    func snap() {
        back.snp.makeConstraints { make in
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.width.equalTo(40)
        }
  
        profilePicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
            make.top.equalTo(self.back.snp.bottom)
        }
        
        textfield.snp.makeConstraints { make in
            make.top.equalTo(self.profilePicture.snp.bottom).offset(20)
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        instructions.snp.makeConstraints { make in
            make.top.equalTo(self.textfield.snp.bottom).offset(40)
            make.width.equalTo(250)
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        
        privateKey.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.lessThanOrEqualToSuperview()
        }
    }
    
    func showCopied() {
        UIPasteboard.general.string = self.privateKey.titleLabel?.text ?? ""
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Copied!"
        hud.textLabel.font = .body
        hud.isUserInteractionEnabled = true
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)
        self.view.isUserInteractionEnabled = true
        hud.dismiss(afterDelay: 0.5, animated: true)
    }
    
    func showImagePicker() {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        imagePickerController.preferredImageSize = CGSize(width: 225, height: 225)
        imagePickerController.hero.isEnabled = true
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.heroModalAnimationType = .zoom
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.heroModalAnimationType = .zoomOut
        imagePicker.dismiss(animated: true, completion: nil)
        trySetImage(image: images.first)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.heroModalAnimationType = .zoomOut
        imagePicker.dismiss(animated: true, completion: nil)
        trySetImage(image: images.first)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.heroModalAnimationType = .zoomOut
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func trySetImage(image:UIImage?) {
        guard image != nil else {return}
        self.profilePicture.setImage(image, for: .normal)
        Backend.shared.uploadImage(id: convo.id.uuidString, image: image!)
    }
}

@available(iOS 13.0, *)
struct EditChannelContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(EditChannelViewController())
        }
    }
}
