//
//  CameraViewController.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import UIKit
import AVFoundation


enum CameraError: String {
    case invalidDeviceInput     = "Something is wrong with the camera. We are unable to capture the input"
    case invalidScannedValue    = "Value scanned is not valid. THis app scans for melee characters."
}

protocol CameraVCDelegate: AnyObject {
    func didFind(character: Character)
    func didSurface(error: CameraError)
}

final class CameraViewController: UIViewController {
    
    weak var cameraVCDelegate: CameraVCDelegate?
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(cameraVCDelegate: CameraVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.cameraVCDelegate = cameraVCDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            cameraVCDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private  func recognizeCharacter() -> Character? {
        // Simulate character recognition with a random character
        return CharacterData.allCharacters.randomElement()
    }
    
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            cameraVCDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            cameraVCDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            cameraVCDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
                                                
        } else {
            cameraVCDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
}


extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            cameraVCDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            cameraVCDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard machineReadableObject.stringValue != nil else {
            cameraVCDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        
        
        captureSession.stopRunning()
        cameraVCDelegate?.didFind(character: recognizeCharacter()!)
    
}

}
