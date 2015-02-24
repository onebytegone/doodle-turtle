// ********************************
// Copyright 2015 Ethan Smith
// ********************************

include <CornerCutout.scad>

module RoundedRect(x = 10, y = 10, z = 10, radius = 2) {
	translate([-x/2, -y/2]) difference() {
		cube([x, y, z]);
		translate([0,0]) CornerCutout(0, z, radius);
		translate([x,0]) CornerCutout(1, z, radius);
		translate([x,y]) CornerCutout(2, z, radius);
		translate([0,y]) CornerCutout(3, z, radius);
	}
}