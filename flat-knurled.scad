//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    flat-knurled.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Create flat knurled (diamond-pattern) surface
//

include <smidge.scad>;

module _centered_cube( size ) {
  linear_extrude( height=size.z) square( [size.x,size.y], center=true );
} // end _centered_cube

// flat_knurled:
//
// Ref: https://hackaday.com/2022/10/15/how-to-achieve-knurling-on-a-flat-surface/
//
module flat_knurled(size, spacing, depth)
{
  assert( len( size ) >= 2 );

  max_xy            = max( size.x, size.y );
  min_xy            = min( size.x, size.y );
  effective_depth   = is_undef(depth) ? 0.6*size.z : depth;
  effective_spacing = is_undef(spacing) ? 3*effective_depth : spacing;

  assert( is_num( effective_depth ) );
  assert( is_num( effective_spacing ) );

  iter         = 2 * ceil( (max_xy / effective_spacing) );
  slice_length = 3*max_xy;

  //echo( iter, effective_depth, effective_spacing );

  difference() {
    children();

    translate( [0,0,+SMIDGE] )
      intersection() {
        _centered_cube( size );
	translate( [0,0, size.z] ) {
	  for( i = [-iter:1:iter] ) {
	    translate( [i*effective_spacing, 0, 0] ) {
	      rotate([270, 90, 60])
		translate( [ 0,0, -slice_length/2 ] )
		  cylinder(d=effective_depth, h=slice_length, $fn=3);
	      rotate([270, 90, -60])
		translate( [ 0,0, -slice_length/2 ] )
		  cylinder(d=effective_depth, h=slice_length, $fn=3);
	    }
	  }
	}
      }
  }
} // end flat_knurled

// Use as follows. The top surface height of the child needs to be known
if( false ) {
  size = [ 10, 10, 1 ];
  flat_knurled( size, spacing=1.2, depth=1.2 ) {

    // Centered cube
    _centered_cube( size );

    // Centered cube
    _centered_cube( concat( 2*[size.x,size.y], size.z*.6 ) );
  }
}
