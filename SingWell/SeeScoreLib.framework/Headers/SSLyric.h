//
//  SSLyric.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

/*!
 @header SSLyric.h
 @abstract a lyric text item in the score attached to a note
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#include "sscore_contents.h"

/*!
 @interface SSLyric
 @abstract a lyric text item in the score attached to a note
 */
@interface SSLyric : NSObject

/*!
 @property partIndex
 @abstract the 0-based index of the part containing this lyric
 */
@property (readonly) int partIndex;

/*!
 @property barIndex
 @abstract the 0-based index of the bar containing this lyric
 */
@property (readonly) int barIndex;

/*!
 @property staffIndex
 @abstract the 0-based index of the staff containing this lyric
 */
@property (readonly) int staffIndex;

/*!
 @property lyricNumber
 @abstract the number of the lyric line
 */
@property (readonly) int lyricNumber;

/*!
 @property note_h
 @abstract the associated note handle
 */
@property (readonly) sscore_item_handle note_h;

/*!
 @property text
 @abstract the lyric text
 */
@property (readonly) NSString *text;

/*!
 @property textRepresentation
 @abstract the lyric text with trailing hyphen "-" to indicate syllabic link to next
 */
@property (readonly) NSString *textRepresentation;

/*!
 @property fontSize
 @abstract the font size
 */
@property (readonly) CGFloat fontSize;

/*!
 @property bold
 @abstract true for bold text
 */
@property (readonly) bool bold;

/*!
 @property italic
 @abstract true for italic text
 */
@property (readonly) bool italic;

/*!
 @property syllabic
 @abstract the syllabic property indicating dashes to previous or next lyric
 */
@property (readonly) enum sscore_lyric_syllabic syllabic;

/*!
 @property rawlyric
 @abstract the raw lyric
 */
@property (readonly) const sscore_con_lyric *rawlyric;

//private
-(instancetype)initWithLyric:(sscore_con_lyric*)lyr;
@end
