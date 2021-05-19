//
//  ViewController.swift
//  MicAnimation
//
//  Created by Lama Albadri on 19/05/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , AVAudioRecorderDelegate , AVAudioPlayerDelegate{

    var soundPlayer: AVAudioPlayer!
    var soundReorder : AVAudioRecorder!
    var fileName : String = "audioFile.m4a"
    
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.layer.cornerRadius = 20 
        }
    }
    @IBOutlet weak var recordButton: UIButton!{
        didSet{
            recordButton.setImage(UIImage(named: "Record")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            recordButton.setTitle("Record", for: .normal)
            recordButton.titleLabel?.isHidden = true
        }
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRecorder()
        playButton.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))
            tapGesture.numberOfTapsRequired = 1
         recordButton.addGestureRecognizer(tapGesture)
       
    }

    func getDoumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setUpRecorder(){
        let audioFileName = getDoumentsDirectory().appendingPathComponent(fileName)
        let recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless,
                             AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                             AVEncoderBitRateKey : 320000,
                             AVNumberOfChannelsKey : 2 ,
        AVSampleRateKey : 44100.2] as [String : Any]
        
        do{
            soundReorder = try AVAudioRecorder(url: audioFileName, settings: recordSetting)
            soundReorder.delegate = self
            soundReorder.prepareToRecord()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func setUpPlayer(){
        let audioFileName = getDoumentsDirectory().appendingPathComponent(fileName)
        do{
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }catch{
            print(error.localizedDescription)
        }
    }
 
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }
    
    @objc func tap(){
        let pulse = PulseAnimation(numberOfPluses: 5, radius: 200, position: recordButton.center)
        // if record button is tapped
        if recordButton.titleLabel?.text == "Record"{
          
            pulse.animationDuration = 2.0
            pulse.radius = 200
            pulse.numberOfPluses = 10
            pulse.backgroundColor = UIColor.blue.cgColor
            soundReorder .record()
            recordButton.setImage(nil , for: .normal)
            recordButton.titleLabel?.isHidden = false
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
            view.layer.insertSublayer(pulse, below: self.view.layer)
        }else {
            pulse.numberOfPluses = 0
            self.recordButton.layer.removeAllAnimations()
            self.view.layer.removeAllAnimations()
             self.view.layoutIfNeeded()
            soundReorder.stop()
            recordButton.titleLabel?.isHidden = true
            recordButton.setTitle("Record", for: .normal)
            recordButton.setImage(UIImage(named: "Record")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            playButton.isEnabled = false
            
        }
       
    }
    
  
    @IBAction func playButton(_ sender: UIButton) {
        if playButton.titleLabel?.text == "Play" {
            view.layer.removeAnimation(forKey: "pulse")
            playButton.setTitle("Stop", for: .normal)
            recordButton.isEnabled = false
            setUpPlayer()
            soundPlayer.play()
        }else{
            view.layer.removeAnimation(forKey: "pulse")
            soundPlayer?.stop()
            playButton.setTitle("Play", for: .normal)
            recordButton.setImage(UIImage(named: "Record")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            recordButton.isEnabled = true
        }
    }
    
}



