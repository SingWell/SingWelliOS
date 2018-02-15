//
//  sscore_edit.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

/*************
 IMPORTANT WARNING!
 This interface is under current development so you should expect API changes
*************/

#ifndef SeeScoreLib_sscore_edit_h
#define SeeScoreLib_sscore_edit_h

#include "sscore.h"
#include "sscore_contents.h"

#ifdef __cplusplus
extern "C" {
#endif
	
// switch off clang incorrect warning about empty args in C declaration
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

	/*!
	 @header interface to editing the MusicXML
	 */
	
	#define sscore_edit_kMaxInsertTextCharacters 64 // eg for direction words
	
	#define sscore_kMaxFontNameLength 64
	
	#define sscore_edit_kMaxDots 2 // maximum supported number of dots on note for edit
	
#ifndef SSCORE_SYM_DEF // guard against multiple defs
#define SSCORE_SYM_DEF
	typedef unsigned sscore_symbol;
#endif

	/*!
	 @enum sscore_edit_leftRightLocation
	 @abstract define horizontal location relative to another item
	 */
	enum sscore_edit_leftRightLocation {
		sscore_edit_lr_undefined,
		sscore_edit_lr_left,
		sscore_edit_lr_right,
		sscore_edit_lr_centre
	};
	
	/*!
	 @enum sscore_edit_targetType
	 @abstract define type of item at the target
	 */
	enum sscore_edit_targetType {
		sscore_edit_targetType_none,
		sscore_edit_targetType_clef,
		sscore_edit_targetType_keySig,
		sscore_edit_targetType_timeSig,
		sscore_edit_targetType_notehead,
		sscore_edit_targetType_rest,
		sscore_edit_targetType_dynamics,
		sscore_edit_targetType_tuplet,
		sscore_edit_targetType_metronome,
		sscore_edit_targetType_text,
		sscore_edit_targetType_lyricText,
		sscore_edit_targetType_unknown
	};
	
	/*!
	 @enum sscore_edit_textType
	 @abstract define type of direction words text
	 @discussion unfortunately there is currently no way for the MusicXML to capture this important information
	 (except directive) but we hope it will be added to the standard in future.
	 SeeScore internally uses various ad-hoc techniques including text matching with known strings to attempt to
	 identify the type automatically
	 */
	enum sscore_edit_textType {
		/* undefined type */
		sscore_edit_tt_undefined,
		
		/* the direction is a directive placed at the left of the bar aligned with the time signature usually a tempo and/or metronome */
		sscore_edit_tt_directive,
		
		/* the direction is a dynamic eg mf, cresc., dim */
		sscore_edit_tt_dynamics,
		
		/* a tempo marking eg Allegro, rit. */
		sscore_edit_tt_tempo,
		
		/* an articulation marking eg pizz., arco */
		sscore_edit_tt_articulation,
		
		/* a repeat instruction eg DC, DS */
		sscore_edit_tt_repeat,
		
		/* a string number */
		sscore_edit_tt_string,
		
		/* special note text placed above all other markings identified to SeeScore by tagging with a trailing space character */
		sscore_edit_tt_note,
		
		/* an expression instruction eg dolce */
		sscore_edit_tt_expression,
		
		/* single lyric syllable */
		sscore_edit_tt_single_syl,
		
		/* begin lyric syllable (dashed to next syllable) */
		sscore_edit_tt_begin_syl
	};

	/*!
	 @enum sscore_edit_baseType
	 @abstract a base type of element in the score
	 */
	enum sscore_edit_baseType {
		sscore_edit_invalid_baseType,
		sscore_edit_clef_baseType,
		sscore_edit_note_baseType,
		sscore_edit_rest_baseType,
		sscore_edit_notehead_baseType,
		sscore_edit_dots_baseType,
		sscore_edit_accidental_baseType,
		sscore_edit_lyric_baseType,
		sscore_edit_direction_baseType,
		sscore_edit_notation_baseType,
		sscore_edit_timesig_baseType,
		sscore_edit_keysig_baseType,
		sscore_edit_harmony_baseType,
		sscore_edit_barline_baseType,
		sscore_edit_part_baseType,
		sscore_edit_bar_baseType,
		sscore_edit_partname_baseType,
		sscore_edit_numbasetypes
	};
	
	enum sscore_edit_barline_type {
		sscore_edit_barline_normal,
		sscore_edit_barline_dotted,
		sscore_edit_barline_dashed,
		sscore_edit_barline_tick,
		sscore_edit_barline_short,
		sscore_edit_barline_double, // thin double
		sscore_edit_barline_repeatleft, // thick,thin with dots on the right of the barline
		sscore_edit_barline_repeatright, // thin,thick with dots on the left
		sscore_edit_barline_item,	// an item associated with a barline (segno/coda etc)
		sscore_edit_barline_segno,
		sscore_edit_barline_coda,
		sscore_edit_barline_fermata
	};
	
	enum sscore_edit_part_type {
		sscore_edit_part_1stave,	// a part with 1 staff
		sscore_edit_part_2stave		// a part with 2 staves
	};
	
	enum sscore_edit_bar_type {
		sscore_edit_bar_withRest,	// a bar containing a whole bar rest
		sscore_edit_bar_withoutRest	// a completely empty bar for inserting an anacrusis bar.
	};
	
	/*!
	 @enum sscore_edit_clef_type
	 @abstract a type of clef
	 */
	enum sscore_edit_clef_type {
		sscore_edit_clef_invalid,
		sscore_edit_clef_G,
		sscore_edit_clef_F,
		sscore_edit_clef_C,
		sscore_edit_clef_perc,
		sscore_edit_clef_tab };
	
	/*!
	 @enum sscore_edit_clef_shift
	 @abstract to specify a clef with an 8 above or below
	 */
	enum sscore_edit_clef_shift {
		sscore_edit_clef_shift_none,
		sscore_edit_clef_shift_octaveup,
		sscore_edit_clef_shift_octavedown };
	
	/*!
	 @enum sscore_edit_note_value
	 @abstract a note or rest value
	 */
	enum sscore_edit_note_value {
		sscore_edit_noteval_invalid,
		sscore_edit_noteval_square_breve,
		sscore_edit_noteval_breve,
		sscore_edit_noteval_whole,		// semibreve
		sscore_edit_noteval_half,		// minim
		sscore_edit_noteval_4th,		// crotchet
		sscore_edit_noteval_8th,		// quaver
		sscore_edit_noteval_16th,
		sscore_edit_noteval_32th,
		sscore_edit_noteval_64th,
		sscore_edit_noteval_128th};
	
	/*!
	 @enum sscore_edit_accidental_type
	 @abstract a type of accidental
	 */
	enum sscore_edit_accidental_type {
		sscore_edit_accidental_invalid,
		sscore_edit_accidental_doubleflat,
		sscore_edit_accidental_flat,
		sscore_edit_accidental_natural,
		sscore_edit_accidental_sharp,
		sscore_edit_accidental_doublesharp,
	};
	
	/*!
	 @enum sscore_edit_dynamic_type
	 @abstract a type of dynamic
	 @discussion this can be inserted in a direction or a notation. Direction dynamics is preferred. Notation dynamics is probably a bad idea
	 */
	enum sscore_edit_dynamic_type {
		sscore_edit_dynamic_invalid,
		sscore_edit_dynamic_f,
		sscore_edit_dynamic_ff,
		sscore_edit_dynamic_fff,
		sscore_edit_dynamic_ffff,
		sscore_edit_dynamic_fffff,
		sscore_edit_dynamic_ffffff,
		sscore_edit_dynamic_p,
		sscore_edit_dynamic_pp,
		sscore_edit_dynamic_ppp,
		sscore_edit_dynamic_pppp,
		sscore_edit_dynamic_ppppp,
		sscore_edit_dynamic_pppppp,
		sscore_edit_dynamic_mf,
		sscore_edit_dynamic_mp,
		sscore_edit_dynamic_sf,
		sscore_edit_dynamic_sfp,
		sscore_edit_dynamic_sfpp,
		sscore_edit_dynamic_fp,
		sscore_edit_dynamic_rf,
		sscore_edit_dynamic_rfz,
		sscore_edit_dynamic_sfz,
		sscore_edit_dynamic_sffz,
		sscore_edit_dynamic_fz,
		sscore_edit_dynamic_n,
		sscore_edit_dynamic_pf,
		sscore_edit_dynamic_sfzp,
		sscore_edit_dynamic_other
	};
	
	/*!
	 @enum sscore_edit_direction_type
	 @abstract a type of direction corresponding to MusicXML direction-type
	 */
	enum sscore_edit_direction_type {
		sscore_edit_direction_rehearsal,
		sscore_edit_direction_segno,
		sscore_edit_direction_words,
		sscore_edit_direction_coda,
		sscore_edit_direction_wedge,
		sscore_edit_direction_dynamics,
		sscore_edit_direction_dashes,
		sscore_edit_direction_bracket,
		sscore_edit_direction_pedal,
		sscore_edit_direction_metronome,
		sscore_edit_direction_octave_shift,
		sscore_edit_direction_harp_pedals,
		sscore_edit_direction_damp,
		sscore_edit_direction_damp_all,
		sscore_edit_direction_eyeglasses,
		sscore_edit_direction_string_mute,
		sscore_edit_direction_scordatura,
		sscore_edit_direction_image,
		sscore_edit_direction_principal_voice,
		sscore_edit_direction_accordion_registration,
		sscore_edit_direction_percussion,
		sscore_edit_direction_other_direction_e
	};
	
	/*!
	 @enum sscore_edit_notation_type
	 @abstract notation corresponding to MusicXML notation
	 */
	enum sscore_edit_notation_type {
		sscore_edit_notation_invalid,
		sscore_edit_notation_tied,
		sscore_edit_notation_slur,
		sscore_edit_notation_tuplet,
		sscore_edit_notation_glissando,
		sscore_edit_notation_slide,
		sscore_edit_notation_ornaments,
		sscore_edit_notation_technical,
		sscore_edit_notation_articulations,
		sscore_edit_notation_dynamics,
		sscore_edit_notation_fermata,
		sscore_edit_notation_arpeggiate,
		sscore_edit_notation_non_arpeggiate,
		sscore_edit_notation_accidental_mark,
		sscore_edit_notation_other
	};
	
	/*!
	 @enum sscore_edit_articulation_type
	 @abstract a type of articulation
	 */
	enum sscore_edit_articulation_type {
		sscore_edit_articulation_invalid,
		sscore_edit_articulation_staccato,
		sscore_edit_articulation_staccatissimo,
		sscore_edit_articulation_tenuto,
		sscore_edit_articulation_spiccato,
		sscore_edit_articulation_accent,
		sscore_edit_articulation_strong_accent,
		sscore_edit_articulation_detached_legato,
		sscore_edit_articulation_scoop,
		sscore_edit_articulation_plop,
		sscore_edit_articulation_doit,
		sscore_edit_articulation_falloff,
		sscore_edit_articulation_breath_mark,
		sscore_edit_articulation_caesura,
		sscore_edit_articulation_stress,
		sscore_edit_articulation_unstress,
		sscore_edit_articulation_other
	};
	
	/*!
	 @enum sscore_edit_technical_type
	 @abstract a MusicXML technical type
	 */
	enum sscore_edit_technical_type {
		sscore_edit_technical_invalid,
		sscore_edit_technical_up_bow,
		sscore_edit_technical_down_bow,
		sscore_edit_technical_harmonic,
		sscore_edit_technical_open_string,
		sscore_edit_technical_thumb_position,
		sscore_edit_technical_fingering,
		sscore_edit_technical_pluck,
		sscore_edit_technical_double_tongue,
		sscore_edit_technical_triple_tongue,
		sscore_edit_technical_stopped,
		sscore_edit_technical_snap_pizzicato,
		sscore_edit_technical_fret,
		sscore_edit_technical_string,
		sscore_edit_technical_hammer_on,
		sscore_edit_technical_pull_off,
		sscore_edit_technical_bend,
		sscore_edit_technical_tap,
		sscore_edit_technical_heel,
		sscore_edit_technical_toe,
		sscore_edit_technical_fingernails,
		sscore_edit_technical_hole,
		sscore_edit_technical_arrow,
		sscore_edit_technical_handbell,
		sscore_edit_technical_other
	};
	
	/*!
	 @enum sscore_edit_ornament_type
	 @abstract a type of ornament
	 */
	enum sscore_edit_ornament_type {
		sscore_edit_ornament_invalid,
		sscore_edit_ornament_trill_mark,
		sscore_edit_ornament_turn,
		sscore_edit_ornament_delayed_turn,
		sscore_edit_ornament_inverted_turn,
		sscore_edit_ornament_delayed_inverted_turn,
		sscore_edit_ornament_vertical_turn,
		sscore_edit_ornament_inverted_vertical_turn,
		sscore_edit_ornament_shake,
		sscore_edit_ornament_wavy_line,
		sscore_edit_ornament_mordent,
		sscore_edit_ornament_inverted_mordent,
		sscore_edit_ornament_schleifer,
		sscore_edit_ornament_tremolo,
		sscore_edit_ornament_haydn,
		sscore_edit_ornament_other
	};
		
	/*!
	 @enum sscore_edit_wedge_type
	 @abstract type of wedge
	 */
	enum sscore_edit_wedge_type {
		sscore_edit_wedge_dim,
		sscore_edit_wedge_cresc,
		sscore_edit_wedge_stop
	};
	
	/*!
	 @enum sscore_edit_bezier_type
	 @abstract direction of slur or tie
	 */
	enum sscore_edit_bezier_type {
		sscore_edit_bezier_undef,
		sscore_edit_bezier_over,
		sscore_edit_bezier_under
	};

	/*!
	 @enum sscore_edit_pedal_type
	 @abstract pedal type using line or * symbol
	 */
	enum sscore_edit_pedal_type {
		sscore_edit_pedal_sign,
		sscore_edit_pedal_line,
		sscore_edit_pedal_stop
	};
	/*!
	 @struct sscore_edit_type
	 @abstract encapsulates a specific type of item which can be edited in the score - eg a treble clef or a crotchet, or an up-bow notation
	 @discussion contains sscore_edit_baseType (accessed with sscore_edit_baseTypeFor) and specific type info
	 */
	typedef struct sscore_edit_type
	{// private
		unsigned u[16];
	} sscore_edit_type;
	
	/*!
	 @struct sscore_edit_insertInfo
	 @abstract information about an item to insert into the score
	 @discussion the fields are private to SeeScore
	 */
	typedef struct sscore_edit_insertInfo
	{
		//private:
		unsigned u[256];
	} sscore_edit_insertInfo;
	
	/*!
	 @struct sscore_edit_targetLocation
	 @abstract information about a location relative to existing notes in the bar of where to insert an item into the score
	 @discussion this contains information identifying the part,bar,staff and nearest note(s)
	 The fields are private to SeeScore
	 */
	typedef struct sscore_edit_targetLocation
	{
		//private:
		unsigned u[64];
	} sscore_edit_targetLocation;

	/*!
	 @struct sscore_edit_item
	 @abstract an item in the score which can be edited (eg note, wedge, slur, accent etc)
	 @discussion the fields are private to SeeScore
	 */
	typedef struct sscore_edit_item
	{
		//private
		unsigned u[128];
	} sscore_edit_item;
	
	/*!
	 @struct sscore_edit_detailInfo
	 @abstract detailed information about an object to be inserted
	 @discussion the fields are private to SeeScore
	 */
	typedef struct sscore_edit_detailInfo
	{
		//private
		unsigned u[128];
	} sscore_edit_detailInfo;
	
	/*!
	 @struct sscore_edit_fontInfo
	 @abstract font information
	 */
	typedef struct sscore_edit_fontInfo
	{
		char family[sscore_kMaxFontNameLength]; // normally blank - SeeScore does not heed font names when rendering
		bool bold;
		bool italic;
		float pointSize; // 0 for default
		unsigned u[8];
	} sscore_edit_fontInfo;

	/*!
	 @struct sscore_edit_noteInsertPos
	 @abstract information about a point to insert a note or rest
	 */
	typedef struct sscore_edit_noteInsertPos {
		bool defined;
		sscore_point pos;
		int normalisedTime;
		bool noteheadIsOnLine;
		int numLedgers; // number of ledgers .. - if below staff, + if above staff
		bool inChord;
		unsigned dummy[64];
	} sscore_edit_noteInsertPos;
	
	/*!
	 @typedef sscore_state_container
	 @abstract a wrapper for the complete state of the score at any particular point
	 @discussion each edit creates a new state. undo and redo work by accessing states from a list of historic states
	 SeeScore uses a Persistent Data Structure
	 sscore_edit_barChanged can be used to compare states for any particular bar to enable the app to suppress redraw for unchanged bars
	 */
	typedef struct sscore_state_container sscore_state_container;
	
	/*!
	 @enum sscore_state_changeReason
	 @abstract a reason for a state change passed to sscore_changeHandler
	 */
	enum sscore_state_changeReason { sscore_state_changeReason_undo, sscore_state_changeReason_redo, sscore_state_changeReason_newstate};
	
	/*!
	 @typedef sscore_changeHandler
	 @abstract a handler which is notified of a state change
	 param prevstate the previous state
	 param newstate the new state
	 param reason the reason for the state change
	 param arg context argument
	 */
	typedef void (*sscore_changeHandler)(sscore_state_container *prevstate,
										sscore_state_container *newstate,
										enum sscore_state_changeReason reason,
										void *arg);
	
	/*!
	 @typedef sscore_changeHandler_id
	 @abstract a handle for a change handler returned from sscore_edit_addChangeHandler
	 */
	typedef unsigned long sscore_changeHandler_id;
	
	/*!
	 @function sscore_edit_addChangeHandler
	 @abstract add a changehandler to be called when the score changes as a result of editing
	 @param sc the score
	 @param handler the change handler
	 @param arg the context argument to be passed to the handler when it is called
	 @return an id to be used as an argument to sscore_edit_removeChangeHandler
	 */
	EXPORT sscore_changeHandler_id sscore_edit_addChangeHandler(sscore *sc, sscore_changeHandler handler, void *arg);
	
	/*!
	 @function sscore_edit_removeChangeHandler
	 @abstract remove a changehandler added with sscore_edit_addChangeHandler
	 @param sc the score
	 @param handler_id the handler id returned from sscore_edit_addChangeHandler
	 */
	EXPORT void sscore_edit_removeChangeHandler(sscore *sc, sscore_changeHandler_id handler_id);
	
	/*!
	 @function sscore_edit_hasUndo
	 @abstract is the current state undoable? (used to enable undo button in UI)
	 @param sc the score
	 @return true if the state is undoable
	 */
	EXPORT bool sscore_edit_hasUndo(sscore *sc);
	
	/*!
	 @function sscore_edit_undo
	 @abstract undo the last operation (if undoable)
	 @param sc the score
	 */
	EXPORT void sscore_edit_undo(sscore *sc);
	
	/*!
	 @function sscore_edit_hasRedo
	 @abstract is the current state redoable? (used to enable redo button in UI)
	 @param sc the score
	 @return true if the state is redoable
	 */
	EXPORT bool sscore_edit_hasRedo(sscore *sc);
	
	/*!
	 @function sscore_edit_redo
	 @abstract redo the last undone operation (if possible)
	 @param sc the score
	 */
	EXPORT void sscore_edit_redo(sscore *sc);
	
	/*!
	 @function sscore_edit_selectItem
	 @abstract select (highlight) an item in the system
	 @param system the system
	 @param item_h the item handle
	 @param partIndex the part index [0..]
	 @param barIndex the bar index [0..]
	 @param fgCol the foreground colour to use to paint the selected item
	 @param bgCol the background colour for the selected item
	 */
	EXPORT void sscore_edit_selectItem(sscore_system *system, sscore_item_handle item_h,
									   int partIndex, int barIndex,
									   const sscore_colour_alpha *fgCol, const sscore_colour_alpha *bgCol);
	
	/*!
	 @function sscore_edit_deselectItem
	 @abstract deselect a selected item
	 @param system the system
	 @param item_h the item handle
	 */
	EXPORT void sscore_edit_deselectItem(sscore_system *system, sscore_item_handle item_h);
	
	/*!
	 @function sscore_edit_deselectAll
	 @abstract deselect all selected items in system
	 @param system the system
	 */
	EXPORT void sscore_edit_deselectAll(sscore_system *system);
	
	/*!
	 @function sscore_edit_partCountChanged
	 @abstract true if the total number of parts has changed between prevstate and newstate
	 @param prevstate the previous state from sscore_changeHandler
	 @param newstate the new state from sscore_changeHandler
	 @return true if newstate contains more or less parts than prevstate
	 */
	EXPORT bool sscore_edit_partCountChanged(const sscore_state_container *prevstate,
											const sscore_state_container *newstate);
	
	/*!
	 @function sscore_edit_partChanged
	 @abstract true if anything has changed in the given part between prevstate and newstate
	 @param partIndex the part index [0..]
	 @param prevstate the previous state from sscore_changeHandler
	 @param newstate the new state from sscore_changeHandler
	 @return true if anything has changed in the given part
	 */
	EXPORT bool sscore_edit_partChanged(int partIndex,
									   const sscore_state_container *prevstate,
									   const sscore_state_container *newstate);
	
	/*!
	 @function sscore_edit_barCountChanged
	 @abstract true if the total number of bars has changed between prevstate and newstate
	 @param prevstate the previous state from sscore_changeHandler
	 @param newstate the new state from sscore_changeHandler
	 @return true if newstate contains more or less bars than prevstate
	 */
	EXPORT bool sscore_edit_barCountChanged(const sscore_state_container *prevstate,
											const sscore_state_container *newstate);

	/*!
	 @function sscore_edit_barChanged
	 @abstract true if anything has changed in the given bar between prevstate and newstate
	 @param barIndex the bar index [0..]
	 @param prevstate the previous state from sscore_changeHandler
	 @param newstate the new state from sscore_changeHandler
	 @return true if anything has changed in the given bar
	 */
	EXPORT bool sscore_edit_barChanged(int barIndex,
									   const sscore_state_container *prevstate,
									   const sscore_state_container *newstate);

	/*!
	 @function sscore_edit_headerChanged
	 @abstract has anything changed in the header (eg part name or credit) between prevstate and newstate
	 @param prevstate the previous state from sscore_changeHandler
	 @param newstate the new state from sscore_changeHandler
	 @return true if anything has changed in the header
	 */
	EXPORT bool sscore_edit_headerChanged(const sscore_state_container *prevstate,
										  const sscore_state_container *newstate);

	/*!
	 @function sscore_edit_updateLayout
	 @abstract update the layout after state change
	 @param graphics the graphics for measurement
	 @param score the score
	 @param newstate the new state, argument to sscore_changeHandler
	 */
	EXPORT void sscore_edit_updateLayout(sscore_graphics *graphics, sscore *score, const sscore_state_container *newstate);

	
	/** Define unique types for all score elements **/
	
	/*!
	 @function sscore_edit_typeForEmptyBar
	 @abstract get a sscore_edit_type for an empty bar to insert into the score
	 @param insert_whole_bar_rest true for standard whole bar rest in bar, false for nothing in bar (for anacrusis/pickup)
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForEmptyBar(bool insert_whole_bar_rest);
	
	/*!
	 @function sscore_edit_typeForBarline
	 @abstract get a sscore_edit_type for a barline
	 @param type the type of barline.
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForBarline(enum sscore_edit_barline_type type);
	
	/*!
	 @function sscore_edit_typeForClef
	 @abstract get a sscore_edit_type for a particular clef
	 @param type the clef subtype
	 @param line the staff line [1..5], 0 for default
	 @param shift octave shift
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForClef(enum sscore_edit_clef_type type, int line, enum sscore_edit_clef_shift shift);
	
	/*!
	 @function sscore_edit_typeForTimeSig
	 @abstract get a sscore_edit_type for a time signature
	 @param type the type of time signature
	 @param upper the upper number if applicable
	 @param lower the lower number if applicable
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForTimeSig(enum sscore_timesig_type type, int upper, int lower);
	
	/*!
	 @function sscore_edit_typeForKeySig
	 @abstract get a sscore_edit_type for a particular key signature
	 @param fifths if positive the number of sharps in the key, if negative the number of flats in the key
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForKeySig(int fifths);
	
	/*!
	 @function sscore_edit_typeForNote
	 @abstract get a sscore_edit_type for a particular note type
	 @param type the note value
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForNote(enum sscore_edit_note_value type);

	/*!
	 @function sscore_edit_typeForRest
	 @abstract get a sscore_edit_type for a particular rest
	 @param type the rest value
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForRest(enum sscore_edit_note_value type);
	
	/*!
	 @function sscore_edit_typeForAccidental
	 @abstract get a sscore_edit_type for a particular accidental
	 @param type the accidental subtype
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForAccidental(enum sscore_edit_accidental_type type);
	
	/*!
	 @function sscore_edit_typeForDynamicsNotation
	 @abstract get a sscore_edit_type for a particular dynamic (as a MusicXML notation)
	 @discussion NOT RECOMMENDED - use sscore_edit_typeForDynamicsDirection - Why do we have the notation dynamics?
	 @param type the dynamic subtype
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForDynamicsNotation(enum sscore_edit_dynamic_type type);

	/*!
	 @function sscore_edit_typeForDynamicsDirection
	 @abstract get a sscore_edit_type for a particular dynamic (as a MusicXML direction)
	 @discussion RECOMMENDED this dynamics-in-direction over dynamics-in-notation
	 @param type the dynamic subtype
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForDynamicsDirection(enum sscore_edit_dynamic_type type);
	
	/*!
	 @function sscore_edit_typeForDirectionWords
	 @deprecated use sscore_edit_typeForDirectionWordsLong
	 @abstract get a sscore_edit_type for direction.direction-type.words
	 @param textType define the function of the text in the score
	 @param text the UTF-8 text eg. "Allegro", "pizz." etc. NB max length is 32 bytes
	 @return the type info
	 */
	EXPORT __attribute__((deprecated)) sscore_edit_type sscore_edit_typeForDirectionWords(enum sscore_edit_textType textType, const char *text);
	
	/*!
	 @function sscore_edit_typeForDirectionWordsLong
	 @abstract get a sscore_edit_type for direction.direction-type.words
	 @discussion the text is conveyed in sscore_edit_insertInfo
	 @param textType define the function of the text in the score
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForDirectionWordsLong(enum sscore_edit_textType textType);
	
	/*!
	 @function sscore_edit_typeForMetronome
	 @abstract get a sscore_edit_type for direction.direction-type.metronome
	 @param beat_type conventional value for the note type (4 = crotchet/quarter, 2 = minim/half etc).
	 Use 0 for a special undefined type which will make SeeScore choose a suitable value for the time signature
	 @param dots number of dots on note
	 @param bpm the beats-per-minute
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForMetronome(int beat_type, int dots, int bpm);
	
	/*!
	 @function sscore_edit_typeForArticulation
	 @abstract get a sscore_edit_type for a particular articulation
	 @param type the articulation subtype
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForArticulation(enum sscore_edit_articulation_type type);
	
	/*!
	 @function sscore_edit_typeForTechnical
	 @abstract get a sscore_edit_type for a particular technical type
	 @param type the technical subtype
	 @param info any extra info (max 8 bytes) required for type eg finger number for fingering
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForTechnical(enum sscore_edit_technical_type type, const char *info);
	
	/*!
	 @function sscore_edit_typeForOrnament
	 @abstract get a sscore_edit_type for a particular ornament
	 @param type the ornament subtype
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForOrnament(enum sscore_edit_ornament_type type);
	
	/*!
	 @function sscore_edit_typeForDots
	 @abstract get a sscore_edit_type for dots (ie on dotted note)
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForDots();
	
	/*!
	 @function sscore_edit_typeForLyrics
	 @abstract get a sscore_edit_type for lyrics
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForLyrics();
	
	/*!
	 @function sscore_edit_typeForPedal
	 @abstract get a sscore_edit_type for a pedal
	 @param type the pedal type
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForPedal(enum sscore_edit_pedal_type type);
	
	/*!
	 @function sscore_edit_typeForTuplet
	 @abstract get a sscore_edit_type for a tuplet
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForTuplet();
	
	/*!
	 @function sscore_edit_typeForArpeggiate
	 @abstract get a sscore_edit_type for an arpeggiate
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForArpeggiate();

	/*!
	 @function sscore_edit_typeForOctaveShift
	 @abstract get a sscore_edit_type for an octave shift
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForOctaveShift();

	/*!
	 @function sscore_edit_typeForFermata
	 @abstract get a sscore_edit_type for a fermata
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForFermata(bool inverted);

	/*!
	 @function sscore_edit_typeForSlide
	 @abstract get a sscore_edit_type for a slide
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForSlide();
	
	/*!
	 @function sscore_edit_typeForGlissando
	 @abstract get a sscore_edit_type for a glissando
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForGlissando();
	
	/*!
	 @function sscore_edit_typeForWedge
	 @abstract get a sscore_edit_type for a wedge ('hairpin')
	 @param tp cresc or dim
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForWedge(enum sscore_edit_wedge_type tp);

	/*!
	 @function sscore_edit_typeForSlur
	 @abstract get a sscore_edit_type for a slur
	 @param tp above or below
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForSlur(enum sscore_edit_bezier_type tp);
	
	/*!
	 @function sscore_edit_typeForTied
	 @abstract get a sscore_edit_type for a tied type
	 @param tp above or below
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeForTied(enum sscore_edit_bezier_type tp);

	/*!
	 @function sscore_edit_typeFor
	 @abstract get a sscore_edit_type for a basetype which requires no other distinction
	 @param btype the base type
	 @return the type info
	 */
	EXPORT sscore_edit_type sscore_edit_typeFor(enum sscore_edit_baseType btype);
	
	/*!
	 @function sscore_edit_invalidType
	 @abstract get an invalid sscore_edit_type
	 @discussion compare this with a return value to test if invalid
	 @return invalid sscore_edit_type
	 */
	EXPORT sscore_edit_type sscore_edit_invalidType();
	
	/*!
	 @function sscore_edit_typeIsValid
	 @abstract test type is valid
	 @return false if this type is invalid
	 */
	EXPORT bool sscore_edit_typeIsValid(const sscore_edit_type *type);
	
	/*!
	 @function sscore_edit_typeIsMultiple
	 @abstract test type is multiple (ie has start and stop - wedge, slur, tied etc.)
	 @return true if this type is is a multiple item
	 */
	EXPORT bool sscore_edit_typeIsMultiple(const sscore_edit_type *type);
	
	/*!
	 @function sscore_edit_baseTypeFor
	 @abstract get the sscore_edit_baseType for sscore_edit_type
	 @param tp type
	 @return base type
	 */
	EXPORT enum sscore_edit_baseType sscore_edit_baseTypeFor(const sscore_edit_type *tp);
	
	/*!
	 @function sscore_edit_internalSubTypeFor
	 @abstract internal use
	 @param tp type
	 @return subtype
	 */
	EXPORT unsigned sscore_edit_internalSubTypeFor(const sscore_edit_type *tp);
	
	/*!
	 @function sscore_edit_internalIntParamFor
	 @abstract internal use
	 @param tp type
	 @param index index of parameter (0..2)
	 @return int param
	 */
	EXPORT int sscore_edit_internalIntParamFor(const sscore_edit_type *tp, int index);
	
	/*!
	 @function sscore_edit_internalStrParamFor
	 @abstract internal use
	 @param tp type
	 @param buffer to take the parameter string
	 @param buffersize the size of the buffer
	 @return number of bytes copied to buffer
	 */
	EXPORT int sscore_edit_internalStrParamFor(const sscore_edit_type *tp, char *buffer, int buffersize);
	
	/*!
	 @function sscore_edit_symbolFor
	 @abstract get the sscore_symbol for a type
	 @param tp the type
	 @return the symbol for the given type
	 */
	EXPORT sscore_symbol sscore_edit_symbolFor(const sscore_edit_type *tp);
	
	/*!
	 @function sscore_edit_comp_isSelectable
	 @abstract can the component be selected? (true if editable, draggable or deleteable)
	 @param sys the system
	 @param comp the component
	 */
	EXPORT bool sscore_edit_comp_isSelectable(const sscore_system *sys, const sscore_component *comp);
	
	/*!
	 @function sscore_edit_comp_isEditable
	 @abstract can the component be edited? (eg text in direction, lyric or partname)
	 @param sys the system
	 @param comp the component
	 */
	EXPORT bool sscore_edit_comp_isEditable(const sscore_system *sys, const sscore_component *comp);

	/*!
	 @function sscore_edit_comp_isDraggable
	 @abstract can the component be dragged?
	 @param sys the system
	 @param comp the component
	 */
	EXPORT bool sscore_edit_comp_isDraggable(const sscore_system *sys, const sscore_component *comp);
	
	/*!
	 @function sscore_edit_comp_isDeleteable
	 @abstract can the component be deleted?
	 @param sys the system
	 @param comp the component
	 */
	EXPORT bool sscore_edit_comp_isDeleteable(const sscore_system *sys, const sscore_component *comp);

	/*!
	 @function sscore_edit_isValidItem
	 @return test valid returned sscore_edit_item
	 */
	EXPORT bool sscore_edit_isValidItem(const sscore_edit_item *item);

	/*!
	 @function sscore_edit_getItemForComponent
	 @abstract get the editable item from a layout component
	 @param score the score
	 @param sys the system
	 @param comp the component
	 @return the item or invalid (test sscore_edit_isValidItem())
	 */
	EXPORT sscore_edit_item sscore_edit_getItemForComponent(const sscore *score,
															const sscore_system *sys,
															const sscore_component *comp);
	/*!
	 @function sscore_edit_getItemForDirectionType
	 @abstract get the editable item for a direction-type from a direction
	 @param score the score
	 @param sys the system
	 @param dirtype the direction-type
	 @return the item or invalid (test sscore_edit_isValidItem())
	 */
	EXPORT sscore_edit_item sscore_edit_getItemForDirectionType(const sscore *score,
																const sscore_system *sys,
																const sscore_con_directiontype *dirtype);
	
	/*!
	 @function sscore_edit_nearestNoteInsertPos
	 @abstract get the nearest valid position to insert a (new) note or rest
	 @param score the score
	 @param system the system
	 @param target the target location in the system
	 @param itype the type (note or rest)
	 @return the nearest valid insert position in the system
	 */
	EXPORT sscore_edit_noteInsertPos sscore_edit_nearestNoteInsertPos(const sscore *score,
																	  const sscore_system *system,
																	  const sscore_edit_targetLocation *target,
																	  const sscore_edit_type *itype);

	/*!
	 @function sscore_edit_nearestTargetLocation
	 @abstract get a target location near to pos to insert an item of type itemType
	 @param score the score
	 @param system the system
	 @param itemType the type of object to insert
	 @param pos the position defining the target location
	 @param max_distance the furthest distance to accept the target
	 @return the target location nearest to pos which can receive the item of type itemType
	 */
	EXPORT sscore_edit_targetLocation sscore_edit_nearestTargetLocation(const sscore *score,
																		const sscore_system *system,
																		const sscore_edit_type *itemType,
																		const sscore_point *pos,
																		float max_distance);
	
	/*!
	 @function sscore_edit_nearestReinsertTargetLocation
	 @abstract get a target location near to pos to reinsert (drag-drop) the item
	 @param score the score
	 @param system the system
	 @param item the item to reinsert
	 @param pos the position defining the target location
	 @return the target location nearest to pos which can receive the item
	 */
	EXPORT sscore_edit_targetLocation sscore_edit_nearestReinsertTargetLocation(const sscore *score,
																				const sscore_system *system,
																				const sscore_edit_item *item,
																				const sscore_point *pos);

	/*!
	 @function sscore_edit_targetLocationForComponent
	 @abstract get a target location at a particular component
	 @param score the score
	 @param component any component
	 @return the target location aligned with the component
	 */
	EXPORT sscore_edit_targetLocation sscore_edit_targetLocationForComponent(const sscore *score,
																			const sscore_component *component);
	
	/*!
	 @function sscore_edit_targetLocationForNoteComponent
	 @abstract get a target location at a particular note
	 @param score the score
	 @param notecomponent a component identifying a note
	 @return the target location aligned with the note which can be used for inserting a notation on a particular note
	 */
	EXPORT sscore_edit_targetLocation sscore_edit_targetLocationForNoteComponent(const sscore *score,
																				 const sscore_component *notecomponent);
	
	/*!
	 @function sscore_edit_isValidInsertTargetForType
	 @abstract is the target location valid to insert the item type?
	 @discussion This returns true if a given type of item can be inserted in a particular location.
	 Compare sscore_edit_isValidReinsertTargetForItem which takes a sscore_edit_item instead of sscore_edit_type
	 @param score the score
	 @param itemType the type of object to insert
	 @param target the target to test
	 @return true if the target location is valid
	 */
	EXPORT bool sscore_edit_isValidInsertTargetForType(const sscore *score,
													   const sscore_edit_type *itemType,
													   const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_isValidMultiInsertTargetForType
	 @abstract is it valid to insert the multiple item type (eg slur, tied, wedge, repeat bars) at (left,right) targets?
	 @discussion This returns true if a given type of multiple item can be inserted in a particular pair of locations.
	 @param score the score
	 @param itemType the type of object to insert
	 @param target_left the left target
	 @param target_right the right target
	 @return true if the target locations are valid for insertion of the given type
	 */
	EXPORT bool sscore_edit_isValidMultiInsertTargetForType(const sscore *score,
															const sscore_edit_type *itemType,
															const sscore_edit_targetLocation *target_left,
															const sscore_edit_targetLocation *target_right);
	
	/*!
	 @function sscore_edit_isValidReinsertTargetForItem
	 @abstract can the existing item be reinserted at the target?
	 @discussion returns true if the existing item in the score can be relocated to the given target location
	 Compare sscore_edit_isValidInsertTargetForType which takes a sscore_edit_type instead of sscore_edit_item
	 @param score the score
	 @param item the item
	 @param target from sscore_edit_nearestTargetLocation()
	 @return true if this is a valid target for reinsertion of the item
	 */
	EXPORT bool sscore_edit_isValidReinsertTargetForItem(const sscore *score,
														 const sscore_edit_item *item,
														 const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_targetLocationIsValidForInsert
	 @deprecated use sscore_edit_isValidInsertTargetForType
	 @param score the score
	 @param system the system
	 @param itemType the type of object to insert
	 @param target the target to test
	 @return true if the target location is valid
	 */
	EXPORT __attribute__((deprecated)) bool sscore_edit_targetLocationIsValidForInsert(const sscore *score,
															const sscore_system *system,
															const sscore_edit_type *itemType,
														   const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_insertIsProvisory
	 @abstract is the item type not strictly required at the target location? (eg test for a cautionary accidental)
	 @param score the score
	 @param itemType the type of object to insert
	 @param target the target to test
	 @return true if the item would not be strictly required at the location but it can be inserted here
	 */
	EXPORT bool sscore_edit_insertIsProvisory(const sscore *score,
											  const sscore_edit_type *itemType,
											  const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_isBezier
	 @abstract is this a bezier type (ie tied or slur)?
	 @discussion  these can sometimies be treated as equivalent in the UI eg when dropping it can be dropped as a slur or tied
	 @param itemType the type of object
	 @return true if this is a bezier type - slur or tied
	 */
	EXPORT bool sscore_edit_isBezier(const sscore_edit_type *itemType);

	/*!
	 @function sscore_edit_canAddTiedToNotehead
	 @abstract test if we can add a valid tied pair from this note to a note on the right
	 @param score the score
	 @param target defines the notehead for the left of the tied pair
	 @return true if the notehead defined by target can be tied to another note on the right
	 */
	EXPORT bool sscore_edit_canAddTiedToNotehead(const sscore *score,
												 const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_tiedRect
	 @abstract bounding box for tie added to the right of this notehead
	 @param score the score
	 @param system the system
	 @param target defines the notehead for the left of the tied pair
	 @return bounding box of the potential tie to add to the right of this notehead
	 */
	EXPORT sscore_rect sscore_edit_tiedRect(const sscore *score,
											const sscore_system *system,
											const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_addTiedToNotehead
	 @abstract add a valid tied pair from this note to the same pitched note note on the right
	 @param score the score
	 @param target defines the notehead for the left of the tied pair
	 @return true if the tied pair of elements was added. NB It can only add a valid pair - never one element
	 */
	EXPORT bool sscore_edit_addTiedToNotehead(sscore *score,
											  const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationIsValid
	 @abstract is the target valid
	 @param target the target location
	 @return false for an undefined/invalid target
	 */
	EXPORT bool sscore_edit_targetLocationIsValid(const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationPartIndex
	 @abstract return the part index for the target
	 @param target the target to test
	 @return the part index for the target
	 */
	EXPORT int sscore_edit_targetLocationPartIndex(const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_targetLocationBarIndex
	 @abstract return the bar index for the target
	 @param target the target location
	 @return the bar index for the target
	 */
	EXPORT int sscore_edit_targetLocationBarIndex(const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationStaffIndex
	 @abstract return the staff index for the target [0..1] in the part. 0 is the top or only staff
	 @param target the target location
	 @return the staff index for the target
	 */
	EXPORT int sscore_edit_targetLocationStaffIndex(const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationNearestNoteHandle
	 @abstract return the closest note item handle for the target
	 @param target the target location
	 @return the closest note item handle for the target
	 */
	EXPORT sscore_item_handle sscore_edit_targetLocationNearestNoteHandle(const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationStaffLocation
	 @abstract return the staff-relative position for the given target location
	 @param target from sscore_edit_nearestTargetLocation()
	 @return sscore_system_stafflocation_e ie above/below staff
	 */
	EXPORT enum sscore_system_stafflocation_e sscore_edit_targetLocationStaffLocation(const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_targetLocationStaffLineSpaceIndex
	 @abstract return the staff line or space for the target
	 @param target from sscore_edit_nearestTargetLocation()
	 @return staff line/space (bottom line is 0, bottom space is 1, 2nd line is 2 etc)
	 */
	EXPORT int sscore_edit_targetLocationStaffLineSpaceIndex(const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationNoteheadStaffLineSpaceIndex
	 @abstract return the staff line/space of the target nearest notehead, 0 if nearest notehead is undefined
	 @param target the target location
	 @return the staff line/space for the target nearest notehead (bottom line is 0, bottom space is 1, 2nd line is 2 etc)
	 */
	EXPORT float sscore_edit_targetLocationNoteheadStaffLineSpaceIndex(const sscore_edit_targetLocation *target);

	/*!
	 @function sscore_edit_targetLocationTargetType
	 @abstract type of entity at the target location
	 @param target from sscore_edit_nearestTargetLocation()
	 @return target type
	 */
	EXPORT enum sscore_edit_targetType sscore_edit_targetLocationTargetType(const sscore_edit_targetLocation *target);
		
	/*!
	 @function sscore_edit_targetLocationCoord
	 @abstract return the (approximate) position for inserting the itemType at the target location in the system
	 @param score the score
	 @param system the system
	 @param itemType the type of the item
	 @param target from sscore_edit_nearestTargetLocation()
	 @return coordinates for the target
	 */
	EXPORT sscore_point sscore_edit_targetLocationCoord(const sscore *score,
														const sscore_system *system,
														const sscore_edit_type *itemType,
														const sscore_edit_targetLocation *target,
														enum sscore_edit_leftRightLocation lr);
	
	/*!
	 @function sscore_edit_dragHorizontally
	 @abstract is this an item in the score eg a wedge end which must be dragged only in x
	 @param type the type of the item
	 @return true for an item which can only vary in x (wedge,pedal..)
	 */
	EXPORT bool sscore_edit_dragHorizontally(const sscore_edit_type *type);
	
	/*!
	 @function sscore_edit_dragVertically
	 @abstract is this an item in the score eg a notehead which must be dragged only in y
	 @param type the type of the item
	 @return true for an item which can only vary in y
	 */
	EXPORT bool sscore_edit_dragVertically(const sscore_edit_type *type);
	
	/*!
	 @function sscore_edit_isBezierControl
	 @abstract is this a bezier control point?
	 @param item the item
	 @return true for a bezier control point (in a slur or tie)
	 */
	EXPORT bool sscore_edit_isBezierControl(const sscore_edit_item *item);
	
	/*!
	 @function sscore_edit_dragCanRepositionXMLElement
	 @abstract some items when dragged can cause a reordering of the XML, eg a wedge can be dragged to another note
	 @return true if a drag can cause an underlying XML element to be repositioned in the file, usually to link to another note.
	 */
	EXPORT bool sscore_edit_dragCanRepositionXMLElement(const sscore_edit_item *item);

	enum sscore_edit_default_type {
		sscore_edit_default_none,
		sscore_edit_default_x,
		sscore_edit_default_y,
		sscore_edit_default_xy,
		sscore_edit_relative_x,
		sscore_edit_relative_y,
		sscore_edit_relative_xy,
		sscore_edit_bezier_xy };
	
	/*!
	 @function sscore_edit_dragCanSet
	 @abstract can we set a default-x, default-y or relative-x, relative-y for this type?
	 @param item the item
	 @return the type of change which can result from dragging
	 */
	EXPORT enum sscore_edit_default_type sscore_edit_dragCanSet(const sscore_edit_item *item);
	
	/*!
	 @function sscore_edit_bezierOffsetForSystemPos
	 @abstract get the offset for a bezier control point drag from a system coordinate
	 @discussion result is passed to sscore_edit_offsetItem
	 @param system the system containing the bezier (tied or slur) which was dragged
	 @param item the item
	 @param pos the coord of the drop point of the bezier drag
	 @return the offset for the bezier from dragging to pass to sscore_edit_offsetItem
	 */
	EXPORT sscore_point sscore_edit_bezierOffsetForSystemPos(const sscore_system *system, const sscore_edit_item *item, const sscore_point *pos);

	/*!
	 @function sscore_edit_typeForEditItem
	 @abstract return the sscore_edit_type for the sscore_edit_item
	 @param item the item being edited
	 @return the type of the item
	 */
	EXPORT sscore_edit_type sscore_edit_typeForEditItem(const sscore_edit_item *item);
	
	/*!
	 @function sscore_edit_modifyPartName
	 @abstract modify the part name
	 @param score the score
	 @param item_h the handle for the part name to modify
	 @param name the new part name
	 @return true if success
	 */
	EXPORT bool sscore_edit_modifyPartName(sscore *score, sscore_item_handle item_h, const char *name);

	/*!
	 @function sscore_edit_nearestValidDragPoint
	 @abstract return the closest valid drag point to p
	 @param sys the system
	 @param item the item being dragged
	 @param p a point
	 @return the closest valid drag point to p
	 */
	EXPORT sscore_point sscore_edit_nearestValidDragPoint(const sscore_system *sys, const sscore_edit_item *item, const sscore_point *p);
	
	/*!
	 @function sscore_edit_system_drawDragItem
	 @abstract draw the current dragging state of an existing item in the system
	 @discussion this is called when we are live-dragging an existing item eg a control point of a slur
	 @param graphics the graphics context
	 @param score the score
	 @param sys the system
	 @param tl the system top left coord
	 @param item the item being dragged
	 @param target details (bar, staff, staff line etc.) of the target location of the drag
	 @param p the x,y position
	 */
	EXPORT void sscore_edit_system_drawDragItem(sscore_graphics *graphics,
												const sscore *score,
												const sscore_system *sys,
												const sscore_point *tl,
												const sscore_edit_item *item,
												const sscore_edit_targetLocation *target,
												const sscore_point *p);

	/*!
	 @function sscore_edit_dropItem
	 @deprecated should use sscore_edit_offsetItem instead
	 @abstract drop an existing item which was being dragged (eg a slur bezier control point)
	 @param score the score
	 @param sys the system
	 @param item the item being dragged
	 @param p the x,y position
	 @return true if succeeded
	 */
	EXPORT __attribute__((deprecated)) bool sscore_edit_dropItem(sscore *score,
																 const sscore_system *sys,
																 const sscore_edit_item *item,
																 const sscore_point *p);

	/*!
	 @function sscore_edit_getInsertInfo
	 @abstract create sscore_edit_insertInfo to pass to sscore_edit_insertitem to insert a new item in the score
	 @param score the score
	 @param type the sscore_edit_type to insert, returned from sscore_edit_typeFor...
	 @param detailinfo detailed info about the object, can be NULL
	 @return the sscore_edit_insertInfo to pass to sscore_edit_insertitem
	 */
	EXPORT sscore_edit_insertInfo sscore_edit_getInsertInfo(const sscore *score,
															const sscore_edit_type *type,
															const sscore_edit_detailInfo *detailinfo);
	
	/*!
	 @function sscore_edit_insertItemType
	 @abstract return item type from the sscore_edit_insertInfo
	 @param info the sscore_edit_insertInfo from sscore_edit_getInsertInfo
	 @return the sscore_edit_type of the item
	 */
	EXPORT sscore_edit_type sscore_edit_insertItemType(const sscore_edit_insertInfo *info);
	
	/*!
	 @function sscore_edit_getTextDetailInfo
	 @abstract load sscore_edit_detailInfo with font information
	 @param name a font name (ignored by SeeScore display), can be NULL to leave unspecified
	 @param bold true for bold text
	 @param italic true for italic text
	 @return sscore_edit_detailInfo
	 */
	EXPORT sscore_edit_detailInfo sscore_edit_getTextDetailInfo(const char *name, bool bold, bool italic);
	
	/*!
	 @function sscore_edit_getClefReplacementDetailInfo
	 @abstract load sscore_edit_detailInfo with pinNotes flag so it can be passed to sscore_edit_getInsertInfo.
	 @discussion If pinNotes is set the notes are pinned to the staff when the clef is replaced and thus their pitches change,
	 otherwise the pitches are constant and they change position on the staff
	 Notes must be pinned when changing a clef that was incorrectly read by OMR.
	 @param pinNotes true to pin notes to the staff
	 @return sscore_edit_detailInfo to pass to sscore_edit_getInsertInfo
	 */
	EXPORT sscore_edit_detailInfo sscore_edit_getClefReplacementDetailInfo(bool pinNotes);
	
	/*!
	 @function sscore_edit_getKeyReplacementDetailInfo
	 @abstract load sscore_edit_detailInfo with preserveAccidentals flag so it can be passed to sscore_edit_getInsertInfo.
	 @discussion If preserveAccidentals is set the pitches of notes are adjusted to keep the accidentals unchanged after a key change
	 otherwise the pitches are constant and accidentals are added as required by the key.
	 preserveAccidentals must be set when changing a key that was incorrectly read by OMR.
	 @param preserveAccidentals true to preserve accidentals by changing note pitches (default is false)
	 @return sscore_edit_detailInfo to pass to sscore_edit_getInsertInfo
	 */
	EXPORT sscore_edit_detailInfo sscore_edit_getKeyReplacementDetailInfo(bool preserveAccidentals);
		
	/*!
	 @function sscore_edit_getTextInsertInfo
	 @abstract create sscore_edit_insertInfo to pass to sscore_edit_insertitem for direction.direction-type.words or lyric
	 @param score the score
	 @param type the type (direction-type words or lyric)
	 @param vloc if above place the text above the staff. If below place the text below the note
	 @param text_utf8 the text for new direction words element or lyric
	 @param textType the type of text (direction only).
	 @param fontinfo specifies the font information - NULL to use default font style based on textType
	 @return the sscore_edit_insertInfo to pass to sscore_edit_insertitem
	 */
	EXPORT sscore_edit_insertInfo sscore_edit_getTextInsertInfo(const sscore *score,
																const sscore_edit_type *type,
																enum sscore_system_stafflocation_e vloc,
																const char *text_utf8,
																enum sscore_edit_textType textType,
																const sscore_edit_fontInfo *fontinfo); // NULLABLE
	
	/*!
	 @function sscore_edit_direction_modifyWords
	 @abstract modify existing text (direction-type words)
	 @param score the score
	 @param directionType the direction-type element containing the words to edit
	 @param text_utf8 the text to insert - NULL to leave unchanged
	 @param fontinfo font parameters - NULL to leave unchanged
	 @return true if succeeded
	 */
	EXPORT bool sscore_edit_direction_modifyWords(sscore *score,
												  const sscore_con_directiontype *directionType,
												  const char *text_utf8, // NULLABLE
												  const sscore_edit_fontInfo *fontinfo); // NULLABLE

	/*!
	 @function sscore_edit_direction_words_getFontInfo
	 @abstract get font information from the given direction-type words
	 @param score the score
	 @param directionType the direction-type element containing the words
	 @return font info
	 */
	EXPORT sscore_edit_fontInfo sscore_edit_direction_words_getFontInfo(sscore *score,
																		const sscore_con_directiontype *directionType);
	
	/*!
	 @function sscore_edit_lyricAtTarget
	 @abstract get lyric for note at target
	 @param score the score
	 @param target the target defining a note
	 @param lyricLine the lyric line
	 @return lyric info
	 */
	EXPORT sscore_con_lyric sscore_edit_lyricAtTarget(const sscore *score, const sscore_edit_targetLocation *target, int lyricLine);

	/*!
	 @function sscore_edit_addLyric
	 @abstract add a lyric to the note
	 @param score the score
	 @param partIndex the part index containing the note
	 @param barIndex the bar index containing the note
	 @param staffIndex the staff index containing the note (0 is top or only)
	 @param lyricLineIndex the lyric line index (0 is top or only)
	 @param note_h the unique note handle
	 @param text_utf8 the text for the lyric
	 @param linkNextSyllable if true we treat this as a syllable in a word to be linked to the following lyric with dashes
	 @return true if success
	 */
	EXPORT bool sscore_edit_addLyric(sscore *score,
									 int partIndex, int barIndex, int staffIndex, int lyricLineIndex, sscore_item_handle note_h,
									 const char *text_utf8,
									 bool linkNextSyllable);
	/*!
	 @function sscore_edit_modifyLyric
	 @abstract modify the lyric text or syllabic
	 @param score the score
	 @param lyric the lyric from sscore_con_getlyric (sscore_contents.h)
	 @param new_text_utf8 the new text for the lyric, or "" or NULL for no change
	 @param linkNextSyllable if true we treat this as a syllable in a word to be linked to the following lyric with dashes
	 @return true if success
	 */
	EXPORT bool sscore_edit_modifyLyric(sscore *score,
										const sscore_con_lyric *lyric,
										const char *new_text_utf8,
										bool linkNextSyllable);

	/*!
	 @function sscore_edit_insertItem
	 @abstract attempt to insert the item in the score
	 @param score the score
	 @param item info about the item to insert
	 @param target info about the logical position in the score where it should be inserted
	 @return true if success
	 */
	EXPORT bool sscore_edit_insertItem(sscore *score,
									   const sscore_edit_insertInfo *item,
									   const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_insertMultiItem
	 @abstract attempt to insert a left/right item in the score (eg slur, tied, wedge, tuplet etc)
	 @param score the score
	 @param item info about the item to insert
	 @param target_left info about the logical position in the score where the left side of the item should be placed
	 @param target_right info about the logical position in the score where the right side of the item should be placed
	 @return true if success
	 */
	EXPORT bool sscore_edit_insertMultiItem(sscore *score,
											const sscore_edit_insertInfo *item,
											const sscore_edit_targetLocation *target_left,
											const sscore_edit_targetLocation *target_right);
	
	/*!
	 @function sscore_edit_offsetItem
	 @abstract attempt to offset the item in the score, setting the default-x,default-y or bezier attributes
	 @discussion currently only applicable to slur or tied bezier control points
	 @param score the score
	 @param item the item to reinsert
	 @param offset the x,y offset (returned from sscore_edit_bezierOffsetForSystemPos)
	 @return true if success
	 */
	EXPORT bool sscore_edit_offsetItem(sscore *score,
										const sscore_edit_item *item,
										const sscore_point *offset);
	
	/*!
	 @function sscore_edit_reinsertItem
	 @abstract attempt to reinsert the item in the score, eg for a note this is used to change the pitch when dragged up or down
	 @param score the score
	 @param item the item to reinsert
	 @param target info about the logical position in the score where it should be reinserted
	 @return true if success
	 */
	EXPORT bool sscore_edit_reinsertItem(sscore *score,
										 const sscore_edit_item *item,
										 const sscore_edit_targetLocation *target);
	
	/*!
	 @function sscore_edit_deleteItem
	 @abstract remove an item from the score
	 @param sc the score
	 @param item the item to delete from the score
	 @return true if succeeded, or false with nothing changed if the item was not found
	 */
	EXPORT bool sscore_edit_deleteItem(sscore *sc, const sscore_edit_item *item);
	
	/*!
	 @function sscore_edit_setDotCount
	 @abstract set the number of dots (0,1,2) for the note or rest
	 @param sc the score
	 @param partIndex the part index [0..]
	 @param barIndex the bar index [0..]
	 @param item_h the item handle
	 @param numdots the number of dots for the note or rest
	 @return true if succeeded, or false with nothing changed if the item was not found or it already has numdots dots
	 */
	EXPORT bool sscore_edit_setDotCount(sscore *sc, int partIndex, int barIndex, sscore_item_handle item_h, int numdots);

	/*!
	 @function sscore_edit_insertBar
	 @abstract insert a bar in all parts containing a single whole-bar rest in each staff
	 @param beforeBarIndex the index of the bar to insert before. Set to numBars to add bar at the end, 0 to add at the beginning
	 @param withRest if true add a whole-bar rest to the bar
	 @return true if succeeded
	 */
	EXPORT bool sscore_edit_insertBar(sscore *sc, int beforeBarIndex, bool withRest);
	
	/*!
	 @function sscore_edit_deleteBar
	 @abstract remove a bar (in all parts)
	 @param barIndex the index of the bar to remove before. 0 is the first bar
	 @return true if succeeded
	 */
	EXPORT bool sscore_edit_deleteBar(sscore *sc, int barIndex);
	
	/*!
	 @function sscore_edit_removeEmptyBars
	 @abstract remove all bars which contain nothing in the score
	 @return true if removed any bars
	 */
	EXPORT bool sscore_edit_removeEmptyBars(sscore *sc);

#pragma clang diagnostic pop

#ifdef __cplusplus
}
#endif

#endif
