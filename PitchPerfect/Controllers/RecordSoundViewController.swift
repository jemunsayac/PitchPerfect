//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by JM Munsayac on 8/27/15.
//  Copyright © 2015 JM Munsayac. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!  //variable for audio recording
    var recordedAudio:RecordedAudio!    //recorded Audio model class
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopAudioBtn: UIButton!
    @IBOutlet weak var recordAudioBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stopAudioBtn.hidden = true
        recordAudioBtn.enabled = true
        recordingInProgress.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        //code snippet will make sure the data from this controller can be accessed to the other controller
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data //pass the data to the PlaySoundsViewController
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "recordedAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        let session = AVAudioSession.sharedInstance() //this will create a singleton instance of the AVAudioSession object.
        
        //setup the audio session
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath!, settings: ["" : ""], error: nil)
        audioRecorder.delegate = self // delegate the tasks to this viewController (RecordSoundViewController)
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        stopAudioBtn.hidden = false
        recordAudioBtn.enabled = false
        recordingInProgress.text = "Recording.."
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()

        audioSession.setActive(false, error: nil)
        recordingInProgress.text = "Tap to Record"
    }
    
    /*
    * Function Name: audioRecorderDidFinishRecording
    * Description: delegate to check if the recording has finished.
    *
    * Parameters:
    *      recorder : AVAudioRecorder object to be used
    *      successfully flag : bool to check if the recording has succsesfully completed
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            print("Ooops! someting went wrong...")
            stopAudioBtn.hidden = true
        }
    }
}

