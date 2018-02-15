//
//  SSScore.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

/*!
 @header	SSScore.h
 @abstract	SSScore is the main interface to SeeScore.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SSTargetLocation.h"
#import "SSDirectionType.h"
#import "SSEditType.h"

#include "sscore.h"
#include "sscore_contents.h"
#include "sscore_playdata.h"
#include "sscore_edit.h"
#include "sscore_contents.h"

@class SSSystem;
@class SSGraphics;
@class SSComponent;
@class SSTimedItem;
@class SSDirectionType;
@class SSDisplayedItem;
@class SSEditItem;
@class SSLyric;

/*!
 @protocol ScoreChangeHandler
 @abstract interface for a handler which is automatically invoked when a change is made to the score
 */
@protocol ScoreChangeHandler
/*!
 @method change
 @abstract automatic notification of change to ScoreChangeHandler-derived class registered with addChangeHandler
 there are methods to find generic differences between prevstate and newstate so the ui update can be optimised
 eg if only a single bar is changed then you may be able to suppress updates to systems which don't contain the bar (but 
 if the bar becomes wider then you may need to relayout all systems after the changed bar
 @param prevstate the previous state of the score before the change
 @param newstate the new state of the score after the change
 @param reason see enum sscore_state_changeReason
 */
-(void)change:(sscore_state_container *)prevstate newstate:(sscore_state_container *)newstate reason:(/*enum sscore_state_changeReason*/int)reason;
@end

/*!
 @interface SSLoadOptions
 @abstract options for loading the XML file is a parameter to scoreWithXMLData and scoreWithXMLFile
 */
@interface SSLoadOptions : NSObject

/*!
 @property key
 @abstract set to point to the key which allows access to locked features
 */
@property const sscore_libkeytype *key;

/*!
 @property compressed
 @abstract set to load compressed .mxl data (redundant when loading a file as it detects the .mxl file extension)
 */
@property bool compressed;

/*!
 @property checkxml
 @abstract set to return information about non-fatal faults (warnings) in the XML file in SSLoadError.warnings
 */
@property bool checkxml;

/*!
 @property suppressAutoBeaming
 @abstract set to ensure it does not automatically generate beam elements, which it only does when there are no beam elements in the score
 */
@property bool suppressAutoBeaming;

/*!
 @method initWithKey
 */
-(instancetype)initWithKey:(const sscore_libkeytype *)key;

@end

/*!
 @interface SSLoadWarning
 @abstract information about a warning ie a non-fatal error in the xml file
 */
@interface SSLoadWarning : NSObject

/*!
 @property warning a warning value
 */
@property (readonly) enum sscore_warning warning;

/*!
 @property partIndex part index (-1 for all parts)
 */
@property (readonly)  int partIndex;

/*!
 @property barIndex bar index (-1 for all bars)
 */
@property (readonly)  int barIndex;

/*!
 @property element
 */
@property (readonly)  enum sscore_element_type element;

/*!
 @property item handle
 */
@property (readonly)  sscore_item_handle item_h;

/*!
 @property toString
 @abstract printable string describing this warning
 */
@property (readonly) NSString *toString;

//private
-(instancetype)initWith:(enum sscore_warning)w part:(int)partindex bar:(int)barindex element:(enum sscore_element_type)element item:(sscore_item_handle)item_h;

@end


/*!
 @interface SSLoadError
 @abstract information about any error, and all warnings
 */
@interface SSLoadError : NSObject

/*!
 @property err any error on load
 */
@property (readonly) enum sscore_error err;

/*!
 @property line the line number in the xml file of the (first) error (0 if none)
 */
@property (readonly)  int line;

/*!
 @property col the file column in the line (0 if none)
 */
@property (readonly)  int col;

/*!
 @property text any more information on the error
 */
@property (readonly)  NSString *text;

/*!
 @property warnings any warnings on load if SSLoadOptions.checkxml was set
 */
@property (readonly)  NSArray<SSLoadWarning*> *warnings;

//private
-(instancetype)initWith:(sscore_loaderror)err;

@end


/*!
 @interface SSPartName
 @abstract full and abbreviated names for a part defined in XML
 */
@interface SSPartName : NSObject

/*!
 @property abbreviated_name
 @abstract the abbreviated part name
 */
@property NSString *abbreviated_name;

/*!
 @property full_name
 @abstract the full part name
 */
@property NSString *full_name;

/*!
 @property idString
 @abstract the id eg "P1"
 */
@property NSString *idString;

/*!
 @property item_h
 @abstract the unique handle
 */
@property sscore_item_handle item_h;

@end



/*!
 @interface SSBarGroup
 @abstract detailed information about a group of items in a bar
 */
@interface SSBarGroup : NSObject

/*!
 @property partindex
 @abstract the 0-based index of the part containing this group
 */
@property int partindex;

/*!
 @property barindex
 @abstract the 0-based index of the bar containing this group
 */
@property int barindex;

/*!
 @property items
 @abstract the array of all items in the bar
 */
@property NSArray<SSDisplayedItem*> *items;

/*!
 @property divisions
 @abstract the divisions per quarter note (crotchet) in the bar
 */
@property int divisions;

/*!
 @property divisions_in_bar
 @abstract the total number of divisions in the bar
 */
@property int divisions_in_bar;

@end


/*!
 @interface SSHeader
 @abstract the MusicXML header containing info about the score - title, composer etc.
 */
@interface SSHeader : NSObject

/*!
 @property work_number
 @abstract the work_number in the MusicXML header
 */
@property  NSString *work_number;

/*!
 @property work_title
 @abstract the work_title in the MusicXML header
 */
@property  NSString *work_title;

/*!
 @property movement_number
 @abstract the movement_number in the MusicXML header
 */
@property  NSString *movement_number;

/*!
 @property movement_title
 @abstract the movement_title in the MusicXML header
 */
@property  NSString *movement_title;

/*!
 @property composer
 @abstract the composer of this work in the MusicXML header
 */
@property  NSString *composer;

/*!
 @property lyricist
 @abstract the lyricist of this work in the MusicXML header
 */
@property  NSString *lyricist;

/*!
 @property arranger
 @abstract the arranger of this work in the MusicXML header
 */
@property  NSString *arranger;

/*!
 @property credit_words
 @abstract array of NSString
 */
@property  NSArray<NSString*> *credit_words;

/*!
 @property parts
 @abstract array of SSPartName
 */
@property  NSArray<SSPartName*> *parts;

/*!
 @method partNameForHandle
 @abstract return the part name for unique handle
 */
-(SSPartName *)partNameForHandle:(sscore_item_handle)item_h;

@end


/*!
 @interface SSLayoutOptions
 @abstract options for layout of System(s)
 */
@interface SSLayoutOptions : NSObject

/*!
 @property hideBarNumbers
 @abstract set if the bar numbers should not be displayed
 */
@property bool hideBarNumbers;

/*!
 @property hidePartNames
 @abstract set if the part names should not be displayed
 */
@property bool hidePartNames;

/*!
 @property simplifyHarmonyEnharmonicSpelling
 @abstract set this flag so F-double-sharp appears in a harmony as G
 */
@property bool simplifyHarmonyEnharmonicSpelling;

/*!
 @property ignoreXMLPositions
 @abstract set if the default-x, default-y, relative-x, relative-y values in the XML should be ignored
 */
@property bool ignoreXMLPositions;

/*!
 @property useXMLxLayout
 @abstract set to use default-x values on notes and bar width values
 */
@property bool useXMLxLayout;

/*!
 @property redBeyondBarEnd
 @abstract set to display notes in red if they are beyond the end of the bar as defined by the time signature
 */
@property bool redBeyondBarEnd;

/*!
 @property editMode
 @abstract set for increased staff spacings for edit mode
 */
@property bool editMode;

/*! not supported yet
 */
@property bool expandRepeat;

/*!
 @property interStaffPaddingTenths
 @abstract extra spacing for between staves in multi-staff parts
 */
@property int interStaffPaddingTenths;

@end


/*!
 @typedef sslayout_callback_block_t
 @abstract definition of the block which is called on adding a system in layoutWithWidth:
 */
typedef bool (^sslayout_callback_block_t)(SSSystem*);


/*!
@interface SSScore
@abstract the main Objective-C interface to SeeScore
@discussion The main class of the SeeScore API, this encapsulates all information about the score loaded from a MusicXML file. You will
 find it more convenient and much simpler to use this interface from your Objective-C app rather than the pure C interface in
 sscore.h etc.
 <p>
 loadXMLFile() or loadXMLData() should be used to load a file and create a SScore object
 <p>
 layout() should be called on a background thread to create a layout, and SSystems are generated sequentially from
 the top and can be added to the display as they are produced, but you should ensure you do any UI operations on the foreground
 thread (using dispatch_after). This is all handled by SSView supplied as part of the sample app
 <p>
 numBars, numParts, getHeader(), getPartNameForPart(), getBarNumberForIndex() all return basic information about the score.
 <p>
 setTranspose() allows you to transpose the score.
 <p>
 Other methods return detailed information about items in the score and require a contents or contents-detail licence.

 */
@interface SSScore : NSObject

/*!
@property rawscore
@abstract the low level C API to the score
 */
@property (readonly) sscore* rawscore;

/*!
@property numParts
@abstract the total number of parts in the score.
 */
@property (readonly) int numParts;

/*!
@property numBars
@abstract the total number of bars in the score.
 */
@property (readonly) int numBars;

/*!
@property header
@abstract the MusicXML header information
 */
@property (readonly) SSHeader *header;

/*!
@property scoreHasDefinedTempo
@abstract true if there is a metronome or sound tempo defined in the XML
 */
@property (readonly) bool scoreHasDefinedTempo;

/*!
 @property isModified
 @abstract true if the current score is changed from when last loaded or saved
 */
@property (readonly) bool isModified;

/*!
 @property hasUndo
 @abstract true if is possible to undo the last edit
 */
@property (readonly) bool hasUndo;
/*!
 @property hasRedo
 @abstract true if is possible to redo the last undo
 */
@property (readonly) bool hasRedo;


/*!
@method version
@abstract the version of the SeeScore library
@return the version hi.lo
 */
+(sscore_version)version;

/*!
 @method versionString
 @abstract the version of the SeeScore library in the format "SeeScoreLib V2.54"
 @return the version string
 */
+(NSString*)versionString;

/*!
 @method headerFromXMLFile
 @abstract get the MusicXML header information quickly from the file without loading the whole file
 @return the header strings only (empty credits/parts). Return nil on error
 */
+(SSHeader*)headerFromXMLFile:(NSString*)filePath;

/*!
 @method scoreWithXMLData:
 @important note - type of error has been changed from sscore_loaderror to SSLoadError
 @abstract load the XML in-memory data and return a SSScore or null if error
 @discussion When loading mxl compressed data you must set the compressed flag in SSLoadOptions
 Any warnings are returned in err.warnings if SSLoadOptions.checkxml was set
 Swift signature SSScore(XMLData:data : NSData, options: loadOptions : SSLoadOptions, error: err : sscore_loaderror)
 @param data the NSData containing the MusicXML
 @param loadOptions the options for load including the licence key
 @param err returned pointer to a SSLoadError filled with the errors and warnings
 @return the SSScore or NULL if error with the error returned in err
 */
+(SSScore*)scoreWithXMLData:(NSData *)data
					options:(SSLoadOptions*)loadOptions
					  error:(SSLoadError**)err;

/*!
 @method scoreWithXMLFile:
 @important note - type of error has been changed from sscore_loaderror to SSLoadError
 @abstract load the XML file and return a SSScore or null if error
 @discussion This uses the .mxl file extension to detect mxl data
 Any warnings are returned in err.warnings if SSLoadOptions.checkxml was set
 Swift signature SSScore(XMLFile: xmlFilePath : String, options: loadOptions : SSLoadOptions, error: err : sscore_loaderror)
 @param filePath the full pathname of the file to load
 @param loadOptions the options for load including the licence key
 @param err returned pointer to a SSLoadError filled with the errors and warnings
 @return the SSScore or NULL if error with the error returned in err
 */
+(SSScore*)scoreWithXMLFile:(NSString *)filePath
					options:(SSLoadOptions*)loadOptions
					  error:(SSLoadError**)err;

/*!
 @method getXMLWarnings:
 @abstract get list of any problems in the XML
*/
-(NSArray<SSLoadWarning*> *)getXMLWarnings;

/*!
 @method compressFile:
 @abstract compress the file, and return the path of the compressed file in the same directory
 @param filePath the file path which must be of extension .xml
 @return the pathname of the compressed file with extension .mxl, or nil if failed
 */
+(NSString*)compressFile:(NSString*)filePath;

/*!
 @method partNameForPart:
 @abstract return the name for the part.
 @param partindex the index of the part [0..numparts-1]
 @return PartName (full + abbreviated)
 */
-(SSPartName*)partNameForPart:(int)partindex;

/*!
 @method instrumentNameForPart:
 @abstract return the name for the instrument for the part.
 @discussion This is often not defined in the XML, in which case the part name is probably the instrument name
 @param partindex the index of the part [0..numparts-1]
 @return instrument name, empty if not defined
 */
-(NSString*)instrumentNameForPart:(int)partindex;

/*!
 @method updateHeader
 @abstract change a field in the header
 @param fieldId defines which field to change
 @param val defines the new value
 */
-(void)updateHeader:(enum sscore_header_fieldid)fieldId val:(NSString*)val;

/*!
 @method saveToFile
 @abstract save the score to a MusicXML file
 @discussion this saves safely ie it saves to a tempoarary file and then copies that to the destination only if it succeeds
 @param filePath the pathname of the file to save - if the extension is .mxl the file is automatically compressed after saving
 @return any error
 */
-(enum sscore_error)saveToFile:(NSString*)filePath;

/*!
 @method saveToURL
 @abstract save the score to a MusicXML file defined by a NSURL
 @param url the url of the file to save
 @return any error
 */
-(enum sscore_error)saveToUrl:(NSURL*)url;

/*!
 @method saveToData
 @abstract save the score to NSData as required by UIDocument.contents
 @discussion the current implementation writes the compressed data to a temporary file, loads the file as NSData, deletes the file and returns the NSData
 @param compress if true save in .mxl format, else in .xml format
 @return NSData (probably to be written to a file)
 */
-(NSData*)saveToData:(bool)compress;

/*!
 @method saveToString
 @abstract save the score to a NSString in MusicXML format
 @return the NSString - nil if failed
 */
-(NSString*)saveToString;

/*!
 @method layout1SystemWithContext:
 @abstract Layout a single system with a single part.
 @discussion You specify a start bar index and a width and magnification and it will display
 as many bars as will fit into this width, up to a limit of maxBars if > 0.
 <p>Useful for display of individual parts for part selection.
 @param ctx a graphics context only for measurement of text (eg a bitmap context)
 @param startbarindex the index of the first bar in the system (usually 0)
 @param maxBars the maximum number of bars to include in the system, 0 to fit as  many as possible
 @param width the width to display the system within
 @param max_height the maximum height available to display the system to control truncation. =0 for no truncation
 @param partindex the index of the single part to layout [0..numparts-1]
 @param magnification the scale at which to display this (1.0 for normal size)
 @param layoutOptions layout options
 @return the system
 */
-(SSSystem*)layout1SystemWithContext:(CGContextRef)ctx
							startbar:(int)startbarindex
							 maxBars:(int)maxBars
							   width:(CGFloat)width
						   maxheight:(CGFloat)max_height
								part:(int)partindex
					   magnification:(float)magnification
							 options:(SSLayoutOptions*)layoutOptions;

/*!
 @method layoutWithContext:
 @abstract Layout a set of systems and return them through a callback function.
 @discussion This should be called on a background thread and it will call cb for each system laid out,
 from top to bottom. cb will normally add the system to a list and schedule an update on the
 foreground (gui event dispatch) thread to allow the UI to remain active during concurrent layout.
 cb can return false to abort the layout.
 @param ctx a graphics context only for measurement of text (eg a bitmap context)
 @param width the width available to display the systems in screen coordinates
 @param max_system_height the maximum height available to display each system to control truncation. =0 for no truncation
 @param parts array of NSNumber (boolean), 1 per part, true to include, false to exclude
 @param magnification the scale at which to display this (1.0 is default)
 @param layoutOptions the SSLayoutOptions
 @param callback the callback function to be called for each completed system
 */
-(enum sscore_error)layoutWithContext:(CGContextRef)ctx
								width:(CGFloat)width
							maxheight:(CGFloat)max_system_height
								parts:(NSArray<NSNumber*>*)parts
						magnification:(float)magnification
							  options:(SSLayoutOptions*)layoutOptions
							 callback:(sslayout_callback_block_t)callback;

/*!
 @method barNumberForIndex:
 @abstract Get the bar number (String) given the index.
 @param barindex integer index [0..numBars-1]
 @return the score-defined number String (usually "1" for index 0)
 */
-(NSString*)barNumberForIndex:(int)barindex;

/*!
 The transpose methods
 */

/*!
 @method setTranspose:
 @abstract Set a transposition for the score.
 @discussion Call layout() after calling setTranspose for a new transposed layout.
 <p>Requires the transpose licence.
 @param semitones (- for down, + for up)
 */
-(enum sscore_error)setTranspose:(int)semitones;

/*!
 @method transpose
 @abstract get the current transpose value set with setTranspose.
 @return the current transpose
 */
-(int)transpose;

/*!
 The contents methods are available if we have a contents licence
 */

/*!
 @method itemForPart:bar:handle:err
 @abstract return detailed information about an item in the score.
 @discussion Requires contents-detail licence.
 @param partindex 0-based part index - 0 is the top part
 @param barindex 0-based bar index
 @param item_h unique id for item eg from SSBarGroup
 @param err pointer to a sscore_error to receive any error
 @return SSTimedItem which can be cast to the specific derived type - NoteItem/DirectionItem etc.
 */
-(SSTimedItem*)itemForPart:(int)partindex
					   bar:(int)barindex
					handle:(sscore_item_handle)item_h
					   err:(enum sscore_error*)err;

/*!
 @method xmlForPart:bar:handle:err:
 @abstract Return the XML for the item in the part/bar.
 @discussion Requires contents licence.
 @param partindex the 0-based part index - 0 is top
 @param barindex the 0-based bar index
 @param item_h the unique id of the item eg from SSBarGroup
 @param err pointer to a sscore_error to receive any error
 @return the XML as a NSString
 */
-(NSString*)xmlForPart:(int)partindex
				   bar:(int)barindex
				handle:(sscore_item_handle)item_h
				   err:(enum sscore_error*)err;

/*!
 @method barContentsForPart:bar:err:
 @abstract Get information about the contents of a particular part/bar.
 @discussion Requires contents-detail licence.
 @param partindex the 0-based part index - 0 is top
 @param barindex the 0-based bar index
 @param err pointer to a sscore_error to receive any error
 @return the SSBarGroup containing an array of SSDisplayedItem.
 To get more information call itemForPart:bar:handle:err: using the item_h field 
 */
-(SSBarGroup*)barContentsForPart:(int)partindex
							 bar:(int)barindex
							 err:(enum sscore_error*)err;

/*!
 @method itemsForComponents:
 @abstract Get a list of items in BarGroups from a list of components
 @discussion Requires contents licence
 @param components array of SSComponent from SSSystem.closeFeatures or SSystem.featuresWithin
 @return the array of SSBarGroup containing an array of SSDisplayedItem.
 */
-(NSArray<SSBarGroup*>*)itemsForComponents:(NSArray<SSComponent*>*)components;

/*!
 @method xmlForPart:bar:err:
 @abstract Return the raw XML for this given part/bar index as a NSString.
 @discussion Requires contents-detail licence.
 @param partindex the 0-based part index - 0 is top
 @param barindex the 0-based bar index
 @param err pointer to a sscore_error to receive any error
 @return the XML as a NSString
 */
-(NSString*)xmlForPart:(int)partindex
				   bar:(int)barindex
				   err:(enum sscore_error*)err;

/*!
 @method xmlForScore
 @abstract Return the (reconstructed) XML for this entire score as a NSString.
 @discussion Requires contents-detail licence.
 @return the XML as a NSString
*/
-(NSString*)xmlForScore;

/*!
 @method barTypeForBar:
 @abstract is the bar a full bar?
 @param barIndex the 0-based bar index
 @return the type of bar (full or partial/anacrusis)
 */
-(enum sscore_bartype_e)barTypeForBar:(int)barIndex;

/*!
 @method timeSigForBar:
 @abstract return any time signature actually defined in a particular bar in the score, or zero if none
 @discussion actualBeatsForBar: is more useful to find the operating time signature in a bar
 @param barIndex the 0-based bar index
 @return the time signature in the bar - return beats = 0 if there is none
 */
-(sscore_timesig)timeSigForBar:(int)barIndex;

/*!
 @method actualBeatsForBar:
 @abstract return the time signature operating in a particular bar in the score
 @param barIndex the 0-based bar index
 @return the time signature in operation in the bar
 */
-(sscore_timesig)actualBeatsForBar:(int)barIndex;

/*!
 @method metronomeForBar:
 @abstract get the metronome if defined in a bar
 @param barIndex the 0-based bar index
 @return any metronome defined in the bar
 */
-(sscore_pd_tempo)metronomeForBar:(int)barIndex;

/*!
 @method tempoAtStart:
 @abstract get the tempo at the start of the score if defined
 @return information about the tempo to use at the start of the piece
 */
-(sscore_pd_tempo)tempoAtStart;

/*!
 @method tempoAtBar:
 @abstract get the tempo at a particular bar
 @param barIndex the 0-based bar index
 @return information about the tempo in the bar
 */
-(sscore_pd_tempo)tempoAtBar:(int)barIndex;

/*!
 @method convertTempoToBpm:
 @abstract convert a tempo value into a beats-per-minute value using the time signature
 @param tempo a tempo eg from tempoAtBar
 @param timesig a time signature eg from timeSigForBar
 @return beats per minute value
 */
-(int)convertTempoToBpm:(sscore_pd_tempo) tempo timeSig:(sscore_timesig)timesig;

/*!
 @method getBarBeats:
 @abstract get information about beats in a bar
 @param barindex the 0-based bar index
 @param bpm the beats per minute value
 @param bartype the type of bar (full or partial)
 @return information about number of beats and the beat time in ms for a bar
 */
-(sscore_pd_barbeats)getBarBeats:(int)barindex bpm:(int)bpm barType:(enum sscore_bartype_e) bartype;

/*!
 @method clefForComponentItem:
 @abstract get information about the clef which applies for the item which this component belongs to
 @param component the component
 @return the type of clef in force at the item containing this component
 */
-(enum sscore_clef_type_e)clefForComponentItem:(SSComponent*)component;

/*!
 @method clefApplyingAtPart:bar:staff:
 @abstract get information about the clef which applies in the part/bar/staff
 @param partIndex the part [0..numParts-1]
 @param barIndex the bar [0..numBars-1]
 @param staffIndex the staff [0..1]
 @return the type of clef in force in the part/bar/staff
 */
-(enum sscore_clef_type_e)clefApplyingAtPart:(int)partIndex bar:(int)barIndex staff:(int)staffIndex;

/*!
 @method keyFifthsApplyingAtPart:bar:staff:
 @abstract get information about the key signature which applies in the part/bar/staff
 @param partIndex the part [0..numParts-1]
 @param barIndex the bar [0..numBars-1]
 @param staffIndex the staff [0..1]
 @return the key fifths in force in the part/bar/staff
 */
-(int)keyFifthsApplyingAtPart:(int)partIndex bar:(int)barIndex staff:(int)staffIndex;

/*!
 @method timeSigApplyingAtPart:bar:staff:
 @abstract get information about the time signature which applies in the part/bar/staff
 @param partIndex the part [0..numParts-1]
 @param barIndex the bar [0..numBars-1]
 @param staffIndex the staff [0..1]
 @return the time signature in force in the part/bar/staff
 */
-(sscore_timesig_detail)timeSigApplyingAtPart:(int)partIndex bar:(int)barIndex staff:(int)staffIndex;

/*!
 @method hasLyricsInPart:staffIndex:
 @abstract true if the part/staff has lyrics
 @param partIndex the part [0..numParts-1]
 @param staffIndex the staff [0..1]
 @return true if the part/staff has lyrics
 */
-(bool)hasLyricsInPart:(int)partIndex staffIndex:(int)staffIndex;

/*!
 @method lyricForComponent:
 @abstract find the lyric from a layout component created from it
 @param lyricComponent the component
 @return the lyric
 */
-(SSLyric*)lyricForComponent:(SSComponent*)lyricComponent;

/*!
 @method numLyricLinesInPart:staffIndex:
 @abstract get the number of lyric lines in the part
 @param partIndex the 0-based part index
 @return the number of lyric lines in the part
 */
-(int)numLyricLinesInPart:(int)partIndex staffIndex:(int)staffIndex;

/*!
 @method getLyricsInPart:staffIndex:lyricLineIndex:
 @abstract get the lyrics in the part
 @discussion Requires contents licence.
 @param partIndex the 0-based part index
 @return the line of lyrics in the part
 */
-(NSString*)getLyricsInPart:(int)partIndex staffIndex:(int)staffIndex lyricLineIndex:(int)lyricLineIndex;

/*!
 @method firstLyricInPart:staffIndex:lyricLineindex:
 @abstract return information about the lyric on the first note in the part
 @discussion Requires contents licence.
 @param partIndex the 0-based part index
 @param staffIndex the 0-based staff index
 @param lyricLineIndex the 0-based lyric line index - 0 is top line of lyrics in part
 @return information about the first lyric in the part.
 */
-(SSLyric*)firstLyricInPart:(int)partIndex staffIndex:(int)staffIndex lyricLineIndex:(int)lyricLineIndex;

/*!
 @method nextLyric:
 @abstract return information about the next lyric after previous in the same part
 @discussion Requires contents licence.
 @param previous the current lyric
 @return information about the next lyric in the part after previous. return nil after last lyric in part
 */
-(SSLyric*)nextLyric:(SSLyric*)previous;

/*!
 The information required for playing the score is available through the SSPData class
 (only if a playdata licence is available)
 */

/*!
 @abstract editing methods
 @discussion each edit creates a new state and adds it to a list.
 The change handler is called with new and old state on each state change.
 Undo and redo just change the current index into the list of states
 All methods require the edit licence
*/

/*!
 @method undo
 @abstract undo the last edit
 @discussion property hasUndo is true if this can undo
 */
-(void)undo;

/*!
 @method redo
 @abstract redo the last undone edit
 @discussion property hasRedo is true if this can redo
 */
-(void)redo;

/*!
 @method modifyPartNameWithHandle:text:
 @warning EDITING API IN DEVELOPMENT
 @abstract modify the part name with the given id
 @discussion Requires edit licence.
 @param item_h the unique handle for the part name
 @param partName the text
 @return true if success
 */
-(bool)modifyPartNameWithHandle:(sscore_item_handle)item_h text:(NSString*)partName;

/*!
 @method isValidInsertTarget:forType:
 @warning EDITING API IN DEVELOPMENT
 @abstract is this a valid location for the new item to be inserted?
 @param target the target position in the score for the item
 @param itemType the type of the new item to be inserted
 @return true if a new item of type itemType can be inserted at target
 */
-(bool)isValidInsertTarget:(SSTargetLocation *)target forType:(SSEditType*)itemType;

/*!
 @method isValidMultiInsertTargetLeft:right:forType:
 @warning EDITING API IN DEVELOPMENT
 @abstract is this a valid pair of locations for the new multiple item (eg slur, tied, wedge, repeat barlines) to be inserted?
 @param target_left the left target position in the score for the item
 @param target_right the right target position in the score for the item
 @param itemType the type of the new item to be inserted
 @return true if a new item of multiple type itemType can be inserted at target_left,target_right
 */
-(bool)isValidMultiInsertTargetLeft:(SSTargetLocation *)target_left right:(SSTargetLocation *)target_right forType:(SSEditType*)itemType;

/*!
 @method isValidReinsertTarget
 @warning EDITING API IN DEVELOPMENT
 @abstract is this a valid location for the existing item to be reinserted (ie relocated)?
 @param target the target position in the score for the item
 @param item the existing item to be reinserted
 @return true if item can be reinserted at target
 */
-(bool)isValidReinsertTarget:(SSTargetLocation *)target forItem:(SSEditItem*)item;

/*!
 @method insertIsProvisory:at:
 @warning EDITING API IN DEVELOPMENT
 @abstract return true if this inserted item is not strictly required at this target, eg for a cautionary accidental
 @discussion Requires edit licence.
 @param itemType the type of the item
 @param target the logical insertion place from nearestInsertTargetFor:
 @return true if this item is not strictly necessary at this location, but can be inserted if required
 */
-(bool)insertIsProvisory:(SSEditType *)itemType at:(SSTargetLocation*)target;

/*!
 @method canAddTiedToNotehead
 @warning EDITING API IN DEVELOPMENT
 @abstract is there a suitable note to the right which can be tied to the notehead defined by target
 @param target the target
 @return true if a valid tied pair of elements can be added to the given notehead and one immediately to the right with the same pitch
 */
-(bool)canAddTiedToNotehead:(SSTargetLocation*)target;

/*!
 @method addTiedToNotehead
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract add a tied pair if there is a suitable note to the right which can be tied to the notehead defined by target
 @param target the target
 @return true if added pair successfully, false if not possible, with no change to score
 */
-(bool)addTiedToNotehead:(SSTargetLocation*)target;

/*!
 @method insertClef:omrEdit:at:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract insert a clef at the given target, replacing any clef existing at the target
 @param itemType the type of clef
 @param omrEdit true if we are correcting OMR (Optical Music Recognition) errors
 (ie if the XML has been generated from an image or pdf) so notes remain anchored to the same position
 on the staff when changing the clef, and accidentals are unchanged when changing the key
 @param target the target
 @return true if added successfully, false if not possible, with no change to score
 */
-(bool)insertClef:(SSEditType *)itemType
		  omrEdit:(bool)omrEdit
			   at:(SSTargetLocation*)target;

/*!
 @method insertDirectionWords:at:where:fontInfo:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract attempt to insert the given text as &lt;direction&gt&lt;direction-type&gt&lt;words&gt in the score at the target location, above the staff.
 @param words the text to insert
 @param target the insert position
 @param finfo the font size and style information or nil
 @return true if insert succeeded
 */
-(bool)insertDirectionWords:(NSString*)words
						 at:(SSTargetLocation*)target
				   fontInfo:(const sscore_edit_fontInfo*)finfo;

/*!
 @method insertDirectionWords:atNote:where:fontInfo:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract attempt to insert the given text as &lt;direction&gt&lt;direction-type&gt&lt;words&gt in the score immediately before the given note, above the staff.
 @param words the text to insert
 @param noteComponent the note before which the direction should be inserted
 @param finfo the font size and style information or nil
 @return true if insert succeeded
 */
-(bool)insertDirectionWords:(NSString*)words
					 atNote:(SSComponent *)noteComponent
				   fontInfo:(const sscore_edit_fontInfo*)finfo;

/*!
 @method insertLyric:at:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract attempt to insert the given text as a lyric in the score.
 @param lyricText the text to insert
 @param target the insert position
 @return true if insert succeeded
 */
-(bool)insertLyric:(NSString*)lyricText
				at:(SSTargetLocation*)target;

/*!
 @method lyricAtTarget:lyricLine:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires contents licence.
 @abstract get a lyric on the note at target
 @param target a note-defining target
 @param lyricLine 0 for top lyric on note
 @return lyric if lyric found on note at target in lyricline, else nil
 */
-(SSLyric*)lyricAtTarget:(SSTargetLocation*)target lyricLine:(int)lyricLine;

/*!
 @method tryInsertItem:at:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract attempt to insert the item in the score at the target location, return true if succeeded
 @param info information about the item to insert
 @param target the target location from nearestInsertTarget
 @return true if insert succeeded
 */
-(bool)tryInsertItem:(const sscore_edit_insertInfo*)info at:(SSTargetLocation*)target;

/*!
 @method tryInsertMultiItem:left:right:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract attempt to insert the multiple item (eg slur,tied,wedge) in the score at the left/right target locations, return true if succeeded
 @param info information about the item to insert
 @param target_left the left target location
 @param target_right the right target location
 @return true if insert succeeded
 */
-(bool)tryInsertMultiItem:(const sscore_edit_insertInfo*)info left:(SSTargetLocation*)target_left right:(SSTargetLocation*)target_right;

/*!
 @method tryOffsetItem:offset:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract attempt to offset an item setting default-x,default-y,bezier-x,bezier-y, return true if succeeded
 @param item information the item to move (only slur/tied bezier control points are supported at present)
 @param offset the x,y offset (from SSSystem.bezierOffset:forSystemPos:)
 @return true if offset successfully applied
 */
-(bool)tryOffsetItem:(SSEditItem *)item offset:(CGPoint)offset;

/*!
 @method tryReinsertItem:at:
 @warning EDITING API IN DEVELOPMENT
 @abstract attempt to reinsert the item in the score at the target location, return true if succeeded
 @discussion this is generally used when we drag an existing item in the score
  eg this is used to repitch a note when it is dragged up or down in the staff
	Requires edit licence.
 @param item the item to reinsert
 @param target the target location from nearestInsertTarget
 @return true if reinsert succeeded
 */
-(bool)tryReinsertItem:(SSEditItem*)item at:(SSTargetLocation*)target;

/*!
 @method deleteItem:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract delete an item from the score
 @discussion get the item from SSSystem
 @param item an editable item in the score
 @return true if it succeeded
 */
-(bool)deleteItem:(SSEditItem*)item;

/** Access fields in SSDirectionType corresponding to direction-type in XML **/

/*!
 @method staffIndexForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the staff index for a direction-type
 @param dirType a direction-type
 @return the staff index in the part - 0 is top staff in part
 */
-(int)staffIndexForDirection:(SSDirectionType*)dirType;

/*!
 @method directiveForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the directive flag for a direction-type (if set the left of the direction words is aligned with the left of the time signature, else with the first note)
 @param dirType a direction-type
 @return the directive flag
 */
-(bool)directiveForDirection:(SSDirectionType*)dirType;

/*!
 @method placementForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the placement for a direction-type
 @param dirType a direction-type
 @return the placement for the direction
 */
-(enum sscore_placement_e)placementForDirection:(SSDirectionType*)dirType;

/*!
 @method wordsForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the text string for a direction-type
 @param dirType a direction-type
 @return the text string
 */
-(NSString*)wordsForDirection:(SSDirectionTypeWords*)dirType;

/*!
 @method boldForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the bold flag for a direction-type
 @param dirType a direction-type
 @return the bold flag
 */
-(bool)boldForDirection:(SSDirectionTypeWords*)dirType;

/*!
 @method italicForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the italic flag in a direction-type
 @param dirType a direction-type
 @return the italic flag
 */
-(bool)italicForDirection:(SSDirectionTypeWords*)dirType;

/*!
 @method pointSizeForDirection:
 @warning EDITING API IN DEVELOPMENT
 @abstract get the font point size for a direction words element
 @param dirType a direction-type words element
 @return the font point size
 */
-(CGFloat)pointSizeForDirection:(SSDirectionTypeWords*)dirType;

/*!
 @method setDirection:words:pointSize:bold:italic:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract modify a SSDirectionTypeWords
 @param dirType a direction-type
 @param words the text
 @param pointSize the point size of the font .. 0 is default
 @param bold the bold flag
 @param italic the italic flag
 @return true if success
 */
-(bool)setDirection:(SSDirectionTypeWords*)dirType words:(NSString *)words pointSize:(CGFloat)pointSize bold:(bool)bold italic:(bool)italic;

/*!
 @method addLyricInPart:barIndex:staffIndex:lyricLineIndex:text:linkNextSyllable:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract add a lyric
 @param partIndex the part
 @param barIndex the bar
 @param staffIndex the staff
 @param lyricLineIndex the lyric line
 @param note_h the unique handle of the note to receive the lyric
 @param text the lyric text
 @param linkNextSyllable true to link this syllable to the next lyric with dashes
 @return true if success
 */
-(bool)addLyricInPart:(int)partIndex
			 barIndex:(int)barIndex
		   staffIndex:(int)staffIndex
	   lyricLineIndex:(int)lyricLineIndex
			   note_h:(sscore_item_handle)note_h
				 text:(NSString*)text
	 linkNextSyllable:(bool)linkNextSyllable;

/*!
 @method modifyLyric:text:linkNextSyllable:
 @warning EDITING API IN DEVELOPMENT
 @discussion Requires edit licence.
 @abstract modify a lyric
 @param lyric a lyric from lyricForComponent
 @param text the new text or "" for no change
 @param linkNextSyllable true to link this syllable to the next lyric with dashes
 @return true if success
 */
-(bool)modifyLyric:(SSLyric*)lyric text:(NSString*)text linkNextSyllable:(bool)linkNextSyllable;

/*!
 @method removeEmptyBars
 @abstract remove any empty bars in score
 @discussion Requires edit licence.
 */
-(void)removeEmptyBars;

/** change handler **/

/*!
 @method addChangeHandler:
 @abstract add a handler to be called on each state change (edit, undo or redo)
 @discussion the handler is called with the old and new state. These states can be compared
 so if the change affects only one bar then perhaps only that needs to be updated.
 All parts of the UI which show a representation of any part of the score should use a handler
 to force a redraw so everything updates automatically on a state change
 @param handler the change handler
 @return a unique id for the handler to be used as an argument to removeChangeHandler
 */
-(sscore_changeHandler_id)addChangeHandler:(id<ScoreChangeHandler>)handler;

/*!
 @method removeChangeHandler:
 @abstract remove the change handler added with addChangeHandler:
 @param handlerId the id returned from addChangeHandler
 */
-(void)removeChangeHandler:(sscore_changeHandler_id)handlerId;

-(CGRect)textBBWithContext:(CGContextRef)ctx text:(NSString*)text type:(enum sscore_edit_textType)textType;
-(void)drawTextWithContext:(CGContextRef)ctx text:(NSString*)text type:(enum sscore_edit_textType)textType bottomLeft:(CGPoint)bottomLeft scale:(float)scale colour:(CGColorRef)colour;

// internal use
@property (readonly) const sscore_libkeytype *key;

@end
