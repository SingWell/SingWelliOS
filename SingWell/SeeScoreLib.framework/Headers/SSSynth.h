//
//  SSSynth.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import "SSEventHandler.h"

#include "sscore_synth.h"

/*!
 @header SSSynth.h
 @abstract interface to the SeeScore iOS synthesizer
 */


/*!
 @interface SSSampledInstrumentInfo
 @abstract defines a sampled instrument
 */
@interface SSSampledInstrumentInfo : NSObject

@property (readonly) sscore_sy_sampledinstrumentinfo info;

/*!
 @method initWith:base_filename:extension:base_midipitch:numfiles:volume:attack_time_ms:decay_time_ms:overlap_time_ms:lternativenames:pitch_offset:family:flags:samplesflags:
 @abstract initialise the SSSampledInstrumentInfo
 @param instrument_name the name of the instrument
 @param base_filename the start of the filename before the .(midipitch)
 @param extension the filename extension
 @param base_midipitch the pitch of the lowest pitch sample file
 @param numfiles the number of sample files with sequential midi values from base_midipitch
 @param volume for adjustment of balance with other instruments
 @param attack_time_ms time from start of sample play to beat reference point
 @param decay_time_ms 90% to 10% sigmoid decay time
 @param overlap_time_ms overlap with following note
 @param alternativenames comma-separated (lower case) alternative names for matching part name, eg "cello,violoncello"
 @param pitch_offset the pitch offset for a transposing instrument (not normally required as this is handled by the MusicXML transpose element). Default is 0
 @param family type of instrument
 @param flags bit set of sscore_sy_sampledinstrument_flags
 @param samplesflags bit set of sscore_sy_sampledinstrument_samples_flags
 */
-(instancetype)initWith:(NSString *)instrument_name
		  base_filename:(NSString *)base_filename
			  extension:(NSString *)extension
		 base_midipitch:(int)base_midipitch
			   numfiles:(int)numfiles
				 volume:(float)volume
		 attack_time_ms:(int)attack_time_ms
		  decay_time_ms:(int)decay_time_ms
		overlap_time_ms:(int)overlap_time_ms
	   alternativenames:(NSString *)alternativenames
		   pitch_offset:(int)pitch_offset
				 family:(enum sscore_sy_instrumentfamily)family
				  flags:(unsigned)flags
		   samplesflags:(unsigned)samplesflags;

@end


/*!
 @protocol SSFrequencyConverter
 @abstract encapsulate a single method to convert a midi pitch to frequency
 */
@protocol SSFrequencyConverter <NSObject>

/*!
 @method frequency:
 @abstract convert a midi pitch to frequency
 */
-(float)frequency:(int)midiPitch;

@end

/*!
 @protocol SSSynthParameterControls
 @abstract encapsulate methods returning parameters for synthesizer
 */
@protocol SSSynthParameterControls <NSObject>

/*!
 @method waveform
 @abstract return a waveform type for the waveform generator
 */
-(enum sscore_sy_synthesizedinstrument_waveform)waveform;

/*!
 @method waveformSymmetry
 @abstract return a symmetry value for square and triangle waveforms
 */
-(float)waveformSymmetry;

/*!
 @method waveformRiseFall
 @abstract return a rise-fall value for the square waveform (in samples at 44100samples/s)
 */
-(int)waveformRiseFall;

@end


@interface SSSynthesizedInstrumentInfo : NSObject

@property (readonly) sscore_sy_synthesizedinstrumentinfo info;

/*!
 @param instrument_name the name of the instrument
 @param volume for adjustment of balance with other instruments
 @param type type of instrument (eg tick2 or pitched waveform)
 @param attack_time_ms 10% to 90% sigmoid attack time at start of note (may be ignored for some instruments eg tick)
 @param decay_time_ms 90% to 10% sigmoid decay time at end of note (ditto)
 @param flags OR'd sscore_sy_synthesizedinstrument_flags
 @param frequencyConv a protocol encapsulating a function which converts midi pitch value to frequency - nil to use standard pitch conversion
 @param parameters a protocol encapsulating a set of functions which return parameters specific to the instrument - nil to use default parameters
*/
-(instancetype)initWith:(NSString *)instrument_name
				 volume:(float)volume
				   type:(enum sscore_sy_synthesizedinstrument_type)type
		 attack_time_ms:(int)attack_time_ms
		  decay_time_ms:(int)decay_time_ms
				  flags:(unsigned)flags
		  frequencyConv:(id<SSFrequencyConverter>)frequencyConv
			 parameters:(id<SSSynthParameterControls>)parameters;

@end

/*!
 @protocol SSSyControls
 @abstract interface to UI synthesizer controls
 */
@protocol SSSyControls <NSObject>

/*!
 @method partEnabled
 @abstract is the part enabled for play?
 @return true if the part is enabled for playing
 */
-(bool)partEnabled:(int)partIndex;

/*!
 @method partInstrument
 @abstract get the instrument id
 @return the instrument id
 */
-(unsigned)partInstrument:(int)partIndex;

/*!
 @method partVolume
 @abstract get the part volume
 @return the relative volume of the part [0.0 .. 1.0]
 */
-(float)partVolume:(int)partIndex;

/*!
 @method metronomeEnabled
 @abstract is the metronome enabled?
 @return true if the metronome (virtual) part should be played
 */
-(bool)metronomeEnabled;

/*!
 @method metronomeInstrument
 @abstract get the metronome instrument id
 @return the id of the metronome instrument
 */
-(unsigned)metronomeInstrument;

/*!
 @method metronomeVolume
 @abstract get the metronome volume
 @return the relative volume of the metrnonome part  [0.0 .. 1.0]
 */
-(float)metronomeVolume;

@optional
/*!
 @method partStaffEnabled:staff:
 @abstract is the staff enabled for play in the part?
 @discussion optional method
 @return true if the staff is enabled for playing in the part
 */
-(bool)partStaffEnabled:(int)partIndex staff:(int)staffIndex;

/*!
 @method loopStartIndex
 @abstract play loop support
 @discussion optional method
 @return the bar index of the first bar in the play loop
 */
-(int)loopStartIndex;

/*!
 @method loopEndIndex 
 @abstract play loop support
 @discussion optional method
 @return the bar index of the last bar in the play loop
 */
-(int)loopEndIndex;

/*!
 @method loopRepeats (optional method)
 @abstract play loop support
 @return the number of repeats of the play loop. 0 to disable looping
 */
-(int)loopRepeats;

@end

@class SSScore;
@class SSPData;

/*!
 @interface SSSynth
 @abstract the interface to the synthesizer which plays the MusicXML score
 */
@interface SSSynth : NSObject

/*!
 @property isPlaying
 @abstract true if playing
 */
@property (readonly) bool isPlaying;

/*!
 @property isPaused
 @abstract true if paused
 */
@property (readonly) bool isPaused;

/*!
 @property playingBar
 @abstract the 0-based index of the bar which is currently being played
 */
@property (readonly) int playingBar;

/*!
 @method createSynth:
 @abstract create the synthesizer
 @param controls the object which implements SSSyControls to control the synth (usually using UI controls, sliders, switches etc)
 @param score the score (used to access the key)
 */
+(SSSynth*)createSynth:(id<SSSyControls>)controls score:(SSScore*)score;

/*!
 @deprecated This cannot be called directly from Swift - use addSampledInstrument_alt
 @method addSampledInstrument:
 @abstract add a sampled instrument and return its unique identifier
 @param info describes the instrument including the filenames of the samples in the app resources, usually defined as a static const
 */
-(sscore_sy_instrumentid)addSampledInstrument:(const sscore_sy_sampledinstrumentinfo *)info __deprecated;

/*!
 @deprecated This cannot be called directly from Swift - use addSynthesizedInstrument_alt
 @method addSynthesizedInstrument:
 @abstract add a synthesized instrument (metronome tick)
 @param info description of the instrument, usually defined as a static const
 */
-(sscore_sy_instrumentid)addSynthesizedInstrument:(const sscore_sy_synthesizedinstrumentinfo *)info __deprecated;

/*!
 @method addSampledInstrument_alt:
 @abstract add a sampled instrument and return its unique identifier
 @discussion if no instrument is added the synth can still run but only to call the event handlers
 @param info describes the instrument including the filenames of the samples in the app resources, usually defined as a static const
 */
-(sscore_sy_instrumentid)addSampledInstrument_alt:(SSSampledInstrumentInfo *)info;

/*!
 @method addSynthesizedInstrument_alt:
 @abstract add a synthesized instrument (metronome tick or other)
 @discussion if no instrument is added the synth can still run but only to call the event handlers
 @param info description of the instrument, usually defined as a static const
 */
-(sscore_sy_instrumentid)addSynthesizedInstrument_alt:(SSSynthesizedInstrumentInfo *)info;

/*!
 @method removeInstrument:
 @abstract remove the instrument
 @param instrument the id returned from addXXXInstrument
 */
-(void)removeInstrument:(sscore_sy_instrumentid)instrument;

/*!
 @method setup:
 @abstract setup the synthesizer with the play data
 @param playdata the information about what to play
 */
-(enum sscore_error)setup:(SSPData*)playdata;

/*!
 @method startAt:
 @abstract start playing at the given time from the start of the given bar
 @discussion if no instrument has been added the synth can still run but only to call the event handlers
 @param start_time the (future) time to start playing
 @param barIndex the 0-based bar to start playing from
 @param countIn set if you want a count-in bar at the start
 */
-(enum sscore_error)startAt:(dispatch_time_t)start_time bar:(int)barIndex countIn:(bool)countIn;

/*!
 @method pause
 @abstract pause play
 */
-(void)pause;

/*!
 @method resume
 @abstract resume play if paused
 */
-(void)resume;

/*!
 @method reset
 @abstract stop play and reset the play position to the start
 @discussion you need to call setup: again to play after reset
 */
-(void)reset;

/*!
 @method setNextBarToPlay
 @abstract if the bar is within range (with the current settings including loop settings) then
 set the next bar to play. The synth will automatically stop play and restart at the new bar
 @param barIndex the bar to jump to
 @param restart_time the (future) time to restart play from the start of the new bar
 @return false if failed
 */
-(bool)setNextBarToPlay:(int)barIndex at:(dispatch_time_t)restart_time;

/*!
 @method updateTempoAt:
 @abstract called on changing something which will affect the return value from SSUTempo which was supplied to the SSPData.
 The play tempo will update at the given time
 @param restart_time the time to restart with the new tempo (at the start of the current bar)
 */
-(void)updateTempoAt:(dispatch_time_t)restart_time;

/*!
 @method changedControls
 @abstract notification that the SSSyControls have changed
 */
-(void)changedControls;

/*!
 @method setBarChangeHandler:
 @abstract register an event handler to be called at the start of each bar
 @param handler the handler to be called at the start of each bar
 @param delay_ms a millisecond delay for the handler call, which can be negative (normally) to anticipate the bar change eg for an animated cursor
 */
-(void)setBarChangeHandler:(id<SSEventHandler>) handler delay:(int)delay_ms;

/*!
 @method setBeatHandler:
 @abstract register an event handler to be called on each beat in the bar
 @param handler the handler to be called on each beat
 @param delay_ms a millisecond delay for the handler call, which can be negative to anticipate the event
 */
-(void)setBeatHandler:(id<SSEventHandler>) handler delay:(int)delay_ms;

/*!
 @method setEndHandler:
 @abstract register an event handler to be called on completion of play
 @param handler the handler to be called at the end of play
 @param delay_ms a millisecond delay for the handler call, which can be negative to anticipate the event
 */
-(void)setEndHandler:(id<SSEventHandler>) handler delay:(int)delay_ms;

/*!
 @method setNoteHandler:
 @abstract register an event handler to be called on start and end of new note/chord
 @discussion This can be used to move a cursor onto each note as it is played.
 NB for a piece with many fast notes you need to ensure your handler is fast enough to handle the throughput.
 You will probably define the endNote() method to do nothing as this is called for every note, unlike startNotes
 which is only called once per chord
 @param handler the handler to be called at the start and end of each note
 @param delay_ms a millisecond delay for the handler call, which can be negative to anticipate the event
 */
-(void)setNoteHandler:(id<SSNoteHandler>) handler delay:(int)delay_ms;

@end
