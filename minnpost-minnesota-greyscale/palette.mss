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

/* Desaturate amount */
@da: 100%;

/* ================================================================== */
/* LANDUSE & LANDCOVER COLORS
/* ================================================================== */

@map-base:          transparent;
@non-mn-land:       transparent;

@land:              desaturate(#FBFBFB, @da);
@mn-outline:        desaturate(#444444, @da);

@water:             desaturate(#ADD7F5, @da);

@grass:             desaturate(#95E425, @da);
@park:              desaturate(#ABEA53, @da);
@wooded:            desaturate(#A6E949, @da);

@agriculture:       desaturate(#EFAE80, @da);
@beach:             desaturate(#F4EEA9, @da);

@cemetery:          desaturate(#D6DED2, @da);
@building:          desaturate(#E4E0E0, @da);

@hospital:          desaturate(#F5ADB3, @da);
@school:            desaturate(#F5CBAD, @da);
@sports:            desaturate(#F5EFAD, @da);

@residential:       desaturate(@land * 0.98, @da);
@commercial:        desaturate(@land * 0.97, @da);
@industrial:        desaturate(@land * 0.96, @da);
@parking:           desaturate(#EEE, @da);

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

@motorway_line:     desaturate(lighten(#68330D, 50%), @da);
@motorway_fill:     lighten(@motorway_line,10%);
@motorway_case:     @motorway_line * 0.9;

@trunk_line:        desaturate(lighten(#7F3E10, 50%), @da);
@trunk_fill:        lighten(@trunk_line,10%);
@trunk_case:        @trunk_line * 0.9;

@primary_line:      desaturate(lighten(#E47525, 20%), @da);
@primary_fill:      lighten(@primary_line,10%);
@primary_case:      @primary_line * 0.9;

@secondary_line:    desaturate(lighten(#EB975C, 20%), @da);
@secondary_fill:    lighten(@secondary_line,10%);
@secondary_case:    @secondary_line * 0.9;

@standard_line:     @land * 0.85;
@standard_fill:     desaturate(#fff, @da);
@standard_case:     @land * 0.9;

@pedestrian_line:   @standard_line;
@pedestrian_fill:   desaturate(#FAFAF5, @da);
@pedestrian_case:   @land;

@cycle_line:        @standard_line;
@cycle_fill:        desaturate(#FAFAF5, @da);
@cycle_case:        @land;

@rail_line:         desaturate(#999, @da);
@rail_fill:         desaturate(#fff, @da);
@rail_case:         @land;

@aeroway:           desaturate(#ddd, @da);

/* ================================================================== */
/* BOUNDARY COLORS
/* ================================================================== */

@admin_2:           desaturate(#10197F, @da);

/* ================================================================== */
/* LABEL COLORS
/* ================================================================== */

/* We set up a default halo color for places so you can edit them all
   at once or override each individually. */
@place_halo:        fadeout(#fff,34%);

@country_text:      desaturate(#10197F, @da);
@country_halo:      @place_halo;

@state_text:        desaturate(#0A3452, @da);
@state_halo:        @place_halo;

@city_text:         #444;
@city_halo:         @place_halo;

@town_text:         #666;
@town_halo:         @place_halo;

@poi_text:          #888;

@road_text:         #777;
@road_halo:         #fff;

@other_text:        #888;
@other_halo:        @place_halo;

@locality_text:     #aaa;
@locality_halo:     @land;

/* Also used for other small places: hamlets, suburbs, localities */
@village_text:      #888;
@village_halo:      @place_halo;

/* ****************************************************************** */



