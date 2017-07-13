//
//  ViewController.swift
//  ARKit-FirstTry
//
//  Created by Octo-RCO on 13/07/2017.
//  Copyright © 2017 Octo-RCO. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController,
ARSCNViewDelegate,
ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var debugLabel: UILabel!
  @IBOutlet weak var blurredDebugView: UIVisualEffectView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
      configuration.planeDetection = .horizontal
      
        // Run the view's session
      sceneView.session.delegate = self
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
  
  // *********************************************************************
  // MARK: - Private func
  fileprivate func debug(_ message: String) {
    debugLabel.text = message
  }
  
  // *********************************************************************
  // MARK: - ARSessionDelegate
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    debug("\(frame.camera.trackingState)")
//    debug("session didUpdate frame \(frame)")
  }
  
  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//   debug("session didAdd anchors \(anchors)")
  }
  
  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//    debug("session didUpdate anchors \(anchors)")
  }
  
  func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
//    debug("session didRemove anchors \(anchors)")
  }
  
  // *********************************************************************
  // MARK: - ARSCNViewDelegate
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
