//
//  sscore_sym.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_sym_h
#define SeeScoreLib_sscore_sym_h

#include "sscore.h"
#include "sscore_contents.h"
#include "sscore_edit.h"

#ifdef __cplusplus
extern "C" {
#endif

	/*! @header
	 The C interface to measure and draw the SeeScoreLib built-in symbols
	 */
	
	/*!
	 @typedef sscore_symbol
	 @abstract a symbol to draw
	 */
#ifndef SSCORE_SYM_DEF
#define SSCORE_SYM_DEF
	typedef unsigned sscore_symbol;
#endif
	
	/*!
	 @define sscore_sym_invalid
	 @abstract an invalid value for sscore_symbol
	 */
#define sscore_sym_invalid 0
	
	//enum sscore_sym_drawopt_flags {/*none defined  yet*/};
	
	/*!
	 @struct sscore_symbol_drawoptions
	 @abstract options for sscore_sym_draw
	 @discussion should be cleared to zero
	 */
	typedef struct sscore_sym_drawoptions
	{
		unsigned flags;
		unsigned dummy[64];
	} sscore_sym_drawoptions;
	
	/*!
	 @enum sscore_sym_notehead_placement_e
	 @abstract on staff line or in space?
	 */
	enum sscore_sym_notehead_placement_e {sscore_sym_notehead_online, sscore_sym_notehead_inspace};
	
	/*!
	 @struct sscore_sym_ledgers
	 @abstract describe ledgers on note
	 @discussion the ledgers are drawn above (if note is below staff) or below (if note is above the staff) the notehead
	 */
	typedef struct sscore_sym_ledgers
	{
		int num;	// number of ledgers
		enum sscore_system_stafflocation_e staff_placement; // ledgers above or below staff
		enum sscore_sym_notehead_placement_e notehead_placement; // notehead in space or on line
	} sscore_sym_ledgers;
	
	/*!
	 @function sscore_sym_bb
	 @abstract get the default bounding box of a symbol
	 @param graphics the graphics context
	 @param symbol the symbol
	 @param opt the options for drawing or NULL
	 @return the bounding box of the symbol
	 */
	EXPORT sscore_rect sscore_sym_bb(sscore_graphics *graphics, sscore_symbol symbol,
									 const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_draw
	 @abstract draw a symbol
	 @param graphics the graphics context
	 @param symbol the symbol
	 @param origin the position at which to draw the origin of the symbol
	 @param width the width to draw the symbol
	 @param height the height to draw the symbol or 0 to use default aspect
	 @param opt the options for drawing or NULL
	 @param colour the colour to draw the symbol
	 */
	EXPORT void sscore_sym_draw(sscore_graphics *graphics,
								sscore_symbol symbol,
								const sscore_point *origin,
								float width, float height,
								const sscore_sym_drawoptions *opt,
								const sscore_colour_alpha *colour);
	
	/*!
	 @function sscore_sym_draw_svg
	 @abstract draw an svg string (NB syntax not completely generic)
	 @param graphics the graphics context
	 @param origin the position to draw the origin of the bounding rectangle
	 @param opt draw options, currently unused, may be NULL
	 */
	EXPORT void sscore_sym_draw_svg(sscore_graphics *graphics,
									const char *svg,
									const sscore_point *origin,
									float height,
									float scale_x, float scale_y,
									const sscore_sym_drawoptions *opt,
									const sscore_colour_alpha *fgColour);
	
	/*!
	 @function sscore_sym_note_bb
	 @abstract return the bounding box for a note
	 @param graphics the graphics context
	 @param value the type of note
	 @param numDots the number of dots (0, 1 or 2)
	 @param stem the stem direction
	 @param ledgers info about number of ledgers and placement
	 @param opt draw options, currently unused, may be NULL
	 */
	EXPORT sscore_rect sscore_sym_note_bb(sscore_graphics *graphics,
										  enum sscore_note_value_e value,
										  int numDots,
										  enum sscore_note_stem_e stem,
										  const sscore_sym_ledgers *ledgers,
										  const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_note_draw
	 @param graphics the graphics context
	 @param value the note value
	 @param numDots 0, 1 or 2 for the number of dots
	 @param stem the type of stem (ignored for unstemmed value)
	 @param ledgers info about number of ledgers and placement
	 @param origin the position to draw the note
	 @param scale the scaling
	 @param opt the draw options
	 @param colour the fill colour
	 */
	EXPORT void sscore_sym_note_draw(sscore_graphics *graphics,
									 enum sscore_note_value_e value,
									 int numDots,
									 enum sscore_note_stem_e stem,
									 const sscore_sym_ledgers *ledgers,
									 const sscore_point *origin,
									 float scale,
									 const sscore_sym_drawoptions *opt,
									 const sscore_colour_alpha *colour);

	/*!
	 @function sscore_sym_keysig_bb
	 @abstract get the bounding box of the key signature to be drawn by sscore_sym_keysig_draw
	 @param graphics the graphics context
	 @param fifths 0=> no sharps or flats, +ve is number of sharps, -ve is number of flats
	 @param opt draw options, currently unused, may be NULL
	 @return rectangle
	 */
	EXPORT sscore_rect sscore_sym_keysig_bb(sscore_graphics *graphics,
											int fifths,
											const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_keysig_draw
	 @abstract draw a key signature
	 @param graphics the graphics context
	 @param fifths 0=> no sharps or flats, +ve is number of sharps, -ve is number of flats
	 @param origin the position to draw the origin of the bounding rectangle
	 @param opt draw options, currently unused, may be NULL
	 */
	EXPORT void sscore_sym_keysig_draw(sscore_graphics *graphics,
									   int fifths,
									   enum sscore_clef_type_e clef,
									   const sscore_point *origin,
									   float scale_x, float scale_y,
									   const sscore_sym_drawoptions *opt,
									   const sscore_colour_alpha *colour);
	
	/*!
	 @function sscore_sym_timesig_bb
	 @abstract get the bounding box of the time signature to be drawn by sscore_sym_timesig_draw
	 @param graphics the graphics context
	 @param type the type of time signature
	 @param beats the number of beats (upper number)
	 @param beattype the note type (lower number)
	 @param opt draw options, currently unused, may be NULL
	 @return rectangle
	 */
	EXPORT sscore_rect sscore_sym_timesig_bb(sscore_graphics *graphics,
											 enum sscore_timesig_type type, int beats, int beattype,
											 const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_timesig_draw
	 @abstract draw a time signature
	 @param graphics the graphics context
	 @param type the type of time signature
	 @param beats the number of beats (upper number)
	 @param beattype the note type (lower number)
	 @param origin the position to draw the origin of the bounding rectangle
	 @param scale_x the x-scaling - can squash symbol to fit on an angled ui plane
	 @param scale_y the y-scaling - can squash symbol to fit on an angled ui plane
	 @param opt draw options, currently unused, may be NULL
	 @param colour the colour
	 */
	EXPORT void sscore_sym_timesig_draw(sscore_graphics *graphics,
									   enum sscore_timesig_type type, int beats, int beattype,
									   const sscore_point *origin,
									   float scale_x, float scale_y,
									   const sscore_sym_drawoptions *opt,
									   const sscore_colour_alpha *colour);
	
	/*!
	 @function sscore_sym_placedclef_bb
	 @abstract get the bounding box of the clef-on-staff to be drawn by sscore_sym_placedclef_draw
	 @param graphics the graphics context
	 @param clef the clef
	 @param opt draw options, currently unused, may be NULL
	 @return rectangle
	 */
	EXPORT sscore_rect sscore_sym_placedclef_bb(sscore_graphics *graphics,
											 enum sscore_clef_type_e clef,
											 const sscore_sym_drawoptions *opt);

	
	/*!
	 @function sscore_sym_placedclef_draw
	 @abstract draw a clef on a staff (for UI menu selection)
	 @param graphics the graphics context
	 @param clef the clef
	 @param origin the position to draw the origin of the bounding rectangle
	 @param scale_x the x-scaling - can squash symbol to fit on an angled ui plane
	 @param scale_y the y-scaling - can squash symbol to fit on an angled ui plane
	 @param opt draw options, currently unused, may be NULL
	 @param colour the colour
	 */
	EXPORT void sscore_sym_placedclef_draw(sscore_graphics *graphics,
										   enum sscore_clef_type_e clef,
										   const sscore_point *origin,
										   float scale_x, float scale_y,
										   const sscore_sym_drawoptions *opt,
										   const sscore_colour_alpha *colour);

	/*!
	 @function sscore_sym_metronome_bb
	 @abstract bounding box for metronome mark
	 @param graphics the graphics context
	 @param noteType the note type (4 = crotchet)
	 @param dots any dots on note
	 @param bpm the beats-per-minute value
	 @param opt draw options, currently unused, may be NULL
	 @return bounding box for metronome mark
	 */
	EXPORT sscore_rect sscore_sym_metronome_bb(sscore_graphics *graphics,
											   int noteType, int dots, int bpm,
											   const sscore_sym_drawoptions *opt);

	/*!
	 @function sscore_sym_metronome_draw
	 @abstract draw a metronome mark (<note symbol> = <number>)
	 @param graphics the graphics context
	 @param noteType the note type (4 = crotchet)
	 @param dots any dots on note
	 @param bpm the beats-per-minute value
	 @param origin the position to draw the origin of the bounding rectangle
	 @param scale the scaling
	 @param opt draw options, currently unused, may be NULL
	 @param colour the colour
	 */
	EXPORT void sscore_sym_metronome_draw(sscore_graphics *graphics,
										  int noteType, int dots, int bpm,
										  const sscore_point *origin,
										  float scale,
										  const sscore_sym_drawoptions *opt,
										  const sscore_colour_alpha *colour);

	/*!
	 @function sscore_sym_text_bb
	 @abstract get the bounding box of the text
	 @param graphics the graphics context
	 @param text the text
	 @param textType the type of the text direction words
	 @param opt draw options, currently unused, may be NULL
	 @return the bounding box of the text
	 */
	EXPORT sscore_rect sscore_sym_text_bb(sscore_graphics *graphics,
										  const char *text,
										  enum sscore_edit_textType textType,
										  const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_text_draw
	 @abstract draw text
	 @param graphics the graphics context
	 @param text the text
	 @param textType the type of the text direction words, determining the default font and style
	 @param origin the position to draw the origin of the bounding rectangle
	 @param scale the scaling
	 @param opt draw options, currently unused, may be NULL
	 @param colour the colour
	 */
	EXPORT void sscore_sym_text_draw(sscore_graphics *graphics,
									 const char *text,
									 enum sscore_edit_textType textType,
									 const sscore_point *origin,
									 float scale,
									 const sscore_sym_drawoptions *opt,
									 const sscore_colour_alpha *colour);
	

	/*!
	 @function sscore_sym_bar_bb
	 @abstract get the bounding box of the dummy empty bar
	 @param graphics the graphics context
	 @param type the type of bar
	 @param opt draw options, currently unused, may be NULL
	 @return the bounding box of the barline or empty bar
	 */
	EXPORT sscore_rect sscore_sym_bar_bb(sscore_graphics *graphics,
											enum sscore_edit_bar_type type,
											const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_bar_draw
	 @abstract draw dummy empty bar
	 @param graphics the graphics context
	 @param type the bar type
	 @param origin the position to draw the origin of the bounding rectangle
	 @param scale the scaling
	 @param opt draw options, currently unused, may be NULL
	 @param colour the colour
	 */
	EXPORT void sscore_sym_bar_draw(sscore_graphics *graphics,
										enum sscore_edit_bar_type type,
										const sscore_point *origin,
										float scale,
										const sscore_sym_drawoptions *opt,
										const sscore_colour_alpha *colour);
	/*!
	 @function sscore_sym_barline_bb
	 @abstract get the bounding box of the barline
	 @param graphics the graphics context
	 @param type the type of barline
	 @param opt draw options, currently unused, may be NULL
	 @return the bounding box of the barline or empty bar
	 */
	EXPORT sscore_rect sscore_sym_barline_bb(sscore_graphics *graphics,
											 enum sscore_edit_barline_type type,
											 const sscore_sym_drawoptions *opt);
	
	/*!
	 @function sscore_sym_barline_draw
	 @abstract draw barline
	 @param graphics the graphics context
	 @param type the barline type
	 @param origin the position to draw the origin of the bounding rectangle
	 @param scale the scaling
	 @param opt draw options, currently unused, may be NULL
	 @param colour the colour
	 */
	EXPORT void sscore_sym_barline_draw(sscore_graphics *graphics,
										enum sscore_edit_barline_type type,
										const sscore_point *origin,
										float scale,
										const sscore_sym_drawoptions *opt,
										const sscore_colour_alpha *colour);
	
#ifdef __cplusplus
}
#endif

#endif /* sscore_sym_h */
