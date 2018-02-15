//
//  SSSampleViewController.swift
//  SeeScoreiOS Sample App
//
//  You are free to copy and modify this code as you wish
//  No warranty is made as to the suitability of this for any purpose
//

import AVFoundation

let UseNoteCursor = true // define this to make the cursor move to each note as it plays, else it moves to the current bar
let PrintPlayData  = false // define this to print play data in the console when play is pressed
let ColourPlayedNotes = false // define this to colour played notes green
let ColourTappedItem = true // define this to colour any item tapped in the score for 0.5s
let PrintXMLForTappedBar = false // define this to print the XML for the bar in the console (contents licence needed)
let CreateMidiFile = false

/********** Event Handlers ***********/

class BarChangeHandler : NSObject, SSEventHandler
{
	let svc : SSSampleViewController
	var lastIndex : Int32
	
	init(vc : SSSampleViewController)
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
			svc.sysScrollView?.setCursorAtBar(index, type:cursor_line, scroll:scroll_bar)
		}
		else
		{
			svc.sysScrollView?.setCursorAtBar(index,
				type:(countIn) ? cursor_line : cursor_rect,
				scroll:scroll_bar)
		}
		
		svc.cursorBarIndex = Int(index)
		lastIndex = index
	}
}

class BeatHandler : NSObject, SSEventHandler {
	
	let svc : SSSampleViewController
	
	init(vc : SSSampleViewController)
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

	let svc : SSSampleViewController
	
	init(vc : SSSampleViewController)
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

	let svc : SSSampleViewController
	
	init(vc : SSSampleViewController)
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

class SSSampleViewController : UIViewController, UINavigationControllerDelegate, SSChangeSettingsProtocol, SSSyControls, SSUTempo, ScoreChangeHandler, SaveHandler, SSSynthParameterControls, SSFrequencyConverter
{
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
	
	private static  let kMinTempoScaling = 0.5
	private static  let kMaxTempoScaling = 2.0
	private static  let kMinTempo = 40
	private static  let kMaxTempo = 120
	private static  let kDefaultTempo = 80
	private static  let kStartPlayDelay = 1.0//s
	private static	let kStartDelay = 2.0//s
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
	@IBOutlet var transposeLabel : UILabel?
	@IBOutlet var stepper : UIStepper?
	@IBOutlet var playButton : UIBarButtonItem?
	@IBOutlet var countInLabel : UILabel?
	@IBOutlet var warningLabel : UILabel?
	@IBOutlet var tempoSlider : UISlider?
	@IBOutlet var tempoLabel : UILabel?
	@IBOutlet var metronomeSwitch : UISwitch?
	@IBOutlet var nextFileButton : UIBarButtonItem?
	@IBOutlet var versionLabel : UILabel?
	@IBOutlet var L_label : UIBarButtonItem?
	@IBOutlet var R_label : UIBarButtonItem?
	@IBOutlet var leftLoopButton : UIBarButtonItem?
	@IBOutlet var rightLoopButton : UIBarButtonItem?
	@IBOutlet var editButton: UIButton!
	@IBOutlet var layoutControl :UISegmentedControl?
	@IBOutlet var saveButton: UIButton!
	@IBOutlet var restoreButton: UIButton!
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
	
	private var currentFilePath : String?
	private var loadFileIndex : Int // increment to load next file in directory
	
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
	
	private var lastViewController : UIViewController?

	private var changeHandlerId : sscore_changeHandler_id?

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
	
	public required init?(coder aDecoder: NSCoder)
	{
		cursorBarIndex = 0
		showingSinglePart = false
		showingSinglePartIndex = 0
		showingParts = [NSNumber]()
		layOptions = SSLayoutOptions()
		loadFileIndex = 0
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
		if let srcURL = SSSampleViewController.urlForFileInBundle(filename: filename)
		{
			let dstURL = SSSampleViewController.urlForFileInDocuments(filename: filename)
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
		return ext == "xml"	|| ext == "mxl"
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
				//	device was removed from a dock connector that supports audio output. This is
				//	the recommended test for when to pause audio.
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
			NotificationCenter.default.addObserver(self, selector: #selector(SSSampleViewController.handleRouteChange), name: NSNotification.Name.AVAudioSessionRouteChange, object: sessionInstance)
			
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
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
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
		loadFileIndex = 0
		cursorBarIndex = 0
		loadNextFile()
		versionLabel?.text = SSScore.versionString()
		// test setting of background colour programmatically
		sysScrollView?.backgroundColor = UIColor(red:1.0, green:1.0, blue:0.95, alpha:1.0)
		loopStartBarIndex = -1
		loopEndBarIndex = -1
		tempoSlider?.isEnabled = false;
		leftLoopButton?.isEnabled = false;
		rightLoopButton?.isEnabled = false;
		editButton?.isEnabled = true;
		navigationController?.delegate = self;
		// enable restore button if file in documents is different from file in bundle
		enableButtons()
	}
	
	override func viewWillDisappear(_ animated : Bool)
	{
		sysScrollView?.abortBackgroundProcessing({
			self.lastMagnification = self.sysScrollView?.magnification
		})
	}
	
	deinit
	{
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
		var bestMatchIndex = SSSampleViewController.kInstrumentNotFound;
		// compare instrumentNameForPart to name of each instrument in our instrument 'library' kSampledInstrumentsInfo[]
		var index = Int(0)
		for info in kSampledInstrumentsInfo
		{
			let libraryInstrumentName = String(cString: info.info.instrument_name)
			if name.compare(libraryInstrumentName, options: String.CompareOptions.caseInsensitive) == ComparisonResult.orderedSame
			{
				maxMatchedChars = libraryInstrumentName.characters.count
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
						if altName.characters.count > maxMatchedChars
						{
							maxMatchedChars = altName.characters.count
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
					if full_name.characters.count > 0
					{
						let matchingIndex = indexOfInstrumentMatchingName(name: partName.full_name)
						if matchingIndex >= 0 && matchingIndex < SSSampleViewController.kMaxInstruments
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
					if instrumentNameForPart.characters.count > 0
					{
						let matchingIndex = indexOfInstrumentMatchingName(name: instrumentNameForPart)
						if matchingIndex >= 0 && matchingIndex < SSSampleViewController.kMaxInstruments
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
	
	func displayTempoSliderValue()
	{
		// show the required tempo slider - absolute (bpm) or relative (scaling)
		if let score = score
		{
			if let sliderValue = tempoSlider?.value
			{
				if score.scoreHasDefinedTempo
				{
					assert(sliderValue >= Float(SSSampleViewController.kMinTempoScaling) && sliderValue <= Float(SSSampleViewController.kMaxTempoScaling))
					let tempo = score.tempoAtStart()
					if tempo.bpm > 0
					{
						tempoLabel?.text = String(format:"%1.0f", sliderValue * Float(tempo.bpm))
					}
					else
					{
						tempoLabel?.text = String(format:"%1.1f", sliderValue)
					}
				}
				else
				{
					assert(sliderValue >= Float(SSSampleViewController.kMinTempo) && sliderValue <= Float(SSSampleViewController.kMaxTempo))
					tempoLabel?.text = String(format:"%d", Int(sliderValue))
				}
			}
		}
	}
	
	func setupTempoUI()
	{
		if let score = score
		{
			if score.scoreHasDefinedTempo
			{
				tempoSlider?.minimumValue = Float(SSSampleViewController.kMinTempoScaling)
				tempoSlider?.maximumValue = Float(SSSampleViewController.kMaxTempoScaling)
				tempoSlider?.value = 1.0
			}
			else
			{
				tempoSlider?.minimumValue = Float(SSSampleViewController.kMinTempo)
				tempoSlider?.maximumValue = Float(SSSampleViewController.kMaxTempo)
				tempoSlider?.value = Float(SSSampleViewController.kDefaultTempo)
			}
			self.tempoSlider?.isEnabled = true;
			displayTempoSliderValue()
		}
		else
		{
			self.tempoSlider?.isEnabled = false;
		}
	}
	
	static func titleFromHeader(header: SSHeader, maxlen: Int) -> String
	{
		var title = String()
		if !header.work_title.isEmpty
		{
			title.append(header.work_title)
			title.append(" ")
		}
		if !header.work_number.isEmpty && title.characters.count < maxlen
		{
			title.append(header.work_number)
			title.append(" ")
		}
		if !header.movement_title.isEmpty && title.characters.count < maxlen
		{
			title.append(header.movement_title)
			title.append(" ")
		}
		if !header.composer.isEmpty && title.characters.count < maxlen
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
				if (title.characters.count >= maxlen)
				{
					break;
				}
				idx += 1;
			}
		}
		if title.characters.count > maxlen
		{
			return String(title.characters.prefix(maxlen))
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
		title += " : " + SSSampleViewController.titleFromHeader(header: score.header, maxlen: 80)
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
	
	func loadFile(filePath : String)
	{
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
			currentFilePath = filePath;
			sysScrollView?.isHidden = false;
			sysScrollView?.abortBackgroundProcessing({ // empty dispatch queues
				self.sysScrollView?.clearAll()
				self.score = nil
				self.layoutControl?.selectedSegmentIndex = SSSampleViewController.kXMLLayoutSegment_normal
				self.stepper?.value = 0
				self.transposeLabel?.text = String(format:"%+d", 0)
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
					self.sysScrollView?.setupScore(self.score, openParts:self.showingParts, mag:Float(SSSampleViewController.kDefaultMagnification), opt:self.layOptions)
					self.barControl?.delegate = self.sysScrollView
					self.enableButtons()
					self.setupTempoUI()
				}
				if let err = err
				{
					switch (err.err)
					{
					case sscore_OutOfMemoryError:	print("out of memory")
						
					case sscore_XMLValidationError: print("XML validation error line:" + String(err.line) + " col:" + String(err.col) + " " + err.text)
						
					case sscore_NoBarsInFileError:	print("No bars in file error")
					case sscore_NoPartsError:		print("NoParts Error")
						
					case sscore_UnknownError:		print("Unknown error")

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
		enableButtons()
	}
	
	@IBAction func loadNextFile(_ sender: Any) {
		loadNextFile()
	}
	
	func loadNextFile() {
		stopPlaying()
		if let sampleMXLFileUrls = Bundle.main.urls(forResourcesWithExtension: "mxl", subdirectory:""),
			let sampleXMLFileUrls = Bundle.main.urls(forResourcesWithExtension: "xml", subdirectory:"")
		{
			let sampleFileUrls = sampleXMLFileUrls + sampleMXLFileUrls
			var sortedUrls = sampleFileUrls.sorted { $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == ComparisonResult.orderedAscending }
			let loadSampleUrl = sortedUrls[loadFileIndex]
			// get filename of next xml/mxl file in Bundle.
			var localFileUrl : URL? = SSSampleViewController.urlForFileInDocuments(filename: loadSampleUrl.lastPathComponent)
			if let url = localFileUrl // if the same name exists in Documents use that, else restore from Bundle
			{
				if (!FileManager.default.fileExists(atPath: url.path))
				{
					localFileUrl = SSSampleViewController.copyBundleFileToDocuments(filename: loadSampleUrl.lastPathComponent) // copy sample file to Documents directory
				}
			}
			if let url = localFileUrl
			{
				loadFile(filePath: url.path)
				loadFileIndex = loadFileIndex + 1
				if loadFileIndex >= sampleFileUrls.count
				{
					loadFileIndex = 0;
				}
			}
		}
	}
	
	@IBAction func restoreOriginalFile(_ sender: Any) {
		if let filepath = currentFilePath
		{
			if restoreFile(filename: URL(fileURLWithPath: filepath).lastPathComponent)
			{
				loadFile(filePath: filepath)
			}
		}
	}

	func restoreFile(filename : String) -> Bool
	{
		if let _ = SSSampleViewController.copyBundleFileToDocuments(filename: filename)
		{
			// check file in documents is now identical to file in bundle
			let fileIsChanged = SSSampleViewController.documentsFileIsChanged(filename: filename)
			assert(!fileIsChanged)
			// disable restore button
			enableButtons()
			return !fileIsChanged
		}
		return false
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
						sysScrollView.setCursorAtBar(sysPt.barIndex, type:cursor_rect, scroll:scroll_bar)
						
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
								let playRestartTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(SSSampleViewController.kRestartDelay * 1000.0))
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
			enableButtons()
		}
	}

	open override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let popover = popover
		{
			popover.dismiss(animated: false) // dismiss any popover automatically
		}
		popover = nil

		if segue.identifier == "info"
		{
			let ivc = segue.destination as! InfoViewController
			ivc.showHeaderInfo(score)
			popover = segue.destination
		}
		else if segue.identifier == "settings"
		{
			let svc = segue.destination as! SSSettingsViewController
			let temperament = intonation.temperament == Intonation.Temperament.Just ? SSTemperament.JustC : SSTemperament.Equal
			svc.set(partNames: !layOptions.hidePartNames, barNumbers:!layOptions.hideBarNumbers,
			        voice: synthVoice,
			        temper: temperament,
			        symm:waveformSymmetryValue, rise: Float(0.5) * Float(waveformRiseFallValue) / Float(SSSampleViewController.kDefaultRiseFallSamples),
			        settingsProto:self)
			popover = segue.destination
		}
		else if segue.identifier == "edit"
		{
			clearPlayLoop()
			stopPlaying()
			if let score = score
			{
				sysScrollView?.clearAll() // we don't need to update the score view here when we have overlaid the edit viewcontroller. It can be updated completely when we return to this
				let vc = segue.destination as! SSEditViewController
				vc.setup(score: score, editType: .normal, openParts: showingParts, magnification:(sysScrollView?.magnification)!, saver:self)
			}
		}
		else if segue.identifier == "omrEdit"
		{
			clearPlayLoop()
			stopPlaying()
			if let score = score
			{
				sysScrollView?.clearAll() // we don't need to update the score view here when we have overlaid the edit viewcontroller. It can be updated completely when we return to this
				let vc = segue.destination as! SSEditViewController
				vc.setup(score: score, editType: .OMR, openParts: showingParts, magnification:(sysScrollView?.magnification)!, saver:self)
			}
		}
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
						layoutControl?.selectedSegmentIndex = SSSampleViewController.kXMLLayoutSegment_normal
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
		enableButtons()
	}

	
	@IBAction func transpose(_ sender: Any) {
		clearPlayLoop()
		stopPlaying()
		if let score = score
		{
			let stepper = sender as! UIStepper
			if (stepper.value < -8) // demonstrate change treble clefs to bass clef for transpose more than 8 semitones down
			{
				let singleclefchange = sscore_tr_staffclefchange(partindex: Int32(sscore_tr_kAllPartsPartIndex), staffindex: Int32(sscore_tr_kAllStaffsStaffIndex), conv: sscore_tr_clefconversion(fromclef:sscore_tr_trebleclef, toclef:sscore_tr_bassclef), dummy: (UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0)))
				var allclefchange = sscore_tr_clefchangedef()
				allclefchange.num = 1;
				allclefchange.staffchange.0 = singleclefchange
				sscore_tr_setclefchange(score.rawscore, &allclefchange)
			}
			else
			{
				sscore_tr_clearclefchange(score.rawscore)
			}
			score.setTranspose(Int32(stepper.value))
			transposeLabel?.text = String(format:"%+d", score.transpose())
			sysScrollView?.layoutOptions = layOptions
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
					assert(kSampledInstrumentsInfo.count + kSynthesizedInstrumentsInfo.count < SSSampleViewController.kMaxInstruments);
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
				if setupAudioSession()
				{
					playData = SSPData.createPlay(from: score, tempo:self)
					if let playData = playData
					{
						if CreateMidiFile
						{
							let midiUrl = SSSampleViewController.urlForFileInDocuments(filename: "MidiFile.mid")
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
						sysScrollView?.setCursorAtBar(Int32(self.cursorBarIndex), type:cursor_line, scroll:scroll_bar)
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
							let startTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(SSSampleViewController.kStartDelay * 1000.0))
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


	@IBAction func tempoChanged(_ sender: Any) {
		displayTempoSliderValue()
		if let playdata = playData
		{
			playdata.updateTempo()
		}
	}

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
		layOptions.ignoreXMLPositions = ctl.selectedSegmentIndex == SSSampleViewController.kXMLLayoutSegment_ignore;
		layOptions.useXMLxLayout = ctl.selectedSegmentIndex == SSSampleViewController.kXMLLayoutSegment_exact;
		sysScrollView?.magnification = 1.0;
		lastMagnification = sysScrollView?.magnification
		sysScrollView?.layoutOptions = layOptions
	}

	@IBAction func tapR(_ sender: Any) {
		rEnabled = !rEnabled;
		R_label?.tintColor = rEnabled ? UIColor.red : UIColor.white
	}
	
	@IBAction func tapL(_ sender: Any) {
		lEnabled = !lEnabled;
		L_label?.tintColor = lEnabled ? UIColor.green : UIColor.white
	}
	
	@IBAction func tapLRepeat(_ sender: Any) {
		if let sysScrollView = sysScrollView
		{
			if (sysScrollView.displayingCursor)
			{
				if let score = score
				{
					if let synth = synth
					{
						if synth.isPlaying
						{
							synth.reset()
						}
					}
					if (loopStartBarIndex != Int(sysScrollView.cursorBarIndex)) {
						loopStartBarIndex = Int(sysScrollView.cursorBarIndex)
						if (loopEndBarIndex < 0)
						{
							loopEndBarIndex = Int(score.numBars-1) // tap left with right undefined sets right to last bar
						}
						sysScrollView.displayPlayLoopGraphicsLeft(Int32(loopStartBarIndex), right:Int32(loopEndBarIndex))
						if let playData = playData
						{
							playData.setLoopStart(Int32(loopStartBarIndex), loopBackBar:Int32(loopEndBarIndex), numRepeats:10)
						}
					}
					else { // clear loop with 2nd tap on left bar
						clearPlayLoop()
					}
				}
			}
		}
	}
	
	@IBAction func tapRRepeat(_ sender: Any) {
		if let sysScrollView = sysScrollView
		{
			if sysScrollView.displayingCursor
			{
				if let synth = synth
				{
					if synth.isPlaying
					{
						synth.reset()
					}
				}
				if loopEndBarIndex != Int(sysScrollView.cursorBarIndex)
				{
					loopEndBarIndex = Int(sysScrollView.cursorBarIndex)
					if (loopStartBarIndex < 0)
					{
						loopStartBarIndex = 0; // tap right with left undefined sets left to first bar - reasonable default
					}
					sysScrollView.displayPlayLoopGraphicsLeft(Int32(loopStartBarIndex), right:Int32(loopEndBarIndex))
					if let playData = playData
					{
						playData.setLoopStart(Int32(loopStartBarIndex), loopBackBar:Int32(loopEndBarIndex), numRepeats:10)
					}
				}
				else { // clear loop with 2nd tap on right bar
					clearPlayLoop()
				}
			}
		}
	}

	@IBAction func tapSave(_ sender: Any) {
		saveDocument()
	}
	
	func enableButtons()
	{
		editButton?.isEnabled = score != nil
		nextFileButton?.isEnabled = true
		L_label?.isEnabled = score != nil
		R_label?.isEnabled = score != nil
		playButton?.isEnabled = score != nil
		stepper?.isEnabled = score != nil
		metronomeSwitch?.isEnabled = score != nil
		layoutControl?.isEnabled = score != nil
		if let sysScrollView = sysScrollView
		{
			leftLoopButton?.isEnabled = score != nil && sysScrollView.displayingCursor
			rightLoopButton?.isEnabled = score != nil && sysScrollView.displayingCursor
		}
		else
		{
			leftLoopButton?.isEnabled = false
			rightLoopButton?.isEnabled = false
		}
		if let currentFilePath = currentFilePath
		{
			let filename = URL(fileURLWithPath: currentFilePath).lastPathComponent
			if let score = score
			{
				setTitle(filename : filename, score : score)
			}
			let canSave = score != nil && score!.isModified
			let canRestore = SSSampleViewController.documentsFileIsChanged(filename: filename)
			
			if !canSave && canRestore // show enabled restore button
			{
				saveButton.isHidden = true
				restoreButton.isHidden = false
				restoreButton.isEnabled = true
			}
			else
			{
				saveButton.isHidden = false
				restoreButton.isHidden = true
			}
			saveButton.isEnabled = canSave
		}
		else
		{
			saveButton.isHidden = false
			restoreButton.isHidden = true
			saveButton.isEnabled = false
			restoreButton.isEnabled = false
		}
	}
	
	func installChangeHandler()
	{
		if let score = score
		{
			changeHandlerId = score.add(self)
		}
	}
	
	func uninstallChangeHandler()
	{
		if let score = score
		{
			score.removeChangeHandler(self.changeHandlerId!)
		}
	}

	// rotate screen
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		sysScrollView?.didRotate()
	}

//protocol SaveHandler
	func saveDocument()
	{
		if let currentFilePath = currentFilePath
		{
			let err = score?.save(toFile: currentFilePath)
			if err == sscore_NoError
			{
				print("save to <" + currentFilePath + "> succeeded")
			}
			else
			{
				print("save to <" + currentFilePath + "> failed")
			}
		}
		enableButtons()
	}

//protocol SSChangeSettingsProtocol

	internal func showPartNames(_ pn : Bool)
	{
		clearPlayLoop()
		layOptions.hidePartNames = !pn;
		sysScrollView?.layoutOptions = layOptions
	}
	
	internal func showBarNumbers(_ bn : Bool)
	{
		clearPlayLoop()
		layOptions.hideBarNumbers = !bn;
		sysScrollView?.layoutOptions = layOptions
	}

	internal func changeSound(_ voice: SSSynthVoice) {
		if let synth = synth
		{
			if synth.isPlaying
			{
				// if we change from sampled to synth or vice versa we need to reset
				if (voice == SSSynthVoice.Sampled) != (synthVoice == SSSynthVoice.Sampled)
				{
					synthVoice = voice
					synth.reset()
					var err = synth.setup(playData)
					if err == sscore_NoError
					{
						let restartTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(SSSampleViewController.kRestartDelay * 1000.0))
						let countIn = false
						err = synth.start(at: restartTime.rawValue, bar:Int32(cursorBarIndex), countIn:countIn) // start synth
					}
					if (err == sscore_UnlicensedFunctionError)
					{
						error(message: "synth license expired!")
					}
					else if (err != sscore_NoError)
					{
						error(message: "synth failed to restart!")
					}
				}
				//else we can change synth waveforms without stopping synth
			}
		}
		synthVoice = voice
	}

	internal func changeSymmetry(_ symmetry: Float) {
		waveformSymmetryValue = symmetry
	}
	
	internal func changeTemperament(_ temperament: SSTemperament) {
		intonation.temperament = (temperament == SSTemperament.JustC) ? Intonation.Temperament.Just : Intonation.Temperament.Equal
	}
	

	internal func changeRiseFall(_ risefall: Float) {
		assert(risefall >= 0 && risefall <= 1.0)
		waveformRiseFallValue = max(1, Int(Float(2.0) * risefall * Float(SSSampleViewController.kDefaultRiseFallSamples))) // min 1 sample, default 4 samples, max 9 samples
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
		return (metronomeSwitch?.isOn)! ? 1.0 : 0.0 // switch off metronome by setting volume = 0 (if we use enabled we cannot switch it on while playing)
	}

//optional
	public func partStaffEnabled(_ partIndex: Int32, staff staffIndex: Int32) -> Bool
	{
		return (staffIndex == 0) ? rEnabled : lEnabled;
	}
	
	func loopStartIndex() -> Int32
	{
		return Int32(loopStartBarIndex);
	}
	
	func loopEndIndex() -> Int32
	{
		return Int32(loopEndBarIndex);
	}
	
	func loopRepeats() -> Int32
	{
		return loopStartBarIndex >= 0 && loopEndBarIndex >= 0 ? 10 : 0; // return 0 when not looping
	}
	
	
	//protocol SSUTempo
	
	func bpm() -> Int32
	{
		if let slider = tempoSlider
		{
			return Int32(limit(val: slider.value, min: Float(SSSampleViewController.kMinTempo), max: Float(SSSampleViewController.kMaxTempo)))
		}
		else
		{
			return 0
		}
	}
	
	func tempoScaling() -> Float
	{
		if let slider = tempoSlider
		{
			return limit(val: slider.value, min: Float(SSSampleViewController.kMinTempoScaling), max: Float(SSSampleViewController.kMaxTempoScaling))
		}
		else
		{
			return 0
		}
	}

	// optional method allows you to set the time of the slash-grace (acciaccatura) in releation to the crotchet (quarter note)
	func slashGracesPerCrotchet() -> Int32
	{
		return 0 // 0 = use default fixed time of 0.1s
	}


//protocol ScoreChangeHandler

	public func change(_ prev: OpaquePointer!, newstate: OpaquePointer!, reason: Int32)
	{
		sysScrollView?.relayout()
		enableButtons()
	}


//protocol UINavigationControllerDelegate
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
	{
		if let last = lastViewController
		{
			if viewController.isKind(of: SSSampleViewController.self)
				&& last.isKind(of: SSEditViewController.self)
			{
				guard let sc = self.score else { return }
				// display all parts (parts may have been added or removed while editing)
				self.showingParts = displayAllParts(score: sc)
				sysScrollView?.setupScore(self.score, openParts:self.showingParts, mag:self.lastMagnification ?? 1.0, opt:self.layOptions)
				// enable restore button if file in documents is different from file in bundle
				enableButtons()
			}
		}
	}

	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated:Bool)
	{
		lastViewController = viewController
	}
}
