//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    stubby-wrench.scad
// Project: Stubby Wrench
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Creates a stubby wrench (quarter inch hex bit handle)
//

include <MCAD/units.scad>
use <MCAD/regular_shapes.scad>

include <Round-Anything/polyround.scad>

include <smidge.scad>;
include <slanted.scad>
include <flat-knurled.scad>

// hex_flats_to_radius:
//
// Hexagon flats to radius.
//
function hex_flats_to_radius( across_flats ) = across_flats/2/cos(30);

// percentage:
//
// Convert percentage to number
//
function percentage( v, p ) = v * p / 100;

/* [General] */

top_roundover_radius = 0.8;

transition_roundover_radius = 0.8;

end_roundover_radius = 2.0;

poly_iter = 10;

/* [Handle] */

// Handle style
handle_style = "smooth"; // [ "ellipse", "hard", "smooth" ]

// Handle length (mm)
handle_length = 64;

// Handle width (mm)
handle_width = 20;

// Handle height (mm)
handle_height = 15;

// Overall handle size
handle_size = [ handle_length, handle_width, handle_height ];

// Chamfer width (percentage of handle height)
handle_chamfer_percent = 24;

// Chamfer angle (degrees)
handle_chamfer_angle = 45;

// Handle width at end (percentage of handle width)
handle_end_width_percent = 40; // [15:1:100]

// Handle angle to elliptical center (degrees)
handle_theta = 40; // [ 10:1:80 ]

/* [Pads] */

// Pad style
pad_style = "knurl"; // [ "none", "outline", "inset", "outset", "knurl-inset", "knurl-outset", "knurl" ]

// Pad height (percentage of non-chamfered handle side)
pad_height_percent = 80; // [10:1:100]

// Pad width (percentage of handle side)
pad_width_percent = 65; // [10:1:66]

// Pad depth (mm)
pad_depth = 0.8; // [0.1:0.1:2]

/* [Drive] */

// Drive style
drive_style   = "smooth"; // [ "hard", "smooth" ]

// Exposed height of drive receiver above handle (mm)
drive_exposed_height = 8;

// Drive top oversize (percentage of drive size)
drive_top_oversize_percent = 65; // [20:1:150]

// Drive transition oversize (percentage of top radius)
drive_transition_percent = 20; // [ 0:1:30 ]

// Drive length scaling percentage (percentage ratio)
drive_length_scale_percent = 40; // [ 0:1:80 ]

// Drive scaling
drive_scaling = [ percentage( 1.0, 100+drive_length_scale_percent), 1.0, 1.0 ];

/* [Receiver] */

// Receiver addon tolerance (percentage)
receiver_tolerance = 2.5; // [-5:0.25:+10]

// Receiver size (mm)
receiver_hex_side_to_side = 0.25 * inch;

// Receiver radius (mm)
receiver_hex_radius =  percentage( hex_flats_to_radius( receiver_hex_side_to_side ), 100 + receiver_tolerance );

// Receiver depth (mm)
receiver_hex_depth = 13;

// Receiver finder width (percentage oversized)
receiver_finder_percentage = 10; // [ 0:1:20]

// Wrench overall size
wrench_size = handle_size + [ 0, 0, drive_exposed_height ];

// ellipse_intercept:
//
// Intercept ellipse at angle theta.
//
// Ref: https://math.stackexchange.com/questions/3294151/how-to-find-an-intersection-point-between-a-line-and-an-ellipse-where-the-line
//
function ellipse_intercept( theta, a, b ) =
  let( k = (a*a * b*b) / (b*b + a*a * tan(theta)*tan(theta)) )
    [ sqrt( k ), sqrt(k) * tan( theta ) ];

// handle_intercept:
//
// Transition point from handle's straight part to the handle's bulge (ellipse)
//
function handle_intercept( theta ) =
  ellipse_intercept( theta, drive_scaling.x * handle_width/2, drive_scaling.y * handle_width/2 );

// handle_side_end:
//
// Side end point of handle (quadrant I)
//
function handle_side_end() =
  [ handle_length/2, percentage( handle_width/2, handle_end_width_percent ) ];

// handle_side_points:
//
// Points of handle at side and transition to center bulge (ellipse)
//
function handle_side_points() =
  [ handle_side_end(), handle_intercept( handle_theta ) ];

// chamfer_extrude:
//
// Essentially, a linear extrusion of height <size.z>, with
// a chamfered bottom and top.
//
module chamfer_extrude( size, percent, angle ) {
  chamfer_height = percentage( size.z, percent ) / 2;
  chamfer_angle  = is_undef(angle) ? 45 : angle;
  chamfer_delta  = chamfer_height / tan( chamfer_angle );

  full_height    = size.z - 2*chamfer_height;

  chamfer_size  = size - 2*[ chamfer_delta, chamfer_delta, 0 ];
  chamfer_scale = [ chamfer_size.x/size.x, chamfer_size.y/size.y ];

  module invert( height ) { translate( [0,0,height] ) mirror( [0,0,1] ) children(); }

  if( chamfer_height > 0 )
    invert( chamfer_height )
      linear_extrude( height=chamfer_height, scale=chamfer_scale )
	children();

  translate( [0,0,chamfer_height] )
    linear_extrude( height=full_height )
      children();

  if( chamfer_height > 0 )
    translate( [0,0,chamfer_height+full_height] )
      linear_extrude( height=chamfer_height, scale=chamfer_scale )
	children();
} // end chamfer_extrude

module handle_ellipse() {
  chamfer_extrude( handle_size, handle_chamfer_percent, handle_chamfer_angle )
    ellipse( handle_length, handle_width );
} // end handle_ellipse

module handle_poly( style ) {
  m = style == "hard" ? 0 : 1;

  end_r        = m*end_roundover_radius;
  transition_r = m*drive_scaling.x * handle_width;

  // Two straight points on the side of handle
  side_points = handle_side_points();
  outside     = side_points[0];
  intercept   = side_points[1];

  // End point
  end = [ handle_length/2+0.1, 0 ];

  // Hard transition from poly to center ellipse
  poly_to_ellipse = handle_intercept( handle_theta + (90-handle_theta)/4 );

  radiiPoints = [
     [ +end.x,             +end.y,             0 ],
     [ +outside.x,         +outside.y,         end_r ],
     [ +intercept.x,       +intercept.y,       transition_r ],
     [ +poly_to_ellipse.x, +poly_to_ellipse.y, 0  ],
     [ +poly_to_ellipse.x, -poly_to_ellipse.y, 0  ],
     [ +intercept.x,       -intercept.y,       transition_r ],
     [ +outside.x,         -outside.y,         end_r ],
  ];

  chamfer_extrude( handle_size, handle_chamfer_percent, handle_chamfer_angle ) {
    // Two ends
    polygon( polyRound( radiiPoints, poly_iter ) );
    mirror( [1,0,0] ) polygon( polyRound( radiiPoints, poly_iter ) );

    // Elliptical bulge
    intersection() {
      scale( drive_scaling ) circle( d=handle_width );
      square( [ 2*poly_to_ellipse.x + 2*SMIDGE, drive_scaling.y * handle_width ], center=true );
    }
  }
} // end handle_poly

module handle() {
  if( handle_style == "ellipse" )
    handle_ellipse();
  else if( handle_style == "hard" )
    handle_poly( "hard" );
  else if( handle_style == "smooth" )
    handle_poly( "smooth" );
  else
    echo( "unknown handle style", handle_style );
} // end handle

// driver_poly:
//
// Drive portion of handle
//
module driver_poly( style ) {
  m = style == "hard" ? 0 : 1;

  // Total height and width
  total_height      = handle_height + drive_exposed_height;
  total_width       = handle_width/2;

  // Radius of the top of the receiver
  top_width         = percentage( receiver_hex_radius, 100+drive_top_oversize_percent );

  // Radius of the base of the receiver
  transition_width  = percentage( top_width, 100+drive_transition_percent );
  transition_height = handle_height;

  top_r        = m* top_roundover_radius;
  transition_r = m* transition_roundover_radius;

  radiiPoints = [
    [ 0, 0, 0 ],
    [ 0, total_height, 0 ],
    [ top_width, total_height, top_r ],
    [ transition_width, transition_height, transition_r ],
    [ transition_width+transition_r, transition_height, 0 ],
    [ 0, transition_height, 0 ],
  ];

  scale( drive_scaling )
    rotate_extrude( angle=360 )
      polygon( polyRound( radiiPoints, poly_iter ) );
} // end driver_poly

module driver() {
  if( drive_style == "hard" || handle_style == "ellipse" )
    driver_poly( "hard" );
  else if( drive_style == "smooth" )
    driver_poly( "smooth" );
  else
    echo( "unknown drive style", drive_style );
} // end driver

// receiver:
//
// Bit receiver hole deletion
//
module receiver() {
  finder_radius = percentage( receiver_hex_radius, 100 + receiver_finder_percentage );

  // Hole to hold hex bit
  linear_extrude( receiver_hex_depth ) hexagon( radius=receiver_hex_radius );

  // Finding feature
  if( receiver_finder_percentage > 0 )
    translate( [0,0,receiver_hex_depth-finder_radius/2+SMIDGE] )
      mirror( [0,0,1] )
	cone( height=finder_radius, radius=finder_radius, center=true );
} // end receiver

// pad_element:
//
// An individual pad addition or deletion
//
module pad_element( style, phase, size ) {
  depth        = size.z;
  outside_size = size-2*[depth,depth,0];
  inside_size  = size-4*[depth,depth,0];

  knurl_spacing = 1.8*sqrt(2)*depth;
  knurl_depth   = 1.3*sqrt(2)*depth;

  module pad_invert() { translate( [0,0,depth] ) mirror( [0,0,1] ) children(); }
  module pad_rsc( size, invert=false ) { slanted_rounded_side_cube( size, radius=depth, x_angle=45, y_angle=45, invert=invert ); }
  module pad_knurl( size ) { flat_knurled( outside_size+2*sqrt(2)*[depth,depth,0], spacing=knurl_spacing, depth=knurl_depth ) children(); }

  if( style == "none" ) {
    ;
  }
  else if( style == "outset" ) {
    pad_rsc( outside_size, invert=false );
  }
  else if( style == "inset" ) {
    pad_rsc( outside_size, invert=true );
  }
  else if( style == "outline" ) {
    difference() {
      pad_rsc( outside_size, invert=true );
      translate( [0,0,+SMIDGE] )
	pad_rsc( inside_size, invert=false );
    }
  }
  else if( style == "knurl-outset" ) {
    pad_invert()
      pad_knurl( outside_size+2*sqrt(2)*[depth,depth,0] )
	pad_rsc( outside_size, invert=true );
  }
  else if( style == "knurl-inset" ) {
    difference() {
      pad_rsc( outside_size, invert=true );
      translate( [0,0,+SMIDGE] )
	pad_invert()
	  pad_knurl( outside_size )
	    pad_rsc( inside_size, invert=true );
    }
  }
  else if( style == "knurl" ) {
    half_outside_size = size-[depth,depth,0];
    half_inside_size  = size-2*[depth,depth,0];

    if( phase == "subtract" ) {
      pad_rsc( half_outside_size - [0,0,depth/2], invert=true );
    }
    else {
      translate( [0,0,+depth/2] )
	pad_invert()
	  pad_knurl( half_outside_size )
	    pad_rsc( half_inside_size, invert=true );
    }
  }
} // end pad_element

// pad:
//
// Handle single pad sizing, placement, and orientation (quadrant I)
//
module pad( style, phase ) {
  // Two straight points on the side of handle
  side_points = handle_side_points();
  outside     = side_points[0];
  intercept   = side_points[1];

  // Pad area
  pad_height = percentage( pad_height_percent, percentage( handle_height, 100-handle_chamfer_percent ) );
  pad_width  = percentage( pad_width_percent, norm( outside - intercept ) );
  pad_size   = [ pad_width, pad_height, pad_depth ];
  pad_angle  = atan2( outside.y - intercept.y, outside.x - intercept.x );
  pad_center = concat( (outside+intercept+[SMIDGE,SMIDGE])/2, handle_height/2 );

  //echo( pad_center, pad_size, pad_angle );

  translate( pad_center )
    rotate( [90,0,pad_angle] ) {
      if( style == "none" )
	;
      else if( phase == "add" && (style == "outset" || style == "knurl-outset" || style == "knurl") )
        translate( [0,0,-pad_depth+SMIDGE] )
	  pad_element( style, phase, pad_size );
      else if( phase == "subtract" && (style == "outline" || style == "inset" || style == "knurl-inset" || style == "knurl") )
        translate( [0,0,-SMIDGE] )
	  pad_element( style, phase, pad_size );
    }
} // end pad

// pads:
//
// Handle all four pads (mirrored)
//
module pads( phase ) {
  styles = [ "knurl-outset", "knurl", "outset", "knurl-inset" ];

  if( handle_style != "ellipse" )
    for( x = [0,1] )
      for( y = [0,1] )
	mirror( [x,0,0] )
	  mirror( [0,y,0] )
	    //pad( styles[ 2*y + x ], phase );
	    pad( pad_style, phase );
} // end pads

// wrench:
//
// Wrench itself
//
module wrench() {
  difference() {
    union() {
      difference() {
	// Handle base
	handle();

	// Subtract pads that need deletion
	pads( "subtract" );
      }

      // Add pads that need construction
      pads( "add" );

      // Driver portion on top of handle
      driver();
    }

    // Delete receiver
    translate( [ 0,0, handle_height+drive_exposed_height-receiver_hex_depth+SMIDGE ] )
      receiver();
  }

  // Area covered
  if( $preview )
    color( "red", 0.2 ) linear_extrude( height=0.1 ) square( [ wrench_size.x, wrench_size.y ], center=true );
}

$fn=$preview ? 16 : 64;
rotate( 90 ) wrench();
