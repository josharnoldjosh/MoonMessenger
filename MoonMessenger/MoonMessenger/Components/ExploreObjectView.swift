//
//  ExploreObjectView.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/10/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import SceneKit
import SpriteKit


class ExploreObjectView : UIView {
        
    var sceneView: SCNView = SCNView()
    
    init(name:String="moon.dae", zoom:Float = 5, backgroundColor:UIColor = .background) {
        super.init(frame: .zero)
                
        
        let scene = SCNScene(named: name)
                                
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: zoom)
        scene?.rootNode.addChildNode(cameraNode)
                
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(lightNode)
                
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
                                
        scene?.rootNode.runAction(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 0.0))
        

        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .background
        sceneView.cameraControlConfiguration.allowsTranslation = false
        sceneView.scene = scene
        addSubview(sceneView)
        sceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@available(iOS 13.0, *)
struct ExploreObjectViewContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make {
                let view = ExploreObjectView()
                let vc = UIViewController()
                vc.view.addSubview(view)
                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                return vc
            }
        }
    }
}

