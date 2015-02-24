// ********************************
// Copyright 2015 Ethan Smith
// ********************************

module CornerCutout(direction = 0, thickness = 10, radius = 4, extra = 0.4, cutin = 0.01, smooth=30, cylinderExtra = 0) {
	rotate([0,0,direction*90]) difference() {
		translate([-extra,-extra, -extra*2]) cube([radius+extra+cutin, radius+extra+cutin, thickness+extra*4]);
		translate([radius, radius, -extra-cylinderExtra/2]) cylinder(thickness+extra*2+cylinderExtra, radius, radius, $fn=smooth);
	}
}