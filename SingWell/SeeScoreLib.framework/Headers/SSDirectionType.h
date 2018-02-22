//
//  SSDirectionType.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#include "sscore.h"
#include "sscore_contents.h"

/*!
 @header SSDirectionType.h
 @abstract wrapper for a MusicXML direction-type element
 */

@class SSComponent;

/*!
 @interface SSDirectionType
 @abstract encapsulates a direction-type element
 */
@interface SSDirectionType : NSObject

/*!
 @property type
 @abstract the type of direction
 */
@property (readonly) enum sscore_direction_type type;

/*
 @property staffIndex moved to SSScore staffIndexForDirection:

 @property directive moved to SSScore directiveForDirection:

 @property placement moved to SSScore placementForDirection:

 @property components moved to SSSystem componentsForDirection:
 */

/*!
 @property dirType_h
 @abstract the unique identifier for a direction-type inside a direction
 */
@property (readonly) sscore_directiontype_handle dirType_h;

/*!
 @property rawdirectiontype
 @abstract the sscore_con_directiontype
 */
@property (readonly) const sscore_con_directiontype *rawdirectiontype;

@end


/*!
 @interface SSDirectionTypeWords
 @abstract encapsulates a direction-type words element
 */
@interface SSDirectionTypeWords : SSDirectionType

/*
 @property words (read) moved to SSScore wordsForDirection
 
 @property bold moved to moved to SSScore boldForDirection
 
 @property italic moved to moved to SSScore italicForDirection
 
 @property pointSize (read) moved to moved to SSScore pointSizeForDirection
 
 @method setBold:italic: and writeable properties moved to SSScore setDirection:words:pointSize:bold:italic:
*/

@end
