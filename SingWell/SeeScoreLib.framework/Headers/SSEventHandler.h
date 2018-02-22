//
//  SSEventHandler.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import "SSPData.h"

/*!
 @header SSEventHandler.h
 @abstract Event handler for synth to trigger method calls on interesting events - bar change, note start etc.
 */
 
/*!
 * @protocol SSEventHandler
 * @abstract generic handler for bar start, beat and end
 */
@protocol SSEventHandler

/*!
 * @method event:
 * @abstract generic handler for bar start, beat and end
 * @param index bar index for bar change handler, beat index for beat handler, and unused for endHandler
 * @param isCountIn is true for count-in bar(s)
 * @param dispatch_time the intended time that this should have been called (the max dispatch time error is set at 10ms)
 */
-(void)event:(int)index countIn:(bool)isCountIn at:(dispatch_time_t)dispatch_time;

@end


/*!
 * @interface SSPDPartNote
 * @abstract describe a note to be played - a parameter to the SSNoteHandler methods
 */
@interface SSPDPartNote : NSObject

/*!
 * @property note
 * @abstract information about the note
 */
@property (readonly) SSPDNote *note;

/*!
 * @property partIndex
 * @abstract the 0-based part index of the part containing the note
 */
@property (readonly) int partIndex;
@end


/*!
 * @protocol SSNoteHandler
 * @abstract event handler for (chord) notes start and note end
 */
@protocol SSNoteHandler

/*!
 * @method startNotes:
 * @abstract called for each note/chord starting
 * @param notes an array of SSPDPartNote, the set of all notes in all parts which should be starting
 * @param dispatch_time the intended time that this should have been called (the max dispatch time error is set at 10ms)
 */
-(void)startNotes:(NSArray<SSPDPartNote*> *)notes at:(dispatch_time_t)dispatch_time;

/*!
 * @method endNote:
 * @abstract called for each note ending
 * @param note the note which is ending
 * @param dispatch_time the intended time that this should have been called (the max dispatch time error is set at 10ms)
 */
-(void)endNote:(SSPDPartNote*)note at:(dispatch_time_t)dispatch_time;

@end
