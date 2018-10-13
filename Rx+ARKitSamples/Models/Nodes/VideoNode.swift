//
//  VideoNode.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 13/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

class VideoNode: SCNNode {
    init(name: String, url: URL, planeGeometry: SCNPlane) {
        self.url = url
        super.init()
        self.name = name
        setup(planeGeometry: planeGeometry)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(planeGeometry: SCNPlane) {
        geometry = planeGeometry
        
        let skScene = SKScene(size: CGSize(width: 640, height: 480))
        skScene.addChild(videoNode)
        
        videoNode.position = CGPoint(x: skScene.size.width / 2, y: skScene.size.height / 2)
        videoNode.size = skScene.size
        
        planeGeometry.firstMaterial?.diffuse.contents = skScene
        planeGeometry.firstMaterial?.isDoubleSided = true
        
        eulerAngles = SCNVector3(Double.pi,0,0)
        
        play()
    }
    
    // MARK VideoPlayer
    public private(set) lazy var avPlayer = AVPlayer(url: self.url)
    
    public func play() {
        avPlayer.play()
    }
    
    public func pause() {
        avPlayer.pause()
    }
    
    // MARK VideoNode
    public private(set) lazy var videoNode = SKVideoNode(avPlayer: self.avPlayer)
    
    // MARK URL
    let url: URL
    
    // MARK PlaneGeometry
    public var planeGeometry: SCNPlane? {
        return geometry as? SCNPlane
    }
}
