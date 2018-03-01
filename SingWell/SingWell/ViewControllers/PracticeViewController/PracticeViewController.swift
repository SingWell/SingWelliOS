//
//  PracticeViewController.swift
//  SingWell
//
//  Created by Travis Siems on 2/9/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
//import SeeScoreLib
import AVFoundation
import IoniconsKit
import IBAnimatable


let UseNoteCursor = true // define this to make the cursor move to each note as it plays, else it moves to the current bar
let PrintPlayData  = false // define this to print play data in the console when play is pressed
let ColourPlayedNotes = false // define this to colour played notes green
let ColourTappedItem = true // define this to colour any item tapped in the score for 0.5s
let PrintXMLForTappedBar = false // define this to print the XML for the bar in the console (contents licence needed)
let CreateMidiFile = false


class PracticeViewController: UIViewController, PracticeSettingsDelegate {
    
//    var filename = "TestMXL.mxl"
    var filename = "AveVerumMozart.mxl"
    var metronomeOn = true
    var tempo = 80
    
    private var kSampledInstrumentsInfo : [SSSampledInstrumentInfo] {
        get {
            var rval = [SSSampledInstrumentInfo]()
            rval.append(SSSampledInstrumentInfo("Piano", base_filename: "Piano.mf", extension: "m4a", base_midipitch: 23, numfiles: 86, volume: Float(1.0), attack_time_ms: 4, decay_time_ms: 10, overlap_time_ms: 10, alternativenames: "piano,pianoforte,klavier", pitch_offset: 0, family: sscore_sy_instrumentfamily_hammeredstring, flags: 0, samplesflags: 0))
            //rval.append(SSSampledInstrumentInfo("MidiPercussion", base_filename: "Drum", extension: "mp3", base_midipitch: 35, numfiles: 47, volume: Float(1.0), attack_time_ms: 4, decay_time_ms: 10, overlap_time_ms: 10, alternativenames: "percussion,MidiPercussion", pitch_offset: 0, family: sscore_sy_instrumentfamily_midi_percussion, flags: sscore_sy_suppressrmscompensation_flag, samplesflags: 0))
            return rval
        }
    }
    
    private let intonation = Intonation(temperament: Intonation.Temperament.Equal)
    
    private var kSynthesizedInstrumentsInfo : [SSSynthesizedInstrumentInfo] {
        get {
            var rval = [SSSynthesizedInstrumentInfo]()
            rval.append(SSSynthesizedInstrumentInfo("Tick", volume: Float(1.0), type:sscore_sy_tick1, attack_time_ms:4, decay_time_ms:20, flags:0, frequencyConv: nil, parameters: nil))
            rval.append(SSSynthesizedInstrumentInfo("Waveform", volume: Float(1.0), type:sscore_sy_pitched_waveform_instrument, attack_time_ms:4, decay_time_ms:20, flags:0, frequencyConv: self, parameters: self))
            return rval
        }
    }
    
    
    private static let kDefaultMagnification = 1.0
    
//    private static  let kMinTempoScaling = 0.5
//    private static  let kMaxTempoScaling = 2.0
//    private static  let kMinTempo = 40
//    private static  let kMaxTempo = 120
    private static  let kDefaultTempo = 80
    private static  let kStartPlayDelay = 1.0//s
    private static    let kStartDelay = 2.0//s
    private static  let kRestartDelay = 0.2//s
    private static  let kDefaultRiseFallSamples = 4
    
    // UISegmentedControl indices
    private static  let kXMLLayoutSegment_normal = 0
    private static  let kXMLLayoutSegment_exact = 1
    private static  let kXMLLayoutSegment_ignore = 2
    
    private static let  kMaxInstruments = 10
    private static let  kMaxParts = 100
    
    
    @IBOutlet var barControl: SSBarControl!
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var playButton : UIButton?
    var playButtonSize:CGFloat = 50
    @IBOutlet var countInLabel : UILabel?
    @IBOutlet var warningLabel : UILabel?
    @IBOutlet var metronomeSwitch : UISwitch?
    @IBOutlet var sysScrollView : SSScrollView?
    
    public var cursorBarIndex : Int
    
    fileprivate var score : SSScore?
    private var playData : SSPData?
    private var synth : SSSynth?
    
    private var popover : UIViewController?
    private var tapRecognizer : UITapGestureRecognizer?
    private var pressRecognizer : UILongPressGestureRecognizer?
    
    private var showingSinglePart : Bool // is set when a single part is being displayed
    private var showingSinglePartIndex : Int
    
    private var showingParts : [NSNumber]
    private var layOptions : SSLayoutOptions // set of options for layout
    private var lastMagnification : Float?
    
    
    private var synthVoice = SSSynthVoice.Sampled
    private var waveformSymmetryValue = Float(0.5)
    private var waveformRiseFallValue = kDefaultRiseFallSamples // samples in rise/fall of square waveform
    
    private var sampledInstrumentIds : [UInt]
    private var synthesizedInstrumentIds : [UInt]
    private var metronomeInstrumentIds : [UInt]
    
    private var instrumentToPart_cache : [Int : UInt] // we cache instrument mapping to parts because partInstrument: is called very often
    
    private var rEnabled : Bool
    private var lEnabled : Bool
    
    private var loopStartBarIndex : Int // -1 for non-looping
    private var loopEndBarIndex : Int
    
    private var colouredNotes = [SSPDNote]()
    
    private var editMode : Bool
    
    private var changeHandlerId : sscore_changeHandler_id?

    public required init?(coder aDecoder: NSCoder)
    {
        cursorBarIndex = 0
        showingSinglePart = false
        showingSinglePartIndex = 0
        showingParts = [NSNumber]()
        layOptions = SSLayoutOptions()
        sampledInstrumentIds = [UInt]()
        synthesizedInstrumentIds = [UInt]()
        metronomeInstrumentIds = [UInt]()
        instrumentToPart_cache = [Int : UInt]()
        rEnabled = true
        lEnabled = true
        loopStartBarIndex = -1
        loopEndBarIndex = -1
        editMode = false
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Practice"

        editMode = false
        rEnabled = true
        lEnabled = true
        layOptions = SSLayoutOptions()
        showingSinglePart = false
        showingSinglePartIndex = 0
        sysScrollView?.scrollDelegate = barControl
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        sysScrollView?.addGestureRecognizer(tapRecognizer!)
        pressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(longPress))
        sysScrollView?.addGestureRecognizer(pressRecognizer!)
        cursorBarIndex = 0
        loadFile(filename: self.filename)
        // test setting of background colour programmatically
        sysScrollView?.backgroundColor = UIColor(red:1.0, green:1.0, blue:0.95, alpha:1.0)
        loopStartBarIndex = -1
        loopEndBarIndex = -1
        
        setPlayButton(ionicon: .play, size: playButtonSize)
        
        
        
//        tempoSlider?.isEnabled = false
        
//        leftLoopButton?.isEnabled = false;
//        rightLoopButton?.isEnabled = false;
//        editButton?.isEnabled = true;
        // enable restore button if file in documents is different from file in bundle
    }
    
    func updateSettings(_ tempo: Float?, _ metronomeOn: Bool?) {
        self.tempo = Int(tempo!)
        self.metronomeOn = metronomeOn!
//        print("SETTINGS - TEST \(tempo), \(metronomeOn)")
        
    }
    
    
    @IBAction func showSettingsModal(_ sender: Any?) {
        let presentingVC = AppStoryboard.PracticeSettings.initialViewController()
        if let presentedViewController = presentingVC as? PracticeSettingsViewController {
            //            setupModal(for: presentedViewController)
            presentedViewController.metronomeOn = self.metronomeOn
            presentedViewController.tempo = Float(self.tempo)
            presentedViewController.delegate = self
            present(presentedViewController, animated: true, completion: nil)
        }
    }
    
    func setupBarItem() {
        let menuBtn = AnimatableButton(type: .custom)
        menuBtn.setTitle("", for: .normal)
        menuBtn.tintColor = .black
        menuBtn.setImage(UIImage.ionicon(with: .iosGear, textColor: UIColor.black, size: CGSize(width: 35, height: 35)), for: .normal)
        menuBtn.addTarget(self, action: #selector(PracticeViewController.showSettingsModal(_:)), for: .touchUpInside)
        
        let menuItem = AnimatableBarButtonItem(customView: menuBtn)
        
        self.navigationItem.rightBarButtonItem = menuItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBarItem()
    }

    
    override func viewWillDisappear(_ animated : Bool)
    {
        print("PRACTICE - Aborting background processing:")
        sysScrollView?.abortBackgroundProcessing({
            print("PRACTICE - Aborted")
            self.lastMagnification = self.sysScrollView?.magnification
        })
        clearAudioSession()
        score = nil
        if let synth = synth
        {
            if synth.isPlaying
            {
                print("PRACTICE - PAUSE")
                setPlayButton(ionicon: .play, size: playButtonSize)
                synth.reset() // stop playing if playing
            }
        }
    }
    
    deinit
    {
        print("PRACTICE - DEINITING:")
        if editMode && (score != nil)
        {
            score?.removeChangeHandler(changeHandlerId!)
        }
        clearAudioSession()
        score = nil
    }
    
    func isEditMode() -> Bool
    {
        return editMode
    }
    
    func clearPlayLoop()
    {
        loopEndBarIndex = -1
        loopStartBarIndex = -1
        sysScrollView?.clearPlayLoopGraphics()
        if playData != nil
        {
            playData?.clearLoop()
        }
    }
    
    static let kInstrumentNotFound = -1
    
    // if found an instrument in our library which matches the name return its index, else return -1
    func indexOfInstrumentMatchingName(name : String) -> Int
    {
        var maxMatchedChars = 0; // we have to select the instrument which matches most characters (so 'violoncello' matches 'violoncello' and not 'violon' (violin)
        var bestMatchIndex = PracticeViewController.kInstrumentNotFound;
        // compare instrumentNameForPart to name of each instrument in our instrument 'library' kSampledInstrumentsInfo[]
        var index = Int(0)
        for info in kSampledInstrumentsInfo
        {
            let libraryInstrumentName = String(cString: info.info.instrument_name)
            if name.compare(libraryInstrumentName, options: String.CompareOptions.caseInsensitive) == ComparisonResult.orderedSame
            {
                maxMatchedChars = libraryInstrumentName.count
                bestMatchIndex = index
            }
            else // test alternative instrument names too
            {
                // comma-separated alternative names for this library instrument in a string
                let alternativeNames_commasep = String(cString:info.info.alternativenames)
                // convert to array of alternative names
                let alternativeNames_array : [String] = alternativeNames_commasep.components(separatedBy: CharacterSet(charactersIn:","))
                for altName in alternativeNames_array
                {
                    if name.compare(altName, options: String.CompareOptions.caseInsensitive) == ComparisonResult.orderedSame
                    {
                        if altName.count > maxMatchedChars
                        {
                            maxMatchedChars = altName.count
                            bestMatchIndex = index
                        }
                    }
                }
            }
            index = index + 1
        }
        return bestMatchIndex
    }
    
    func instrumentForPart(partIndex : Int) -> UInt
    {
        if let iid = instrumentToPart_cache[partIndex]
        {
            return iid
        }
        else
        {
            if let score = score
            {
                // try matching part name to library instrument
                let partName = score.header.parts[partIndex]
                if let full_name = partName.full_name
                {
                    if full_name.count > 0
                    {
                        let matchingIndex = indexOfInstrumentMatchingName(name: partName.full_name)
                        if matchingIndex >= 0 && matchingIndex < PracticeViewController.kMaxInstruments
                        {
                            let iid = sampledInstrumentIds[matchingIndex]
                            instrumentToPart_cache[partIndex] = iid
                            return iid
                        }
                    }
                }
                // try matching instrument name to library instrument
                if let instrumentNameForPart = score.instrumentName(forPart: Int32(partIndex))
                {
                    if instrumentNameForPart.count > 0
                    {
                        let matchingIndex = indexOfInstrumentMatchingName(name: instrumentNameForPart)
                        if matchingIndex >= 0 && matchingIndex < PracticeViewController.kMaxInstruments
                        {
                            let iid = sampledInstrumentIds[matchingIndex]
                            instrumentToPart_cache[partIndex] = iid
                            return iid
                        }
                    }
                }
            }
            let iid = sampledInstrumentIds[0] // default is first in list (piano) if no name match
            instrumentToPart_cache[partIndex] = iid
            return iid
        }
    }
    
//    func displayTempoSliderValue()
//    {
//        // show the required tempo slider - absolute (bpm) or relative (scaling)
//        if let score = score
//        {
//            if let sliderValue = tempoSlider?.value
//            {
//                if score.scoreHasDefinedTempo
//                {
//                    assert(sliderValue >= Float(PracticeViewController.kMinTempoScaling) && sliderValue <= Float(PracticeViewController.kMaxTempoScaling))
//                    let tempo = score.tempoAtStart()
//                    if tempo.bpm > 0
//                    {
//                        tempoLabel?.text = String(format:"%1.0f", sliderValue * Float(tempo.bpm))
//                    }
//                    else
//                    {
//                        tempoLabel?.text = String(format:"%1.1f", sliderValue)
//                    }
//                }
//                else
//                {
//                    assert(sliderValue >= Float(PracticeViewController.kMinTempo) && sliderValue <= Float(PracticeViewController.kMaxTempo))
//                    tempoLabel?.text = String(format:"%d", Int(sliderValue))
//                }
//            }
//        }
//    }
    
    // MARK: TEMPO!!
    func setupTempoUI()
    {
        if let score = score
        {
            if score.scoreHasDefinedTempo
            {
                tempo = Int(score.tempoAtStart().bpm)
                print("Setting tempo to: ", tempo)
            } else {
                tempo = Int(PracticeViewController.kDefaultTempo)
                print("Setting tempo to default: ", tempo)
            }
        }
//        if let score = score
//        {
//            if score.scoreHasDefinedTempo
//            {
//                tempoSlider?.minimumValue = Float(PracticeViewController.kMinTempoScaling)
//                tempoSlider?.maximumValue = Float(PracticeViewController.kMaxTempoScaling)
//                tempoSlider?.value = 1.0
//            }
//            else
//            {
//                tempoSlider?.minimumValue = Float(PracticeViewController.kMinTempo)
//                tempoSlider?.maximumValue = Float(PracticeViewController.kMaxTempo)
//                tempoSlider?.value = Float(PracticeViewController.kDefaultTempo)
//            }
//            self.tempoSlider?.isEnabled = true;
//            displayTempoSliderValue()
//        }
//        else
//        {
//            self.tempoSlider?.isEnabled = false;
//        }
    }
    
    static func titleFromHeader(header: SSHeader, maxlen: Int) -> String
    {
        var title = String()
        if !header.work_title.isEmpty
        {
            title.append(header.work_title)
            title.append(" ")
        }
        if !header.work_number.isEmpty && title.count < maxlen
        {
            title.append(header.work_number)
            title.append(" ")
        }
        if !header.movement_title.isEmpty && title.count < maxlen
        {
            title.append(header.movement_title)
            title.append(" ")
        }
        if !header.composer.isEmpty && title.count < maxlen
        {
            title.append("- ")
            title.append(header.composer)
            title.append(" ")
        }
        if (title.isEmpty) // use credit words if no other info available
        {
            var idx = Int(0)
            for cred in header.credit_words
            {
                if idx > 0
                {
                    title.append(" - ")
                }
                title.append(cred)
                if (title.count >= maxlen)
                {
                    break;
                }
                idx += 1;
            }
        }
        if title.count > maxlen
        {
            return String(title.prefix(maxlen))
        }
        else
        {
            return title;
        }
    }
    
    func setTitle(filename : String, score : SSScore)
    {
        var title = filename
        if score.isModified
        {
            title += " (*)"
        }
        title += " : " + PracticeViewController.titleFromHeader(header: score.header, maxlen: 80)
        self.titleLabel?.text = title
    }
    
    func displayAllParts(score : SSScore) -> [NSNumber]
    {
        var rval = [NSNumber]()
        let numParts = score.numParts
        for _ in 0 ... numParts - 1
        {
            rval.append(NSNumber(booleanLiteral: true)) // true for all parts
        }
        return rval
    }
    
    func loadFile(filename: String) {
        stopPlaying()
        var localFileUrl : URL? = PracticeViewController.urlForFileInDocuments(filename: filename)
        print(filename)
//        print(localFileUrl)
        if let url = localFileUrl // if the same name exists in Documents use that, else restore from Bundle
        {
            if (!FileManager.default.fileExists(atPath: url.path))
            {
                localFileUrl = PracticeViewController.copyBundleFileToDocuments(filename: filename) // copy sample file to Documents directory
            }
        }
        
        if let url = localFileUrl
        {
            loadFile(filePath: url.path)
        }
    }
    
    func loadFile(filePath : String)
    {
        print("Loading File!")
        
        editMode = false
        clearPlayLoop()
        if let synth = synth
        {
            synth.reset()
        }
        synth = nil // synth has to be recreated for a new file
        
        instrumentToPart_cache = [Int : UInt]()
        let loadable = loadableFile(filename: filePath)
        let readable = FileManager.default.isReadableFile(atPath: filePath)
        if (loadable && readable)
        {
            sysScrollView?.isHidden = false;
            sysScrollView?.abortBackgroundProcessing({ // empty dispatch queues
                self.sysScrollView?.clearAll()
                self.score = nil
//                self.layoutControl?.selectedSegmentIndex = PracticeViewController.kXMLLayoutSegment_normal
                self.showingSinglePart = false
                self.showingSinglePartIndex = 0
                self.showingParts = [NSNumber]()
                self.cursorBarIndex = 0
                let loadOptions = SSLoadOptions(key:sscore_libkey)
                loadOptions?.checkxml = true
                var err : SSLoadError?
                self.score = SSScore(xmlFile: filePath, options: loadOptions, error:&err)
                if let sc = self.score
                {
                    let filename = URL(fileURLWithPath: filePath).lastPathComponent
                    self.setTitle(filename: filename, score: sc)
                    self.showingParts = self.displayAllParts(score: sc)
                    self.layOptions = SSLayoutOptions() // set default layout
                    self.sysScrollView?.setupScore(self.score, openParts:self.showingParts, mag:Float(PracticeViewController.kDefaultMagnification), opt:self.layOptions)
                    self.barControl?.delegate = self.sysScrollView
                    self.setupTempoUI()
                    
                }
                if let err = err
                {
                    switch (err.err)
                    {
                    case sscore_OutOfMemoryError:    print("out of memory")
                        
                    case sscore_XMLValidationError: print("XML validation error line:" + String(err.line) + " col:" + String(err.col) + " " + err.text)
                        
                    case sscore_NoBarsInFileError:    print("No bars in file error")
                    case sscore_NoPartsError:        print("NoParts Error")
                        
                    case sscore_UnknownError:        print("Unknown error")
                        
                    default: break
                    }
                    
                    if !err.warnings.isEmpty
                    {
                        print("MusicXML consistency warnings:")
                        for warning in err.warnings
                        {
                            print(warning.toString)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func loadNextFile(_ sender: Any) {
        // TODO: reload file
    }
    
    
    @objc func tap()
    {
        countInLabel?.isHidden = true;
        if let sysScrollView = sysScrollView
        {
            if let p = tapRecognizer?.location(in: sysScrollView)
            {
                if (!editMode)
                {
                    let sysPt = sysScrollView.system(atPos: p)
                    if sysPt.isValid
                    {
                        print("tap: partindex:" + String(sysPt.partIndex) + " barindex:" +  String(sysPt.barIndex))
                        cursorBarIndex = Int(sysPt.barIndex);
                        sysScrollView.setCursorAtBar(sysPt.barIndex, type:cursor_rect, scroll:scroll_bar, shouldDisplayRect: true)
                        
                        if PrintXMLForTappedBar
                        {
                            if let score = score
                            {
                                var err = sscore_error(0)
                                let xml = score.xml(forPart: sysPt.partIndex, bar:sysPt.barIndex, err:&err)
                                if let xml = xml
                                {
                                    if !xml.isEmpty
                                    {
                                        print("XML for bar")
                                        print(xml)
                                    }
                                }
                            }
                        }
                        if let synth = synth
                        {
                            if synth.isPlaying
                            {
                                let playRestartTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(PracticeViewController.kRestartDelay * 1000.0))
                                synth.setNextBarToPlay(Int32(cursorBarIndex), at: playRestartTime.rawValue)
                            }
                        }
                        if ColourTappedItem
                        {
                            if let sys = sysScrollView.system(at: sysPt.systemIndex)
                            {
                                let components = sys.hitTest(sysPt.posInSystem)
                                if !components.isEmpty
                                {
                                    var elementTypes : UInt32 = 0
                                    elementTypes |= sscore_dopt_colour_notehead.rawValue
                                    sysScrollView.colour(components, colour:UIColor.cyan, elementTypes:elementTypes)
                                    //  remove colour after 0.5s
                                    let kDelayInSeconds = 0.5;
                                    let popTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(kDelayInSeconds * 1000.0))
                                    DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
                                        self.sysScrollView?.clearAllColouring()
                                    })
                                }
                            }
                        }
                    }
                }
                else
                {
                    sysScrollView.hideCursor()
                }
                
            }
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let popover = popover
        {
            popover.dismiss(animated: false) // dismiss any popover automatically
        }
        popover = nil
    }
    
    func stopPlaying()
    {
        if let synth = synth
        {
            if synth.isPlaying
            {
                synth.reset()
                countInLabel?.isHidden = true
                clearAudioSession()
            }
        }
    }
    
    @objc func longPress(sender : Any) {
        
        if !editMode
        {
            clearPlayLoop()
            stopPlaying()
            if let score = score
            {
                if pressRecognizer?.state == .ended
                {
                    if (showingSinglePart) // flip to showing all parts
                    {
                        showingSinglePart = false;
                        showingParts = [NSNumber](repeating:NSNumber(booleanLiteral: true), count:Int(score.numParts))
                        sysScrollView?.displayParts(showingParts)
                    }
                    else // flip to showing a single part
                    {
//                        layoutControl?.selectedSegmentIndex = PracticeViewController.kXMLLayoutSegment_normal
                        if let p = pressRecognizer?.location(in: sysScrollView)
                        {
                            if let partIndex = sysScrollView?.partIndex(forPos: p)
                            {
                                if (partIndex >= 0)
                                {
                                    assert(partIndex < score.numParts);
                                    showingParts = [NSNumber]()
                                    for i in 0 ... score.numParts-1
                                    {
                                        showingParts.append(NSNumber(booleanLiteral: (i == partIndex)))
                                    }
                                    sysScrollView?.displayParts(showingParts)
                                    showingSinglePart = true
                                    showingSinglePartIndex = Int(partIndex)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // return xpos of centre of notehead of note or 0
    func noteXPos(_ note : SSPDNote) -> Float
    {
        if let system = sysScrollView?.systemContainingBarIndex(note.startBarIndex)
        {
            let comps = system.components(forItem: note.item_h)
            // find centre of notehead or rest
            for comp in comps
            {
                if comp.type == sscore_comp_notehead
                    || comp.type == sscore_comp_rest
                {
                    return Float(comp.rect.origin.x + comp.rect.size.width / 2);
                }
            }
            return 0;
        }
        else
        {
            return 0;
        }
    }
    
    func moveNoteCursor(notes : [SSPDPartNote])
    {
        for note in notes // normally this will not need to iterate over the whole chord, but will exit as soon as it has a valid xpos
        {
            if (note.note.midiPitch > 0 && note.note.start >= 0) // priority given to notes over rests, but ignore cross-bar tied notes
            {
                let xpos = noteXPos(note.note)
                if xpos > 0 // noteXPos returns 0 if the note isn't found in the layout (it might be in a part which is not shown)
                {
                    sysScrollView?.setCursorAtXpos(xpos, barIndex:note.note.startBarIndex, scroll:scroll_bar);
                    return; // abandon iteration
                }
            }
        }
        for note in notes // if no note found then we move to a rest
        {
            if (note.note.midiPitch == 0) // rest
            {
                let xpos = noteXPos(note.note)
                if xpos > 0 // noteXPos returns 0 if the note isn't found in the layout (it might be in a part which is not shown)
                {
                    sysScrollView?.setCursorAtXpos(xpos, barIndex:note.note.startBarIndex, scroll:scroll_bar)
                    return; // abandon iteration
                }
            }
        }
    }
    
    func numBars() -> Int
    {
        return Int(score!.numBars)
    }
    
    func colourPDNotes(notes : [SSPDNote])
    {
        colouredNotes = notes
        sysScrollView?.colour(notes, colour:UIColor.green)
    }
    
    func changeColouredPDNote(note : SSPDNote)
    {
        sysScrollView?.clearAllColouring()
        colouredNotes = colouredNotes.filter { (n : SSPDNote) -> Bool in
            n != note
        }
        sysScrollView?.colour(colouredNotes, colour:UIColor.green)
        var newColourNotes = [SSPDNote]()
        newColourNotes.append(note)
        sysScrollView?.colour(newColourNotes, colour:UIColor.red) // colour the ended note red
    }
    
    func displaynotes(pd : SSPData)
    {
        if PrintPlayData
        {
            if let score = score,
                let playData = playData
            {
                for bar in playData.bars
                {
                    print("bar " + String(bar.index) + " duration:" + String(bar.duration_ms) + "ms")
                    for partIndex in 0 ... score.numParts-1
                    {
                        if let part = bar.part(partIndex)
                        {
                            let partStr = "part " + String(partIndex) + " ";
                            for note in part.notes
                            {
                                let noteStr = ((note.grace != sscore_pd_grace_no) ? "grace" : "note") + " pitch:" + String(note.midiPitch) + " startbar:" + String(note.startBarIndex) + " start:" + String(note.start) + "ms duration:" + String(note.duration) + "ms at x="
                                print(partStr + noteStr + String(noteXPos(note)))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func error(message : String)
    {
        self.warningLabel?.text = message
        self.warningLabel?.isHidden = message.isEmpty
    }
    
    func setPlayButton(ionicon:Ionicons=Ionicons.play, size:CGFloat) {
        self.playButton?.titleLabel?.font = UIFont.ionicon(of: size)
        self.playButton?.setTitle(String.ionicon(with: ionicon), for: .normal)
    }
    
    @IBAction func play(_ sender: Any) {
        error(message: "") // clear any error message
        countInLabel?.isHidden = true
        if let score = score
        {
            if ColourPlayedNotes
            {
                sysScrollView?.clearAllColouring()
            }
            if let synth = synth
            {
                if synth.isPlaying
                {
                    print("PAUSE")
                    setPlayButton(ionicon: .play, size: playButtonSize)
                    synth.reset() // stop playing if playing
                    return
                }
            }
            if synth == nil
            {
                synth = SSSynth.createSynth(self, score:score)
                if let synth = synth
                {
                    sampledInstrumentIds = [UInt]()
                    synthesizedInstrumentIds = [UInt]()
                    metronomeInstrumentIds = [UInt]()
                    assert(kSampledInstrumentsInfo.count + kSynthesizedInstrumentsInfo.count < PracticeViewController.kMaxInstruments);
                    for info in kSampledInstrumentsInfo
                    {
                        let iid = synth.addSampledInstrument_alt(info)
                        assert(iid > 0 && iid < 1000000)
                        sampledInstrumentIds.append(UInt(iid))
                    }
                    for info in kSynthesizedInstrumentsInfo
                    {
                        let iid = synth.addSynthesizedInstrument_alt(info)
                        switch info.info.type
                        {
                        case sscore_sy_tick1: metronomeInstrumentIds.append(UInt(iid))
                        case sscore_sy_pitched_waveform_instrument: synthesizedInstrumentIds.append(UInt(iid))
                        default: break
                        }
                    }
                }
            }
            if let synth = synth // start playing if not playing
            {
                print("PLAY")
                setPlayButton(ionicon: .pause, size: playButtonSize)
                if setupAudioSession()
                {
                    playData = SSPData.createPlay(from: score, tempo:self)
                    if let playData = playData
                    {
                        if CreateMidiFile
                        {
                            let midiUrl = PracticeViewController.urlForFileInDocuments(filename: "MidiFile.mid")
                            let midiErr = playData.createMidiFile(midiUrl.path)
                            if midiErr != sscore_NoError
                            {
                                print("error creating midi file")
                            }
                        }
                        
                        if (loopStartBarIndex >= 0 && loopEndBarIndex >= 0)
                        {
                            playData.setLoopStart(Int32(loopStartBarIndex), loopBackBar:Int32(loopEndBarIndex), numRepeats:10)
                            self.cursorBarIndex = loopStartBarIndex;
                        }
                        else
                        {
                            playData.clearLoop()
                        }
                        // display notes to play in console
                        displaynotes(pd: playData)
                        // setup bar change notification to move cursor
                        let cursorAnimationTime_ms = Int(CATransaction.animationDuration() * 1000.0)
                        sysScrollView?.setCursorAtBar(Int32(self.cursorBarIndex), type:cursor_line, scroll:scroll_bar, shouldDisplayRect: false)
                        if UseNoteCursor
                        {
                            synth.setNoteHandler(NoteHandler(vc: self), delay:-(Int32)(cursorAnimationTime_ms))
                        }
                        synth.setBarChange(BarChangeHandler(vc: self), delay:-(Int32)(cursorAnimationTime_ms))
                        synth.setEnd(EndHandler(vc: self), delay:0)
                        synth.setBeat(BeatHandler(vc: self), delay:0)
                        var err = synth.setup(playData)
                        if err == sscore_NoError
                        {
                            let startTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(PracticeViewController.kStartDelay * 1000.0))
                            let countIn = true
                            err = synth.start(at: startTime.rawValue, bar:Int32(cursorBarIndex), countIn:countIn) // start synth
                        }
                        if (err == sscore_UnlicensedFunctionError)
                        {
                            error(message: "synth license expired!")
                        }
                        else if (err != sscore_NoError)
                        {
                            error(message: "synth failed to start!")
                        }
                    }
                    else
                    {
                        error(message: "playdata is nil!")
                    }
                }
            }
            else
            {
                print("No licence for synth")
            }
        }
    }
    
    
//    @IBAction func tempoChanged(_ sender: Any) {
//        displayTempoSliderValue()
//        if let playdata = playData
//        {
//            playdata.updateTempo()
//        }
//    }
    
    @IBAction func metronomeSwitched(_ sender: Any) {
        if let synth = synth
        {
            if synth.isPlaying
            {
                synth.changedControls()
            }
        }
    }
    
    @IBAction func switchLayout(_ sender: Any) {
        let ctl = sender as! UISegmentedControl
        clearPlayLoop()
        layOptions.ignoreXMLPositions = ctl.selectedSegmentIndex == PracticeViewController.kXMLLayoutSegment_ignore;
        layOptions.useXMLxLayout = ctl.selectedSegmentIndex == PracticeViewController.kXMLLayoutSegment_exact;
        sysScrollView?.magnification = 1.0;
        lastMagnification = sysScrollView?.magnification
        sysScrollView?.layoutOptions = layOptions
    }

}

extension PracticeViewController: SSSyControls, SSUTempo, ScoreChangeHandler,  SSSynthParameterControls, SSFrequencyConverter {
    
    
    
    func defaultDirectoryPath() -> String
    {
        let searchPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return searchPaths[0]
    }
    
    static func urlForFileInDocuments(filename : String) -> URL
    {
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let dstURL = urls[0].appendingPathComponent(filename)
        return dstURL
    }
    
    static func urlForFileInBundle(filename : String) -> URL?
    {
        let ext = URL(fileURLWithPath: filename).pathExtension
        if let sampleFileUrls = Bundle.main.urls(forResourcesWithExtension: ext, subdirectory:"")
        {
            for url in sampleFileUrls
            {
                if url.lastPathComponent == filename
                {
                    return url
                }
            }
        }
        return nil
    }
    
    static func documentsFileIsChanged(filename : String) -> Bool
    {
        let docUrl = urlForFileInDocuments(filename: filename)
        if (FileManager.default.fileExists(atPath: docUrl.path))
        {
            if let bundleUrl = urlForFileInBundle(filename: filename)
            {
                return !FileManager.default.contentsEqual(atPath: bundleUrl.path, andPath: docUrl.path)
            }
        }
        return true
    }
    
    static func copyBundleFileToDocuments(filename : String) -> URL?
    {
        if let srcURL = PracticeViewController.urlForFileInBundle(filename: filename)
        {
            let dstURL = PracticeViewController.urlForFileInDocuments(filename: filename)
            do { try FileManager.default.removeItem(at: dstURL) } catch {} // ignore error
            do {
                try FileManager.default.copyItem(at: srcURL, to: dstURL)
                return dstURL
            }
            catch {
                return nil
            }
        }
        return nil
    }
    
    func loadableFile(filename : String) -> Bool
    {
        let ext = URL(fileURLWithPath: filename).pathExtension
        return ext == "xml"    || ext == "mxl"
    }
    
    func limit(val : Float, min : Float, max : Float) -> Float
    {
        if val < min
        {
            return min;
        }
        else if val > max
        {
            return max;
        }
        else
        {
            return val;
        }
    }
    
    // -Audio Session Route Change Notification
    
    @objc func handleRouteChange(notification : Notification)
    {
        let dict : Dictionary<String, NSNumber> = notification.userInfo as! Dictionary<String, NSNumber>
        if let routeChangeReason = dict[AVAudioSessionRouteChangeReasonKey]
        {
            let reasonValue = routeChangeReason.intValue
            
            switch (reasonValue) {
                // "Old device unavailable" indicates that a headset was unplugged, or that the
                //    device was removed from a dock connector that supports audio output. This is
            //    the recommended test for when to pause audio.
            case kAudioSessionRouteChangeReason_OldDeviceUnavailable:
                if let synth = synth
                {
                    if synth.isPlaying
                    {
                        synth.reset();
                    }
                }
                
            default: break
            }
        }
    }
    
    func setupAudioSession() -> Bool
    {
        // Configure the audio session
        let sessionInstance : AVAudioSession = AVAudioSession.sharedInstance()
        
        // our default category -- we change this for conversion and playback appropriately
        do {
            try sessionInstance.setCategory(AVAudioSessionCategoryPlayback)
            
            // we don't do anything special in the route change notification
            NotificationCenter.default.addObserver(self, selector: #selector(PracticeViewController.handleRouteChange), name: NSNotification.Name.AVAudioSessionRouteChange, object: sessionInstance)
            
            // activate the audio session
            try sessionInstance.setActive(true)
            
        } catch  {
            return false;// couldn't set audio category
        }
        
        return true;
    }
    
    func clearAudioSession()
    {
        NotificationCenter.default.removeObserver(self)
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
        }
    }
    
    //protocol ScoreChangeHandler
    
    public func change(_ prev: OpaquePointer!, newstate: OpaquePointer!, reason: Int32)
    {
        sysScrollView?.relayout()
//        enableButtons()
    }
    
    //protocol SSUTempo
    
    func bpm() -> Int32
    {
//        if let slider = tempoSlider
//        {
//            return Int32(limit(val: slider.value, min: Float(PracticeViewController.kMinTempo), max: Float(PracticeViewController.kMaxTempo)))
//        }
//        else
//        {
//            return 0
//        }
        return Int32(tempo)
    }
    
    func tempoScaling() -> Float
    {
//        if let slider = tempoSlider
//        {
//            return limit(val: slider.value, min: Float(PracticeViewController.kMinTempoScaling), max: Float(PracticeViewController.kMaxTempoScaling))
//        }
//        else
//        {
//            return 0
//        }
        return 1.0
    }
    
    
    // protocol SSFrequencyConverter
    
    /*!
     @method frequency:
     @abstract convert a midi pitch to frequency
     */
    public func frequency(_ midiPitch: Int32) -> Float
    {
        return intonation.frequency(midiPitch)
    }
    
    
    //protocol SSSynthParameterControls
    
    /*!
     @method waveform
     @abstract return a waveform type for the waveform generator
     @discussion called by the synthesizer while playing
     */
    func waveform() -> sscore_sy_synthesizedinstrument_waveform
    {
        switch synthVoice
        {
        case .Sine : return sscore_sy_sine
        case .Square : return sscore_sy_square
        case .Triangle : return sscore_sy_triangle
        default: return sscore_sy_sine
        }
    }
    
    /*!
     @method waveformSymmetry
     @abstract return a symmetry value for square and triangle waveforms
     @discussion called by the synthesizer while playing
     */
    func waveformSymmetry() -> Float
    {
        return waveformSymmetryValue
    }
    
    /*!
     @method waveformRiseFall
     @abstract return a rise-fall value for the square waveform (in samples at 44100samples/s)
     @discussion called by the synthesizer while playing
     */
    public func waveformRiseFall() -> Int32 {
        return Int32(waveformRiseFallValue)
    }
    
    //protocol SSSyControls
    /*
     SSSyControls is the interface between the synth and the UI elements which control
     instruments for parts and metronome
     */
    func partEnabled(_ partIndex : Int32) -> Bool
    {
        return partInstrument(partIndex) != 0 // ensure we have a non-zero instrument id
            && (!showingSinglePart || partIndex==Int32(showingSinglePartIndex))
    }
    
    func partInstrument(_ partIndex : Int32) -> UInt32
    {
        if synthVoice == SSSynthVoice.Sampled
        {
            return UInt32(instrumentForPart(partIndex : Int(partIndex)))
        }
        else if !synthesizedInstrumentIds.isEmpty
        {
            return UInt32(synthesizedInstrumentIds[0])
        }
        return 0
    }
    
    func partVolume(_ partIndex : Int32) -> Float
    {
        return 1.0;
    }
    
    func metronomeEnabled() -> Bool
    {
        if !metronomeInstrumentIds.isEmpty
        {
            return true // always enabled if we have a tick instrument so we can switch on and off while playing
        }
        else
        {
            return false
        }
    }
    
    func metronomeInstrument() -> UInt32
    {
        if !metronomeInstrumentIds.isEmpty
        {
            return UInt32(metronomeInstrumentIds[0])
        }
        else
        {
            return 0
        }
    }
    
    func metronomeVolume() -> Float
    {
        return metronomeOn ? 1.0 : 0.0 // switch off metronome by setting volume = 0 (if we use enabled we cannot switch it on while playing)
    }
}







enum SSSynthVoice {
    case Sampled
    case Tick
    case Sine
    case Square
    case Triangle
}

enum SSTemperament {
    case Equal
    case JustC
}

/********** Event Handlers ***********/

class BarChangeHandler : NSObject, SSEventHandler
{
    let svc : PracticeViewController
    var lastIndex : Int32
    
    init(vc : PracticeViewController)
    {
        svc = vc
        lastIndex = -1
        super.init()
    }
    
    public func event(_ index: Int32, countIn: Bool, at:dispatch_time_t)
    {
        if ColourPlayedNotes
        {
            if let score = svc.score
            {
                let startRepeat = index < lastIndex
                if (startRepeat)
                {
                    var br = sscore_barrange(startbarindex: index, numbars: score.numBars - index)
                    svc.sysScrollView?.clearColouring(forBarRange: &br)
                }
            }
        }
        
        if UseNoteCursor
        {
            //            print("PRACTICE - NOTE CURSOR")
            //            svc.sysScrollView?.setCursorAtBar(index, type:cursor_line, scroll:scroll_bar)
        }
        else
        {
            //            svc.sysScrollView?.setCursorAtBar(index,
            //                                              type:(countIn) ? cursor_line : cursor_rect,
            //                                              scroll:scroll_bar)
        }
        
        svc.cursorBarIndex = Int(index)
        lastIndex = index
    }
}

class BeatHandler : NSObject, SSEventHandler {
    
    let svc : PracticeViewController
    
    init(vc : PracticeViewController)
    {
        svc = vc
        super.init()
    }
    
    func event(_ index : Int32,  countIn : Bool, at:dispatch_time_t)
    {
        svc.countInLabel?.isHidden = !countIn
        if countIn
        {
            svc.countInLabel?.text = String.init(format: "%d", index + 1) // show count-in
        }
    }
}

class EndHandler : NSObject, SSEventHandler {
    
    let svc : PracticeViewController
    
    init(vc : PracticeViewController)
    {
        svc = vc
        super.init()
    }
    
    func event(_ index : Int32,  countIn : Bool, at:dispatch_time_t)
    {
        svc.sysScrollView?.hideCursor()
        svc.countInLabel?.isHidden = true
        svc.cursorBarIndex = 0
        svc.stopPlaying()
        if ColourPlayedNotes
        {
            svc.sysScrollView?.clearAllColouring()
        }
    }
}

class NoteHandler : NSObject, SSNoteHandler {
    
    let svc : PracticeViewController
    
    init(vc : PracticeViewController)
    {
        svc = vc
        super.init()
    }
    
    public func start(_ pnotes: [SSPDPartNote]!, at:dispatch_time_t)
    {
        assert(pnotes.count > 0)
        svc.moveNoteCursor(notes: pnotes)
        if ColourPlayedNotes
        {
            // convert array of SSPDPartNote to array of SSPDNote
            var notes = [SSPDNote]()
            for n in pnotes
            {
                notes.append(n.note)
            }
            svc.colourPDNotes(notes: notes)
        }
    }
    
    public func end(_ note: SSPDPartNote!, at:dispatch_time_t)
    {
        if ColourPlayedNotes
        {
            svc.changeColouredPDNote(note: note.note)
        }
    }
}


