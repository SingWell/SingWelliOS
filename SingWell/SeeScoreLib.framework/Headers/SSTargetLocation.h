//
//  SSTargetLocation.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import <CoreGraphics/CoreGraphics.h>
#include "sscore_edit.h"

@class SSSystem;

/*!
 @header SSTargetLocation.h
 @abstract a logical insertion location in the score
 */

/*!
 @interface SSTargetLocation
 @abstract a logical insertion location in the score defined by part, bar, closest notehead and type of item to insert
 */
@interface SSTargetLocation : NSObject

/*!
 @method initWithTarget:
 @abstract initializer
 @param target the target
 */
-(instancetype)initWithTarget:(const sscore_edit_targetLocation*)target;

/*!
 @property partIndex
 @abstract the part index of the target
 */
@property (readonly) int partIndex;

/*!
 @property barIndex
 @abstract the bar index of the target
 */
@property (readonly) int barIndex;

/*!
 @property staffIndex
 @abstract the staff index (0 is top or only staff in part, 1 is bottom) of the target
 */
@property (readonly) int staffIndex;

/*!
 @property nearestNoteHandle
 @abstract the unique item handle of the nearest note to the target
 */
@property (readonly) sscore_item_handle nearestNoteHandle;

/*!
 @property nearestNoteheadStaffLineSpaceIndex
 @abstract index of staff line/space for nearest notehead. Bottom line = 0, bottom space = 1, bottom ledger = -2 etc
 */
@property (readonly) int nearestNoteheadStaffLineSpaceIndex;

/*!
 @property targetType
 @abstract the type of target
 */
@property (readonly) enum sscore_edit_targetType targetType;

/*!
 @property staffLocation
 @abstract above or below the staff?
 */
@property (readonly) enum sscore_system_stafflocation_e staffLocation;

/*!
 @property staffLineSpaceIndex
 @abstract index of staff line/space. Bottom line = 0, bottom space = 1, bottom ledger = -2 etc
 */
@property (readonly) int staffLineSpaceIndex;

/*!
 @property rawtarget
 @abstract the low level C-API object
 */
@property (readonly) const sscore_edit_targetLocation *rawtarget;

@end
