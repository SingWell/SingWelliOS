//
//  LoginViewController.swift
//  SingWell
//
//  Created by Travis Siems on 1/30/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import DTTextField
//import CoreAudio
import AVFoundation
import CoreMIDI
import AudioToolbox

import AudioKit
import AudioKitUI

class LoginViewController: AnimatableViewController {

    
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        guard validateData() else { return }
        
        // TODO: LOGIN USER
        // TODO: CHECK IF LOGIN WORKED
        
        ApiHelper.login(emailField.text!, passwordField.text!) { response, error in
            
            print("RESPONSE LOGIN: ", response?.dictionary)
            print("Error login: ", error)
            if error == nil {
//                print
                // LOGIN SUCCESSFUL
                let alert = UIAlertController(title: "Login Successful", message: response?.stringValue, preferredStyle: .alert)
                alert.addAction( UIAlertAction(title: "OK", style: .cancel) )
                
                self.present(alert, animated: true, completion: nil)
            } else {
                // LOGIN FAILED
                let alert = UIAlertController(title: "Login Failed", message: "Your email and password were not recognized.", preferredStyle: .alert)
                alert.addAction( UIAlertAction(title: "OK", style: .cancel) )
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let nextVc = AppStoryboard.Register.initialViewController() as! RegisterViewController
        self.present(nextVc, animated: true)
//        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    
    
    let emailMessage            = "Email is required."
    let passwordMessage         = "Password is required."
    
    func validateData() -> Bool {
        
        guard !emailField.text!.isEmptyStr else {
            emailField.showError(message: emailMessage)
            return false
        }
        
        guard !passwordField.text!.isEmptyStr else {
            passwordField.showError(message: passwordMessage)
            return false
        }
        

        
        return true
    }
    
    // MARK: Tap to hide
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
////
////  MIDISequence.swift
////  MusicSequence
////
////  Created by Gene De Lisa on 8/17/14.
////  Copyright (c) 2014 Gene De Lisa. All rights reserved.
////
//import Foundation
//import AudioToolbox
//
///**
// Trying to ease the pain of uaing Core Audio.
// */
//
//class MIDISequence : NSObject {
//
//    var musicSequence:MusicSequence?
//
//    override init() {
//        musicSequence = nil
//        var status = NewMusicSequence(&musicSequence)
//        if status != OSStatus(noErr) {
//            print("\(#line) bad status \(status) creating sequence")
//        }
//
//        var track:MusicTrack? = nil
//        status = MusicSequenceNewTrack(musicSequence!, &track)
//        if status != OSStatus(noErr) {
//            print("\(#line) bad status \(status) creating track")
//        }
//
//        super.init()
//    }
//
//    func loadMIDIFile(filename:String, ext:String) -> MusicSequence {
//        let fn:CFString = filename as NSString
//        let ex:CFString = ext as NSString
//        let midiFileURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fn, ex, nil)
//        var flags:MusicSequenceLoadFlags = MusicSequenceLoadFlags(kMusicSequenceLoadSMF_ChannelsToTracks)
//        var typeid = MusicSequenceFileTypeID(kMusicSequenceFile_MIDIType)
//        var status = MusicSequenceFileLoad(musicSequence,
//                                           midiFileURL,
//                                           typeid,
//                                           flags)
//        if status != OSStatus(noErr) {
//            print("\(#line) bad status \(status) loading file")
//            displayStatus(status)
//            return nil
//        }
//
//        // if you set up an AUGraph. Otherwise it will be played with a sine wave.
//        //        status = MusicSequenceSetAUGraph(musicSequence, self.processingGraph)
//
//        // debugging using C(ore) A(udio) show.
//        CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence!))
//        return musicSequence!
//    }
//
//    func getNumberOfTracks() -> Int {
//        var trackCount:UInt32 = 0
//        var status = MusicSequenceGetTrackCount(musicSequence!, &trackCount)
//        if status != OSStatus(noErr) {
//            displayStatus(status: status)
//            print("getting track count")
//        }
//        return Int(trackCount)
//    }
//
//    func getTrack(trackIndex:Int) -> MusicTrack {
//        var track:MusicTrack? = nil
//        var status = MusicSequenceGetIndTrack(musicSequence!, UInt32(trackIndex), &track)
//        if status != OSStatus(noErr) {
//            print("bad status \(status) getting track")
//            displayStatus(status: status)
//        }
//        return track!
//    }
//
//    func getTrackEvents(trackIndex:Int) -> [TimedMIDIEvent] {
//        var track = self.getTrack(trackIndex: trackIndex)
//        return getTrackEvents(track)
//
//    }
//
//    func getTrackEvents(track:MusicTrack) -> [TimedMIDIEvent] {
//        var    iterator:MusicEventIterator? = nil
//        var status = OSStatus(noErr)
//        status = NewMusicEventIterator(track, &iterator)
//        if status != OSStatus(noErr) {
//            print("bad status \(status) creating iterator")
//            displayStatus(status: status)
//        }
//
//        var hasCurrentEvent:DarwinBoolean = 0
//        status = MusicEventIteratorHasCurrentEvent(iterator!, &hasCurrentEvent)
//        if status != OSStatus(noErr) {
//            print("bad status \(status) checking current event")
//            displayStatus(status: status)
//        }
//
//        var eventType:MusicEventType = 0
//        var eventTimeStamp:MusicTimeStamp = -1
//        var eventData: UnsafePointer<()>? = nil
//        var eventDataSize:UInt32 = 0
//        var results:[TimedMIDIEvent] = []
//        while (hasCurrentEvent != 0) {
//            status = MusicEventIteratorGetEventInfo(iterator!, &eventTimeStamp, &eventType, &eventData, &eventDataSize)
//            if !(status == OSStatus(noErr)) {
//                print("bad status \(status) getting event info")
//            }
//
//            switch Int(eventType) {
//            case kMusicEventType_MIDINoteMessage:
//                let data = UnsafePointer<MIDINoteMessage>(eventData)
//                let note = data?.pointee
//
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: note)
//                results.append(te)
//
//                break
//
//            case kMusicEventType_ExtendedNote:
//                let data = UnsafePointer<ExtendedNoteOnEvent>(eventData)
//                let event = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: event)
//                results.append(te)
//                break
//
//            case kMusicEventType_ExtendedTempo:
//                let data = UnsafePointer<ExtendedTempoEvent>(eventData)
//                let event = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: event)
//                results.append(te)
//                break
//
//            case kMusicEventType_User:
//                let data = UnsafePointer<MusicEventUserData>(eventData)
//                let event = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: event)
//                results.append(te)
//                break
//
//            case kMusicEventType_Meta:
//                let data = UnsafePointer<MIDIMetaEvent>(eventData)
//                let event = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: event)
//                results.append(te)
//                break
//
//            case kMusicEventType_MIDIChannelMessage :
//                let data = UnsafePointer<MIDIChannelMessage>(eventData)
//                let cm = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: cm)
//                results.append(te)
//                break
//
//            case kMusicEventType_MIDIRawData :
//                let data = UnsafePointer<MIDIRawData>(eventData)
//                let raw = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: raw)
//                results.append(te)
//                break
//
//            case kMusicEventType_Parameter :
//                let data = UnsafePointer<ParameterEvent>(eventData)
//                let param = data?.pointee
//                var te = TimedMIDIEvent(eventType: eventType, eventTimeStamp: eventTimeStamp, event: param)
//                results.append(te)
//                break
//
//            default:
//                print("Something or other \(eventType)")
//            }
//
//            status = MusicEventIteratorHasNextEvent(iterator, &hasCurrentEvent)
//            if status != OSStatus(noErr) {
//                print("bad status \(status) checking for next event")
//                displayStatus(status: status)
//            }
//            status = MusicEventIteratorNextEvent(iterator)
//            if status != OSStatus(noErr) {
//                print("bad status \(status) going to next event")
//                displayStatus(status: status)
//            }
//        }
//        return results
//    }
//
//    func addNoteToTrack(trackIndex:Int, beat:Float, channel:Int, note:Int, velocity:Int, releaseVelocity:Int, duration:Float) {
//        var track = getTrack(trackIndex)
//        addNoteToTrack(track, beat: beat, channel: channel, note: note, velocity: velocity, releaseVelocity: releaseVelocity, duration: duration)
//    }
//
//    func addNoteToTrack(track:MusicTrack, beat:Float, channel:Int, note:Int, velocity:Int, releaseVelocity:Int, duration:Float) {
//
//        var mess = MIDINoteMessage(channel: UInt8(channel), note: UInt8(note), velocity: UInt8(velocity), releaseVelocity: UInt8(releaseVelocity), duration: Float32(duration))
//
//        var status = OSStatus(noErr)
//        status = MusicTrackNewMIDINoteEvent(track, MusicTimeStamp(beat), &mess)
//        if status != OSStatus(noErr) {
//            print("bad status \(status) creating note event")
//            displayStatus(status: status)
//        }
//
//    }
//
//    func addChannelMessageToTrack(trackIndex:Int, beat:Float, channel:Int, status:Int, data1:Int, data2:Int, reserved:Int) {
//        var track = getTrack(trackIndex: trackIndex)
//        addChannelMessageToTrack(track, beat: beat, channel: channel, status: status, data1: data1, data2: data2, reserved: reserved)
//    }
//
//    func addChannelMessageToTrack(track:MusicTrack, beat:Float, channel:Int, status:Int, data1:Int, data2:Int, reserved:Int) {
//        var mess = MIDIChannelMessage(status: UInt8(status), data1: UInt8(data1), data2: UInt8(data2), reserved: UInt8(reserved))
//        var status = OSStatus(noErr)
//        status = MusicTrackNewMIDIChannelEvent(track, MusicTimeStamp(beat), &mess)
//        if status != OSStatus(noErr) {
//            print("bad status \(status) creating channel event")
//            displayStatus(status: status)
//        }
//    }
//
//    func display()  {
//        var status = OSStatus(noErr)
//
//        var trackCount:UInt32 = 0
//        status = MusicSequenceGetTrackCount(self.musicSequence, &trackCount)
//
//        if status != OSStatus(noErr) {
//            displayStatus(status: status)
//
//            print("in display: getting track count")
//        }
//        print("There are \(trackCount) tracks")
//
//        var track:MusicTrack? = nil
//        for i in 0..<Int(trackCount) {
//            status = MusicSequenceGetIndTrack(self.musicSequence, UInt32(i), &track)
//
//            if status != OSStatus(noErr) {
//                displayStatus(status: status)
//
//            }
//            print("\n\nTrack \(i)")
//
//            // getting track properties is ugly
//
//            var trackLength:MusicTimeStamp = -1
//            var prop:UInt32 = UInt32(kSequenceTrackProperty_TrackLength)
//            // the size is filled in by the function
//            var size:UInt32 = 0
//            status = MusicTrackGetProperty(track!, prop, &trackLength, &size)
//            if status != OSStatus(noErr) {
//                print("bad status \(status)")
//            }
//            print("track length \(trackLength)")
//
//            var loopInfo:MusicTrackLoopInfo = MusicTrackLoopInfo(loopDuration: 0,numberOfLoops: 0)
//            prop = UInt32(kSequenceTrackProperty_LoopInfo)
//            status = MusicTrackGetProperty(track!, prop, &loopInfo, &size)
//            if status != OSStatus(noErr) {
//                print("bad status \(status)")
//            }
//            print("loop info \(loopInfo.loopDuration)")
//
//            iterate(track: track!)
//        }
//
//        CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence))
//
//    }
//    /**
//     Itereates over a MusicTrack and prints the MIDI events it contains.
//
//     :param: track:MusicTrack the track to iterate
//     */
//    func iterate(track:MusicTrack) {
//        var    iterator:MusicEventIterator? = nil
//        var status = OSStatus(noErr)
//        status = NewMusicEventIterator(track, &iterator)
//        if status != OSStatus(noErr) {
//            print("bad status \(status)")
//        }
//
//        var hasCurrentEvent:Boolean = 0
//        status = MusicEventIteratorHasCurrentEvent(iterator, &hasCurrentEvent)
//        if status != OSStatus(noErr) {
//            print("bad status \(status)")
//        }
//
//        var eventType:MusicEventType = 0
//        var eventTimeStamp:MusicTimeStamp = -1
//        var eventData: UnsafePointer<()>? = nil
//        var eventDataSize:UInt32 = 0
//
//        while (hasCurrentEvent != 0) {
//            status = MusicEventIteratorGetEventInfo(iterator, &eventTimeStamp, &eventType, &eventData, &eventDataSize)
//            if status != OSStatus(noErr) {
//                print("bad status \(status)")
//            }
//
//            switch Int(eventType) {
//            case kMusicEventType_MIDINoteMessage:
//                let data = UnsafePointer<MIDINoteMessage>(eventData)
//                let note = data?.memory
//                print("Note message \(note.note), vel \(note.velocity) dur \(note.duration) at time \(eventTimeStamp)")
//                break
//
//            case kMusicEventType_ExtendedNote:
//                let data = UnsafePointer<ExtendedNoteOnEvent>(eventData)
//                let event = data.memory
//                print("ext note message")
//                break
//
//            case kMusicEventType_ExtendedTempo:
//                let data = UnsafePointer<ExtendedTempoEvent>(eventData)
//                let event = data.memory
//                print("ext tempo message")
//                NSLog("ExtendedTempoEvent, bpm %f", event.bpm)
//
//                break
//
//            case kMusicEventType_User:
//                let data = UnsafePointer<MusicEventUserData>(eventData)
//                let event = data.memory
//                print("user message")
//                break
//
//            case kMusicEventType_Meta:
//                let data = UnsafePointer<MIDIMetaEvent>(eventData)
//                let event = data.memory
//                print("meta message \(event.metaEventType)")
//                break
//
//            case kMusicEventType_MIDIChannelMessage :
//                let data = UnsafePointer<MIDIChannelMessage>(eventData)
//                let cm = data.memory
//                NSLog("channel event status %X", cm.status)
//                NSLog("channel event d1 %X", cm.data1)
//                NSLog("channel event d2 %X", cm.data2)
//                if (cm.status == (0xC0 & 0xF0)) {
//                    print("preset is \(cm.data1)")
//                }
//                break
//
//            case kMusicEventType_MIDIRawData :
//                let data = UnsafePointer<MIDIRawData>(eventData)
//                let raw = data.memory
//                NSLog("MIDIRawData i.e. SysEx, length %lu", raw.length)
//                break
//
//            case kMusicEventType_Parameter :
//                let data = UnsafePointer<ParameterEvent>(eventData)
//                let param = data.memory
//                NSLog("ParameterEvent, parameterid %lu", param.parameterID)
//                break
//
//            default:
//                print("something or other \(eventType)")
//            }
//
//            status = MusicEventIteratorHasNextEvent(iterator, &hasCurrentEvent)
//            if status != OSStatus(noErr) {
//                print("bad status \(status)")
//            }
//
//            status = MusicEventIteratorNextEvent(iterator)
//            if status != OSStatus(noErr) {
//                print("bad status \(status)")
//            }
//        }
//    }
//
//    /**
//     Just for testing. Uses a sine wave.
//     */
//    func play() {
//        var status = OSStatus(noErr)
//
//        var musicPlayer:MusicPlayer = nil
//        status = NewMusicPlayer(&musicPlayer)
//        if status != OSStatus(noErr) {
//            print("bad status \(status) creating player")
//            displayStatus(status: status)
//            return
//        }
//
//        status = MusicPlayerSetSequence(musicPlayer, self.musicSequence)
//        if status != OSStatus(noErr) {
//            displayStatus(status: status)
//            print("setting sequence")
//            return
//        }
//
//        status = MusicPlayerPreroll(musicPlayer)
//        if status != OSStatus(noErr) {
//            displayStatus(status: status)
//            return
//        }
//
//        status = MusicPlayerStart(musicPlayer)
//        if status != OSStatus(noErr) {
//            displayStatus(status: status)
//            return
//        }
//    }
//
//
//    func displayStatus(status:OSStatus) {
//        print("Bad status: \(status)")
//        var nserror = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
//        print("\(nserror.localizedDescription)")
//
//        switch status {
//        // ugly
//        case OSStatus(kAudioToolboxErr_InvalidSequenceType):
//            print("Invalid sequence type")
//
//        case OSStatus(kAudioToolboxErr_TrackIndexError):
//            print("Track index error")
//
//        case OSStatus(kAudioToolboxErr_TrackNotFound):
//            print("Track not found")
//
//        case OSStatus(kAudioToolboxErr_EndOfTrack):
//            print("End of track")
//
//        case OSStatus(kAudioToolboxErr_StartOfTrack):
//            print("start of track")
//
//        case OSStatus(kAudioToolboxErr_IllegalTrackDestination):
//            print("Illegal destination")
//
//        case OSStatus(kAudioToolboxErr_NoSequence):
//            print("No Sequence")
//
//        case OSStatus(kAudioToolboxErr_InvalidEventType):
//            print("Invalid Event Type")
//
//        case OSStatus(kAudioToolboxErr_InvalidPlayerState):
//            print("Invalid Player State")
//
//        case OSStatus(kAudioToolboxErr_CannotDoInCurrentContext):
//            print("Cannot do in current context")
//
//        default:
//            print("Something or other went wrong")
//        }
//    }
//
//
//}

