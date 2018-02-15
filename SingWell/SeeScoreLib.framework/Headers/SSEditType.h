//
//  SSEditType.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SSEditType_h
#define SSEditType_h

/*!
 @header SSEditType.h
 @abstract wrapper for sscore_edit_type
 */

#import <Foundation/Foundation.h>

#include "sscore_edit.h"

/*!
 @interface SSEditType
 @abstract the type of an item in a score
 */
@interface SSEditType : NSObject

/*!
 @property isValid
 @abstract false if this object is invalid/undefined
 */
@property (readonly) bool isValid;

/*!
 @property isMultiple
 @abstract true if this is a multiple element type eg slur, tied, wedge, pedal etc
 */
@property (readonly) bool isMultiple;

/*!
 @property baseType
 @abstract the base type
 */
@property (readonly) enum sscore_edit_baseType baseType;

/*!
 @property subType
 @abstract the sub type dependent on the base type
 */
@property (readonly) unsigned subType;

/*!
 @property intParam0
 @abstract an integer parameter dependent on the base type
 */
@property (readonly) int intParam0;

/*!
 @property intParam1
 @abstract an integer parameter dependent on the base type
 */
@property (readonly) int intParam1;

/*!
 @property intParam2
 @abstract an integer parameter dependent on the base type
 */
@property (readonly) int intParam2;

/*!
 @property stringParam
 @abstract a string parameter dependent on the base type
 */
@property (readonly) NSString *stringParam;

/*!
 @property isLeftRepeatBarline
 @abstract true if this is a begin repeat barline
 */
@property (readonly) bool isLeftRepeatBarline;

/*!
 @property isRightRepeatBarline
 @abstract true if this is an end repeat barline
 */
@property (readonly) bool isRightRepeatBarline;

/*!
 @property rawtype
 @abstract the sscore_edit_type
 */
@property (readonly) const sscore_edit_type *rawtype;

//private
-(instancetype)initWith:(sscore_edit_type)tp;

@end

#endif /* SSEditType_h */
