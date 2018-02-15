//
//  SSSystem.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import <CoreGraphics/CoreGraphics.h>

#include "sscore.h"
#include "sscore_contents.h"
#include "sscore_edit.h"

@class SSScore;
@class SSComponent;
@class SSTargetLocation;
@class SSDirectionType;
@class SSEditItem;
@class SSLyric;
@class SSEditType;

/*!
 @header SSystem.h
 @abstract interface to a SeeScore System (ie a sequence of bars of page width)
 @discussion https://en.wikipedia.org/wiki/Staff_(music) under "Ensemble staves"
 */

/*!
 @struct SSCursorRect
 @abstract information required for drawing a bar cursor returned from getCursorRect
 */
typedef struct
{
	// true if the required bar is in the system
	bool bar_in_system;
	
	// the outline of the bar in the system (if bar_in_system = true)
	CGRect rect;

} SSCursorRect;

/*!
 @struct SSNoteInsertPos
 @abstract information for note insertion point
 */
typedef struct
{
	bool defined;
	CGPoint pos;
	int normalisedTime;
	bool noteheadIsOnLine;
	int numLedgers; // - if below staff, + if above staff
	bool inChord;
} SSNoteInsertPos;

/*!
 @interface SSColouredItem
 @abstract define colouring of an object in drawWithContext: at: magnification: colourRender:
 */
@interface SSColouredItem : NSObject

/*!
 @property item_h
 @abstract unique identifier of the item to colour
 */
@property sscore_item_handle item_h;

/*!
 @property colour
 @abstract the colour to use
 */
@property CGColorRef _Nonnull colour;

/*!
 @property coloured_render
 @abstract use sscore_dopt_colour_render_flags_e to define exactly what part of an item should be coloured
 */
@property unsigned coloured_render;

/*!
 @method initWithItem:
 @abstract initialise SSColouredItem
 @param item_h unique identifier of the item to colour
 @param colour the colour to use
 @param coloured_render use sscore_dopt_colour_render_flags_e to define exactly what part of an item should be coloured
 */
-(instancetype _Nonnull)initWithItem:(sscore_item_handle)item_h colour:(CGColorRef _Nonnull)colour render:(unsigned)coloured_render;

@end


/*!
 @interface SSColourRender
 @abstract define colouring of objects in drawWithContext: at: magnification: colourRender:
 */
@interface SSColourRender : NSObject

/*!
 @property flags
 @abstract normally 0 (sscore_dopt_flags_e)
 */
@property unsigned flags;
 
/*!
 @property colouredItems
 @abstract array of SSColouredItem
 */
@property NSArray<SSColouredItem*> * _Nonnull colouredItems;

/*!
 @method initWithItems:
 @abstract initialise SSColourRender
 @param items array of SSColouredItem
 */
-(instancetype _Nonnull )initWithItems:(NSArray<SSColouredItem*>* _Nonnull )items;

/*!
 @method initWithFlags:
 @abstract unused at present
 */
-(instancetype _Nonnull )initWithFlags:(unsigned)flags items:(NSArray<SSColouredItem*>* _Nonnull )items;

@end


/*!
 @interface SSStaff
 @abstract info for a single staff
 */
@interface SSStaff : NSObject

/*!
 @property staffRect
 @abstract rectangle enclosing a single staff in a system
 */
@property (readonly) CGRect staffRect;

/*!
 @property numLines
 @abstract the number of lines in the staff
 */
@property (readonly) int numLines;
@end


/*!
 @interface SSStaffLayout
 @abstract info about staves in a part returned from staffLayout
 */
@interface SSStaffLayout : NSObject

/*!
 @property partIndex
 @abstract the part index
 */
@property (readonly) int partIndex;

/*!
 @property tenthSize
 @abstract one tenth of the staff line separation in CG units
 */
@property (readonly) CGFloat tenthSize;

/*!
 @property staves
 @abstract the array of staff info for this part (expect normally 1 or 2 in array)
 */
@property (readonly) NSArray<SSStaff*> * _Nonnull staves;
@end

/*!
 @interface SSBarline
 @abstract info about a barline
 */
@interface SSBarline : NSObject

/*!
 @property barIndex
 @abstract the bar index
 */
@property (readonly) int barIndex;

/*!
 @property loc
 @abstract right/left barline
 */
@property (readonly) enum sscore_barlineloc_e loc;

/*!
 @property rect
 @abstract a rectangle completely enclosing the barline and any repeat dots (ie wider for double barlines)
 */
@property (readonly) CGRect rect;
@end

/*!
 @interface SSBarLayout
 @abstract info about barlines in a system/part returned from barLayout:
 */
@interface SSBarLayout : NSObject

/*!
 @property partIndex
 @abstract the part index
 */
@property (readonly) int partIndex;

/*!
 @property barlines
 @abstract array of barline info for the system/part
 */
@property (readonly) NSArray<SSBarline*> *  _Nonnull barlines;
@end

@interface SSStaffLocation : NSObject

/*!
 @property partIndex
 @abstract the part index (0 is top)
 */
@property (readonly) int partIndex;

/*!
 @property barIndex
 @abstract the bar index (0 is first bar)
 */
@property (readonly) int barIndex;

/*!
 @property staffIndex
 @abstract the staff index (0 is top staff or only staff)
 */
@property (readonly) int staffIndex;

/*!
 @property location
 @abstract location relative to the staff
 */
@property (readonly) enum sscore_system_stafflocation_e location;

/*!
 @property xlocation
 @abstract x location relative to the system
 */
@property (readonly) enum sscore_system_xlocation_e xlocation;

/*!
 @property lineSpaceIndex
 @abstract 0 is bottom line of staff, 1 is bottom space, 8 is top line etc
 */
@property (readonly) int lineSpaceIndex;

@end

/*!
 @interface SSSystem
 @abstract interface to a SeeScore System
 @discussion A System is a range of bars able to draw itself in a CGContextRef, and is a product of calling SScore layoutXXX:
 <p>
 drawWithContext draws the system into a CGContextRef, the call with colourRender argument allowing item colouring (and requiring an additional licence)
 <p>
 partIndexForYPos, barIndexForXPos can be used to locate the bar and part under the cursor/finger
 <p>
 hitTest is used to find the exact layout components (eg notehead, stem, beam) at a particular location (requiring a contents licence)
 <p>
 componentsForItem is used to find all the layout components of a particular score item (requiring a contents licence)
 */
@interface SSSystem : NSObject

/*!
 @property index
 @abstract the index of this system from the top of the score. Index 0 is the topmost.
 */
@property (nonatomic,readonly) int index;

/*!
 @property barRange
 @abstract the start bar index and number of bars for this system.
 */
@property (nonatomic,readonly) sscore_barrange barRange;

/*!
 @property defaultSpacing
 @abstract a default value for vertical system spacing
 */
@property (nonatomic,readonly) CGFloat defaultSpacing;

/*!
 @property bounds
 @abstract the bounding box of this system.
 */
@property (nonatomic,readonly) CGSize bounds;

/*!
 @property magnification
 @abstract the magnification this system - a value of 1.0 approximates to a standard 6mm staff height as in a printed score
 */
@property (nonatomic,readonly) float magnification;

/*!
 @property isTruncatedWidth
 @abstract true if the entire system width cannot be drawn at this magnification
 */
@property (nonatomic, readonly) bool isTruncatedWidth;

/*!
 @property rawsystem
 @abstract access the underlying C type
 */
@property (nonatomic,readonly) sscore_system * _Nonnull rawsystem;

/*!
 @method includesBar:
 @abstract does this system include the bar?
 @return true if this system includes the bar with given index
 */
-(bool)includesBar:(int)barIndex;

/*!
 @method includesBarRange:
 @abstract does this system include the bar range?
 @return true if this system includes any bars in barrange
 */
-(bool)includesBarRange:(const sscore_barrange* _Nonnull )barrange;

/*!
 @method drawWithContext:at:magnification:
 @abstract draw this system at the given point.
 @param ctx the CGContextRef to draw into
 @param tl the coordinate at which to place the top left of the system
 @param magnification the scale to draw at. NB This is normally 1, except during active zooming.
 The overall magnification is set in sscore_layout
 */
-(void)drawWithContext:(CGContextRef _Nonnull )ctx
					at:(CGPoint)tl
		 magnification:(float)magnification;

/*!
 @method drawWithContext:at:magnification:colourRender:
 @abstract draw this system at the given point allowing optional colouring of particular items/components in the layout.
 @param ctx the CGContextRef to draw into
 @param tl the coordinate at which to place the top left of the system
 @param magnification the scale to draw at. NB This is normally 1, except during active zooming.
 The overall magnification is set in sscore_layout
 @param colourRender each SSRenderItem object in the array defines special colouring of a particular score item
 */
-(enum sscore_error)drawWithContext:(CGContextRef _Nonnull )ctx
								 at:(CGPoint)tl
					  magnification:(float)magnification
					   colourRender:(SSColourRender* _Nonnull )colourRender;

/*!
 @method printTo:at:magnification:
 @abstract draw this system at the given point with optimisation for printing (ie without special pixel alignment).
 @param ctx the CGContextRef to draw into
 @param tl the coordinate at which to place the top left of the system
 @param magnification (normally 1.0) the scale to draw at.
 */
-(void)printTo:(CGContextRef _Nonnull )ctx
			at:(CGPoint)tl
 magnification:(float)magnification;

/*!
 @method cursorRectForBar:context:
 @abstract get the cursor rectangle for a particular system and bar
 @param barIndex the index of the bar in the system
 @param ctx a graphics context only for text measurement eg a bitmap context
 @return the bar rectangle which can be used for a cursor
 */
-(SSCursorRect)cursorRectForBar:(int)barIndex context:(CGContextRef _Nonnull )ctx;

/*!
 @method partIndexForYPos:
 @abstract get the part index of the part enclosing the given y coordinate in this system
 @param ypos the y coord
 @return the 0-based part index
 */
-(int)partIndexForYPos:(CGFloat)ypos;

/*!
 @method staffIndexForYPos:
 @abstract get the index of the staff within the part closest to the given y coordinate in this system
 @param ypos the y coord
 @return the 0-based staff index - 0 for a single-staff part
 */
-(int)staffIndexForYPos:(CGFloat)ypos;

/*!
 @method barIndexForXPos:
 @abstract get the bar index of the bar enclosing the given x coordinate in this system
 @param xpos the x coord
 @return the 0-based bar index
 */
-(int)barIndexForXPos:(CGFloat) xpos;

/*!
 @method centreStaffY:staff:
 @abstract get the y coord of the centre of the staff in the given part,staff index
 @param partIndex the 0-based index of the part, 0 is the top part
 @param staffIndex the 0-based index of the staff, 0 is the top or only staff
 @return the y coord of the centre of the staff (ie the centre line for a 5-line staff)
 */
-(CGFloat)centreStaffY:(int)partIndex staff:(int)staffIndex;

/*!
 @method staffLocationForYPos:
 @deprecated use staffLocationForPos: which returns more information
 @abstract from the ypos return above or below according to the ypos relative to the closest staff
 @param ypos the y coord
 @return  above/below relative to the staff
 */
-(enum sscore_system_stafflocation_e)staffLocationForYPos:(CGFloat)ypos __attribute__ ((deprecated));

/*!
 @method staffLocationForPos:maxLedgers:
 @abstract return information about where a point is relative to the nearest staff
 @param pos the coord
 @param maxLedgers determines how far above or below the staff is considered as belonging to that staff
 @return SSStaffLocation
 */
-(SSStaffLocation* _Nonnull )staffLocationForPos:(CGPoint)pos maxLedgers:(int)maxLedgers;

/*!
 @method staffLineSpaceIndexForYPos:
 @abstract from the ypos return the line/space index from the bottom line of the nearest staff
 @discussion bottom line of staff = 0; bottom space = 1; 1st ledger below = -2; top line = 8 ... lines are even numbers, spaces are odd numbers
 @param ypos the y coord
 @return line/space index
 */
-(int)staffLineSpaceIndexForYPos:(CGFloat)ypos;

/*!
 @method numLyricLinesForPart:staffIndex:
 @abstract the number of lyric lines
 @param partIndex the part index [0..]
 @param staffIndex the staff index [0..1]
 @return the number lines of of lyrics
 */
-(int)numLyricLinesForPart:(int)partIndex staffIndex:(int)staffIndex;

/*!
 @method lyricBaselineForPart:staffIndex:lyricIndex:
 @abstract the distance from the top to the baseline of the given line of lyrics
 @param partIndex the part index [0..]
 @param staffIndex the staff index [0..1]
 @param lyricIndex the index of the line of lyrics from the top [0..]
 @return the distance from the top to the baseline of the given line of lyrics
 */
-(CGFloat)lyricBaselineForPart:(int)partIndex staffIndex:(int)staffIndex lyricIndex:(int)lyricIndex;

/*!
 @method componentForLyric:
 @abstract get the component for a given lyric
 @param lyric the lyric
 @return the the component for the lyric
 */
-(SSComponent* _Nullable )componentForLyric:(SSLyric* _Nonnull )lyric;

/*!
 @method hitTest:
 @abstract get an array of components which intersect a given a point in this system
 @discussion a contents licence is required
 @param p the point
 @return array of intersecting SSComponent - empty if unlicensed
 */
-(NSArray<SSComponent*> * _Nonnull)hitTest:(CGPoint)p;

/*!
 @method closeFeatures:
 @abstract get an array of components within a certain distance of a given a point in this system
 @discussion results are sorted in order of increasing distance. A contents licence is required
 @param p the point
 @param distance the distance
 @return array of intersecting SSComponent - empty if unlicensed
 */
-(NSArray<SSComponent*> * _Nonnull )closeFeatures:(CGPoint)p distance:(CGFloat)distance;

/*!
 @method featuresWithin:
 @abstract get an array of components within a rectangle in this system
 @discussion A contents licence is required
 @param r the rectangle
 @return array of SSComponent contained in rect - empty if unlicensed
 */
-(NSArray<SSComponent*> * _Nonnull )featuresWithin:(CGRect)r;

/*!
 @method componentsForItem:
 @abstract get an array of layout components which belong to a particular score item in this system
 @discussion a contents licence is required
 @param item_h the unique identifier for an item (eg note) in the score
 @return array of SSComponent - empty if unlicensed
 */
-(NSArray<SSComponent*>* _Nonnull )componentsForItem:(sscore_item_handle)item_h;

/*************
 IMPORTANT WARNING!
 The editing methods below are under current development so you should expect API changes
 *************/

/*!
 @method componentIsSelectable:
 @warning EDITING API IN DEVELOPMENT
 @abstract true if the layout component can be selected (eg for delete, drag)
 @param comp the layout component
 @return true if the component can be selected
 */
-(bool)componentIsSelectable:(SSComponent * _Nonnull )comp;

/*!
 @method componentIsEditable:
 @warning EDITING API IN DEVELOPMENT
 @abstract true if the layout component can be edited eg text modified
 @param comp the layout component
 @return true if the component can be edited
 */
-(bool)componentIsEditable:(SSComponent * _Nonnull )comp;

/*!
 @method componentIsDeleteable:
 @warning EDITING API IN DEVELOPMENT
 @abstract true if the layout component can be deleted (modifying or removing the item which 'owns' the component)
 @param comp the layout component
 @return true if the component can be deleted
 */
-(bool)componentIsDeleteable:(SSComponent * _Nonnull )comp;

/*!
 @method componentIsDraggable:
 @warning EDITING API IN DEVELOPMENT
 @abstract true if component can be dragged (eg slur control point or wedge end point) to modify the item which 'owns' the component
 @param comp the layout component
 @return true if the component can be dragged
 */
-(bool)componentIsDraggable:(SSComponent * _Nonnull )comp;

/*!
 @method boundsForItem:
 @warning EDITING API IN DEVELOPMENT
 @abstract get a bounding box which encloses all layout components for a score item in this system
 @discussion a contents licence is required
 @param item_h item handle
 @return the bounds of (all components of) the item - empty if not licensed
 */
-(CGRect)boundsForItem:(sscore_item_handle)item_h;

/*!
 @method nearestNoteInsertPos:type:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the nearest valid point for inserting a new note or rest of the given type into the system
 @param target the target
 @param itemType the type of item (note or rest)
 @return information about the nearest insert position
 */
-(SSNoteInsertPos)nearestNoteInsertPos:(SSTargetLocation* _Nonnull)target type:(SSEditType* _Nonnull )itemType;

/*!
 @method nearestInsertTargetFor:at:max:
 @warning EDITING API IN DEVELOPMENT
 @abstract return the nearest valid target location to insert an item of given type in the score
 @param itemType the type of item to insert
 @param pos the location in the system near to which we would like to insert the item.
 @param max_distance the maximum distance to accept a target
 @return the nearest valid target location at which the itemType can be inserted in the score. Return nil if not near a valid point
 */
-(SSTargetLocation* _Nullable)nearestInsertTargetFor:(SSEditType* _Nonnull)itemType at:(CGPoint)pos max:(CGFloat)max_distance;

/*!
 @method nearestReinsertTargetFor:at:
 @warning EDITING API IN DEVELOPMENT
 @abstract return the nearest valid target location to reinsert an existing item in the score
 @param item the item to reinsert (drag-drop)
 @param pos the location in the system near to which we would like to reinsert the item.
 @return the nearest valid target location at which the item can be reinserted in the score. Return nil if not near a valid point
 */
-(SSTargetLocation* _Nullable)nearestReinsertTargetFor:(SSEditItem*_Nonnull)item at:(CGPoint)pos;

/*!
 @method targetForNoteComponent:type:
 @warning EDITING API IN DEVELOPMENT
 @abstract return the target location for a given component of a note
 @param noteComponent the component from eg nearestNoteComponentAt:
 @param itemType the type of item
 @return the target location for a note component. Return nil if noteComponent is not a notehead, stem  or rest
 */
-(SSTargetLocation* _Nullable)targetForNoteComponent:(SSComponent * _Nonnull)noteComponent type:(SSEditType* _Nonnull)itemType;

/*!
 @method targetForComponent:
 @warning EDITING API IN DEVELOPMENT
 @abstract return the target location for a given component
 @param component the component
 @return the target location for the component. Return nil if not valid component for target
 */
-(SSTargetLocation* _Nullable)targetForComponent:(SSComponent *_Nonnull)component;

/*!
 @method insertPosForTarget:lr:
 @warning EDITING API IN DEVELOPMENT
 @abstract calculate and return a suitable approximation to the insertion position for this target
 to show in the UI while dragging
 @param target the target
 @param itemType the type of the item
 @param lr the horizontal location relative to the target note
 @return the insertion point in the system
 */
-(CGPoint)insertPosForTarget:(SSTargetLocation* _Nonnull)target type:(SSEditType* _Nonnull)itemType lr:(enum sscore_edit_leftRightLocation)lr;

/*!
 @method bezierOffset:forSystemPos:
 @warning EDITING API IN DEVELOPMENT
 @abstract calculate and return an offset value to use for a given system coordinate to pass to SSScore.tryOffsetItem
used for drag-drop of slur or tied bezier control points
 @param item the item
 @param pos the coordinate in the system
 @return the offset for the bezier to pass to SSScore.tryOffsetItem
 */
-(CGPoint)bezierOffset:(SSEditItem *_Nonnull)item forSystemPos:(CGPoint)pos;

/*!
 @method isNearNotehead
 @warning EDITING API IN DEVELOPMENT
 @abstract is this target near the notehead (less than 2 spaces away) in y
 @param target the target
 @return true if this target is within 2 staffline spaces of the nearest notehead
 */
-(bool)isNearNotehead:(SSTargetLocation*_Nonnull)target;

/*!
 @method tiedRect
 @warning EDITING API IN DEVELOPMENT
 @abstract get the bounding box of the tie which can be added to the right of the given notehead so we can draw it in temporarily
 @param target the target
 @return rectangle in cg units
 */
-(CGRect)tiedRect:(SSTargetLocation*_Nonnull)target;

/*!
 @method drawDragItem:withContext:topleft:pos:
 @warning EDITING API IN DEVELOPMENT
 @abstract redraw an existing item in the system when dragged (eg update slur when control point dragged)
 @param item the dragged item
 @param ctx the graphics context
 @param tl the top left coord of the system
 @param pos the drag position
 */
-(void)drawDragItem:(SSEditItem * _Nonnull)item target:(SSTargetLocation* _Nonnull)target withContext:(CGContextRef _Nonnull)ctx topleft:(CGPoint)tl pos:(CGPoint)pos;

/*!
 @method nearestNoteComponentAt:maxDistance:
 @warning EDITING API IN DEVELOPMENT
 @abstract find the closest layout component within maxDistance of pos that is part of a note (notehead,stem,dot,accidental etc)
 @param pos the location
 @param maxDist the maximum (euclidean) distance to accept items
 @return the closest note component
 */
-(SSComponent* _Nullable)nearestNoteComponentAt:(CGPoint)pos maxDistance:(CGFloat)maxDist;

/*!
 @method nearestLyricComponentAt:
 @warning EDITING API IN DEVELOPMENT
 @abstract find the closest layout component within maxDistance of pos that is a lyric
 @param pos the location
 @param maxDist the maximum (euclidean) distance to accept items
 @return the closest lyric component
 */
-(SSComponent* _Nullable)nearestLyricComponentAt:(CGPoint)pos maxDistance:(CGFloat)maxDist;

/*!
 @method nearestDirectionComponentAt: maxDistance:
 @warning EDITING API IN DEVELOPMENT
 @abstract find the closest layout component within maxDistance of pos that is part of a direction (words etc)
 @param pos the location
 @param type the type of direction to find
 @param maxDist the maximum (euclidean) distance to accept items
 @return the closest note component
 */
-(SSComponent* _Nullable)nearestDirectionComponentAt:(CGPoint)pos type:(enum sscore_direction_type)type maxDistance:(CGFloat)maxDist;

/*!
 @method directionForComponent:
 @warning EDITING API IN DEVELOPMENT
 @abstract find the direction-type from a layout component created from it
 @param directionComponent the component
 @return the direction-type
 */
-(SSDirectionType* _Nullable)directionTypeForComponent:(SSComponent* _Nonnull)directionComponent;

/*!
 @method directionsNearComponent:
 @warning EDITING API IN DEVELOPMENT
 @abstract find the directions around the point defined by the (note or direction) component
 @param comp a component of a direction or note
 @return array of SSDirectionType* . Those of type sscore_dir_words can be cast to SSDirectionTypeWords, and then the text
 is readable and writeable
 */
-(NSArray<SSDirectionType*>* _Nonnull)directionsNearComponent:(SSComponent* _Nonnull)comp;

/*!
 @method partLayout:
 @abstract get staff measurement for the part in this system
 @param partIndex the 0-based part index
 @return staff measurements
 */
-(SSStaffLayout*_Nonnull)staffLayout:(int)partIndex;

/*!
 @method barLayout:
 @abstract get barline measurements for the part in this system
 @param partIndex the 0-based part index
 @return barline dimensions
 */
-(SSBarLayout*_Nonnull)barLayout:(int)partIndex;

/*!
 @method pointsToFontSize:
 @abstract get the pointsize of a UIFont (of type "Georgia") which will look exactly like a SeeScore direction with this fontsize
 @param points the font size defined in the XML file
 @return the fontsize to use in the call [UIFont fontWithName:at"Georgia" size:fontsize];
 */
-(CGFloat)pointsToFontSize:(CGFloat)points;

/*!
 @method selectItem:part:bar:foreground:background:
 @warning EDITING API IN DEVELOPMENT
 @abstract select the item in the system/part/bar and colour it
 @param item_h the item handle
 @param partIndex the part index
 @param barIndex the bar index
 @param fgCol foreground colour for highlight
 @param bgCol background colour for highlight
 */
-(void)selectItem:(sscore_item_handle)item_h part:(int)partIndex bar:(int)barIndex
	   foreground:(CGColorRef _Nonnull)fgCol background:(CGColorRef _Nonnull)bgCol;

/*!
 @method deselectItem:
 @warning EDITING API IN DEVELOPMENT
 @abstract deselect the item previously selected item
 @param item_h the item handle
 */
-(void)deselectItem:(sscore_item_handle)item_h;

/*!
 @method deselectAll:
 @warning EDITING API IN DEVELOPMENT
 @abstract deselect all selected items in this system
 */
-(void)deselectAll;

/*!
 @method updateLayout:newState:
 @warning EDITING API IN DEVELOPMENT
 @abstract update the layout to show the state in the sscore_state_container (called by state change handler)
 @param ctx the graphics context
 @param newstate the new state from the state change handler
 */
-(void)updateLayout:(CGContextRef _Nonnull)ctx newState:(const sscore_state_container* _Nonnull)newstate;

/*!
 @method itemForComponent:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the editable item for a SSComponent
 @param component the component
 @return item
 */
-(SSEditItem* _Nonnull)itemForComponent:(SSComponent* _Nonnull)component;

/*!
 @method componentsForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the layout components for a given SSDirectionType (corresponding to 'direction-type' element)
 @param dirType the direction-type
 @return array of SSComponent
 */
-(NSArray<SSComponent*>* _Nonnull)componentsForDirection:(SSDirectionType* _Nonnull)dirType;

/*!
 @method itemForDirectionType:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the editable item for a SSDirectionType
 @param directionType the direction-type
 @return item
 */
-(SSEditItem* _Nonnull)itemForDirectionType:(SSDirectionType* _Nonnull)directionType;

/*!
 @method nearestValidDragPoint:item:
 @abstract get the nearest valid drag point
 @warning EDITING API IN DEVELOPMENT
 @param p the point
 @param item the item
 @return the nearest valid drag point to p
 */
-(CGPoint)nearestValidDragPoint:(CGPoint)p item:(SSEditItem* _Nonnull)item;

// internal use only
@property sscore_libkeytype * _Nonnull key;

// internal use only
-(instancetype _Nonnull )initWithSystem:(sscore_system* _Nonnull)sy score:(SSScore* _Nonnull)sc;

@end
