//
//  SSDisplayedItem.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#include "sscore.h"
#include "sscore_contents.h"

/*!
 @header SSDisplayedItem.h
 @abstract information about a displayed item (note,rest,clef etc) in the score
 */

/*!
 @interface SSDisplayedItem
 @abstract information about a displayed item (note,rest,clef etc) in the score
 */
@interface SSDisplayedItem : NSObject

/*!
 @property type
 @abstract type the type of the item
 */
@property enum sscore_item_type_e type;

/*!
 @property staff
 @abstract the index of the staff within the part (0 or 1) if there are 2 staves
 */
@property int staff;

/*!
 @property item_h
 @abstract the unique handle for the item
 */
@property sscore_item_handle item_h;

@end


/*!
 @interface SSTimedItem
 @abstract timing information about a displayed item (note,rest,clef etc) in the score
 */
@interface SSTimedItem : SSDisplayedItem

/*!
 @property start
 @abstract the start time of the item within its bar in divisions
 */
@property int start;

/*!
 @property duration
 @abstract the duration time of a note or rest in divisions (0 for all other item types)
 */
@property int duration;

@end


/*!
 @interface SSNoteItem
 @abstract detailed information about a displayed note in the score
 */
@interface SSNoteItem : SSTimedItem

/*!
 @property midipitch
 @abstract The MIDI pitch of this note ie 60 = C4; 0 => rest
 */
@property int midipitch;

/*!
 @property noteType
 @abstract The value of the note 2 = minim, 4 = crotchet etc.
 */
@property int noteType;

/*!
 @property numdots
 @abstract number of dots on the note. 1 if dotted, 2 if double-dotted
 */
@property int numdots;

/*!
 @property accidentals
 @abstract any accidentals defined ie +1 = 1 sharp, -1 = 1 flat etc.
 */
@property int accidentals;

/*!
 @property ischord
 @abstract True if this is a chord note (not set for first note of chord)
 */
@property bool ischord;

/*!
 @property notations
 @abstract array of sscore_notations_type_e as NSNumber
 */
@property NSArray<NSNumber*> *notations;

/*!
 @property tied
 @abstract If this is a tied note this contains information about the tie
 */
@property sscore_tied tied;

/*!
 @property grace
 @abstract true if this is a grace note
 */
@property bool grace;

/*!
 @property beamCount
 @abstract the number of beams on this note
 */
@property int beamCount;

@end


/*!
 @interface SSClefItem
 @abstract detailed information about a clef
 */
@interface SSClefItem : SSTimedItem

/*!
 @property clef
 @abstract the type of the clef
 */
@property enum sscore_clef_type_e clef;
@end


/*!
 @interface SSTimeSigItem
 @abstract detailed information about a (conventional) time signature
 */
@interface SSTimeSigItem : SSTimedItem

/*!
 @property timeSigType
 @abstract symbol (eg common, cut) or numbers?
 */
@property enum sscore_timesig_type timeSigType;

/*!
 @property beats
 @abstract the number at the top of the time signature
 */
@property int beats;

/*!
 @property beatType
 @abstract the number at the bottom
 */
@property int beatType;
@end


/*!
 @interface SSKeySigItem
 @abstract detailed information about a key signature
 */
@interface SSKeySigItem : SSTimedItem

/*!
 @property fifths
 @abstract if -ve is number of flats, +ve is number of sharps, 0 is no flats or sharps
 */
@property int fifths;
@end


/*!
 @interface SSDirectionItem
 @abstract detailed information about a direction
 */
@interface SSDirectionItem : SSTimedItem

/*!
 @property directions
 @abstract array of int = enum sscore_direction_type
 */
@property NSArray<NSNumber*> *directions;

/*!
 @property hassound
 @abstract true if info in sound
 */
@property bool hassound;

/*!
 @property sound
 @abstract defined if hassound = true
 */
@property sscore_sound sound;
@end
