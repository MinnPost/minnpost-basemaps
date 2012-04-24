/* ****************************************************************** */
/* OSM BRIGHT for Imposm                                              */
/* ****************************************************************** */

/* For basic style customization you can simply edit the colors and
 * fonts defined in this file. For more detailed / advanced
 * adjustments explore the other files.
 *
 * GENERAL NOTES
 *
 * There is a slight performance cost in rendering line-caps.  An
 * effort has been made to restrict line-cap definitions to styles
 * where the results will be visible (lines at least 2 pixels thick).
 */


/* ================================================================== */
/* FONTS
/* ================================================================== */

/* directory to load fonts from in addition to the system directories */
Map { font-directory: url(./fonts); }

/* set up font sets for various weights and styles */
@sans_lt:           "Helvetica Light", "Open Sans Regular","DejaVu Sans Book","unifont Medium";
@sans:              "Helvetica Regular", "Open Sans Semibold","DejaVu Sans Book","unifont Medium";
@sans_bold:         "Helvetica Bold", "Open Sans Bold","DejaVu Sans Bold","unifont Medium";
@sans_italic:       "Helvetica Neue Italic", "Open Sans Semibold Italic","DejaVu Sans Italic","unifont Medium";
@sans_bold_italic:  "Helvetica Neue Bold Italic", "Open Sans Bold Italic","DejaVu Sans Bold Italic","unifont Medium";

/* Some fonts are larger or smaller than others. Use this variable to
   globally increase or decrease the font sizes. */
/* Note this is only implemented for certain things so far */
@text_adjust: 2;

/* ================================================================== */
/* LANDUSE & LANDCOVER COLORS
/* ================================================================== */

@map-base:          transparent;
@non-mn-land:       transparent;

@land:              desaturate(#FFFFFF - #FBFBFB, 95%);
@mn-outline:        desaturate(#FFFFFF - #444444, 95%);

@water:             desaturate(#FFFFFF - #ADD7F5, 95%);

@grass:             desaturate(#FFFFFF - #95E425, 95%);
@park:              desaturate(#FFFFFF - #ABEA53, 95%);
@wooded:            desaturate(#FFFFFF - #A6E949, 95%);

@agriculture:       desaturate(#FFFFFF - #EFAE80, 95%);
@beach:             desaturate(#FFFFFF - #F4EEA9, 95%);

@cemetery:          desaturate(#FFFFFF - #D6DED2, 95%);
@building:          desaturate(#FFFFFF - #E4E0E0, 95%);

@hospital:          desaturate(#FFFFFF - #F5ADB3, 95%);
@school:            desaturate(#FFFFFF - #F5CBAD, 95%);
@sports:            desaturate(#FFFFFF - #F5EFAD, 95%);

@residential:       @land * 0.98;
@commercial:        @land * 0.97;
@industrial:        @land * 0.96;
@parking:           desaturate(#FFFFFF - #EEE, 95%);

/* ================================================================== */
/* ROAD COLORS
/* ================================================================== */

/* For each class of road there are three color variables:
 * - line: for lower zoomlevels when the road is represented by a
 *         single solid line.
 * - case: for higher zoomlevels, this color is for the road's
 *         casing (outline).
 * - fill: for higher zoomlevels, this color is for the road's
 *         inner fill (inline).
 */

@motorway_line:     desaturate(#FFFFFF - #68330D, 95%);
@motorway_fill:     lighten(@motorway_line,10%);
@motorway_case:     @motorway_line * 0.9;

@trunk_line:        desaturate(#FFFFFF - #7F3E10, 95%);
@trunk_fill:        lighten(@trunk_line,10%);
@trunk_case:        @trunk_line * 0.9;

@primary_line:      desaturate(#FFFFFF - #E47525, 95%);
@primary_fill:      lighten(@primary_line,10%);
@primary_case:      @primary_line * 0.9;

@secondary_line:    desaturate(#FFFFFF - #EB975C, 95%);
@secondary_fill:    lighten(@secondary_line,10%);
@secondary_case:    @secondary_line * 0.9;

@standard_line:     @land * 0.85;
@standard_fill:     desaturate(#FFFFFF - #fff, 95%);
@standard_case:     @land * 0.9;

@pedestrian_line:   @standard_line;
@pedestrian_fill:   desaturate(#FFFFFF - #FAFAF5, 95%);
@pedestrian_case:   @land;

@cycle_line:        @standard_line;
@cycle_fill:        desaturate(#FFFFFF - #FAFAF5, 95%);
@cycle_case:        @land;

@rail_line:         desaturate(#FFFFFF - #999, 95%);
@rail_fill:         desaturate(#FFFFFF - #fff, 95%);
@rail_case:         @land;

@aeroway:           desaturate(#FFFFFF - #ddd, 95%);

/* ================================================================== */
/* BOUNDARY COLORS
/* ================================================================== */

@admin_2:           desaturate(#FFFFFF - #10197F, 95%);

/* ================================================================== */
/* LABEL COLORS
/* ================================================================== */

/* We set up a default halo color for places so you can edit them all
   at once or override each individually. */
@place_halo:        fadeout(#FFFFFF - #fff, 34%);

@country_text:      desaturate(#FFFFFF - #10197F, 95%);
@country_halo:      @place_halo;

@state_text:        desaturate(#FFFFFF - #0A3452, 95%);
@state_halo:        @place_halo;

@city_text:         #FFFFFF - #444;
@city_halo:         @place_halo;

@town_text:         #FFFFFF - #666;
@town_halo:         @place_halo;

@poi_text:          #FFFFFF - #888;

@road_text:         #FFFFFF - #777;
@road_halo:         #FFFFFF - #fff;

@other_text:        #FFFFFF - #888;
@other_halo:        @place_halo;

@locality_text:     #FFFFFF - #aaa;
@locality_halo:     @land;

/* Also used for other small places: hamlets, suburbs, localities */
@village_text:      #FFFFFF - #888;
@village_halo:      @place_halo;

/* ****************************************************************** */



