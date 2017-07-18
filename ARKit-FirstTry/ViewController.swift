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
  
  fileprivate func updateTrackingState(with state: ARCamera.TrackingState) {
    var stateStr = ""
    switch state {
    case .notAvailable:
      stateStr = "Tracking unavailable"
    case .limited(let reason):
      stateStr = "Tracking limited:\n -> \(reason)"
    case .normal:
      stateStr = "Tracking normal"
    }
    debug(stateStr)
  }
  
  fileprivate func reset() {
    
  }
  
  fileprivate func blurBackground() {
    let blur = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(frame: view.bounds)
    blurView.effect = blur
    view.addSubview(blurView)
  }
  
  fileprivate func removeBlur() {
    if let blurView = view.subviews.last as? UIVisualEffectView {
      blurView.removeFromSuperview()
    }
  }
  
  fileprivate func displayAlert(withTitle title: String? = nil,
                                message: String? = nil,
                                style: UIAlertControllerStyle = .alert,
                                confirmButtonLabel: String? = nil,
                                confirmButtonAction: ((UIAlertAction) -> Void)? = nil,
                                confirmButtonStyle: UIAlertActionStyle = .default,
                                cancelButtonLabel: String? = nil,
                                cancelButtonAction: ((UIAlertAction) -> Void)? = nil,
                                cancelButtonStyle: UIAlertActionStyle = .cancel) {
    blurBackground()
    
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: style)
    if let cancelLabel = cancelButtonLabel {
      let cancelAction: (UIAlertAction) -> Void = { [weak self] (action) in
        self?.removeBlur()
        cancelButtonAction?(action)
      }
      let cancel = UIAlertAction(title: cancelLabel,
                                 style: cancelButtonStyle,
                                 handler: cancelAction)
      alert.addAction(cancel)
    }
    if let confirmLabel = confirmButtonLabel {
      let confirmAction: (UIAlertAction) -> Void = { [weak self] (action) in
        self?.removeBlur()
        confirmButtonAction?(action)
      }
      let confirm = UIAlertAction(title: confirmLabel,
                                  style: confirmButtonStyle,
                                  handler: confirmAction)
      alert.addAction(confirm)
    }
    present(alert,
            animated: true,
            completion: nil)
  }
  
  fileprivate func closeErrorIfNeeded() {
    if let alert = presentedViewController as? UIAlertController {
      removeBlur()
      alert.dismiss(animated: true,
                    completion: nil)
    }
  }
  
  // *********************************************************************
  // MARK: - ARSessionDelegate
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    updateTrackingState(with: frame.camera.trackingState)
  }
  
  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    
  }
  
  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    
  }
  
  func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    
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
    displayAlert(withTitle: "An error occured",
                 message: error.localizedDescription,
                 style: .alert,
                 confirmButtonLabel: "Close",
                 confirmButtonAction: nil,
                 confirmButtonStyle: .default,
                 cancelButtonLabel: nil,
                 cancelButtonAction: nil,
                 cancelButtonStyle: .cancel)
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    displayAlert(message: "Session was interrupted. It will restart when interruption ends.")
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    closeErrorIfNeeded()
    reset()
  }
}
