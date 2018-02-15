//
//  SSEditItem.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#include "sscore_edit.h"

/*!
 @header SSEditItem.h
 @abstract info about an object in the score which can be edited
 */

/*!
 @interface SSEditItem
 @abstract wrapper for info about an object in the score which can be edited
 */
@interface SSEditItem : NSObject

/*!
 @property type
 @abstract the sscore_edit_type for the item
 */
@property (readonly) sscore_edit_type type;

/*!
 @property rawitem
 @abstract the sscore_edit_item
 */
@property (readonly) const sscore_edit_item *rawitem;

@property (readonly) bool isBezierControl;

@end
