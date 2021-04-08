//
//  RecordSoundsViewController.swift
//  pp02
//
//  Created by Youssef KASSABI on 2021-03-31.
//

import UIKit
import AVFoundation


// MARK: - Audio Recorder Delegate
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var  audioRecorder: AVAudioRecorder!
   
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    
    @IBAction func recordAudio(_ sender: Any) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recorderVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string:pathArray.joined(separator:"/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url:filePath!, settings: [:])
        
        recordingUI(textLabel: "Recording in progress", isRecording: false)
        audioRecorder.delegate = self //delegate
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        audioRecorder.stop()
        recordingUI(textLabel: "tap to record", isRecording: true)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func recordingUI(textLabel:String, isRecording:Bool){
        recordingLabel.text = textLabel
        recordButton.isEnabled = isRecording
        stopRecordingButton.isEnabled = !isRecording
    }
}
