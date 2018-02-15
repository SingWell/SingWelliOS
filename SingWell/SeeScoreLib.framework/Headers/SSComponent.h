//
//  SSComponent.h
//  SeeScoreLib
//
//  Copyright (c) 2016 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#include "sscore.h"
#include "sscore_contents.h"

/*!
 @header SSComponent.h
 @abstract a component in the score
 */

/*!
 @interface SSComponent
 @abstract information about a component returned from hitTest and componentsForItem
 */
@interface SSComponent : NSObject

/*!
 @property type
 @abstract the type of component
 */
@property (readonly) enum sscore_component_type_e type;

/*!
 @property isFragment
 @abstract true if this is a fragment of a curve or angled line (slur, tied, wedge etc)
 */
@property (readonly) bool isFragment;

/*!
 @property isEndPoint
 @abstract true if this is the end point of a multiple element item (slur, tied, wedge etc)
 */
@property (readonly) bool isEndPoint;

/*!
 @property isBezierControlPoint
 @abstract true if this is a bezier inner control point for a slur or tied
 */
@property (readonly) bool isBezierControlPoint;

/*!
 @property partIndex
 @abstract the 0-based index of the part containing this
 */
@property (readonly) int partIndex;

/*!
 @property barIndex
 @abstract the 0-based index of the bar containing this
 */
@property (readonly)  int barIndex;

/*!
 @property staffIndex
 @abstract the 0-based index of the staff containing this (0 is top or only staff)
 */
@property (readonly)  int staffIndex;

/*!
 @property rect
 @abstract the minimum rectangle around this component in the layout
 */
@property (readonly) CGRect rect;

/*!
 @property layout_h
 @abstract the unique identifier for the atomic drawn element in the layout (notehead,stem,accidental,rest etc)
 */
@property (readonly) sscore_layout_handle layout_h;

/*!
 @property item_h
 @abstract the unique identifier for the parent item in the score (note,rest,clef,time signature etc)
 */
@property (readonly) sscore_item_handle item_h;

/*!
 @property inner_h
 @abstract the unique identifier for a direction-type inside a direction or a notation inside a note
 @discussion is sscore_invalid_item_handle for components which aren't part of a direction-type or notation
 */
@property (readonly) sscore_item_handle inner_h;

/*!
 @property controlPoint
 @abstract return control point identifier
 */
@property (readonly) enum sscore_comp_controlpoint_e controlPoint;

/*!
 @property rawcomponent
 @abstract the sscore_component
 */
@property (readonly) sscore_component rawcomponent;

@end
