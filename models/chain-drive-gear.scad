PI = 3.141592653589793;

beadDiameter = 3.8;
beadDistance = 4.5;
chainDiameter = 2.3;
beadsAlongGearDiameter = 36;

motorShaftDiameter = 5;
motorShaftSideInset = 1;

edgeThickness = 2;

circumference = beadsAlongGearDiameter*beadDistance;
gearDiameter = circumference/(2*PI);
beadAngle = beadDistance/(gearDiameter/2*(PI/180));
totalThickness = beadDiameter+edgeThickness*2;

echo ("gearDiameter", gearDiameter);

difference() {
	cylinder(totalThickness, gearDiameter/2, gearDiameter/2, $fn = 50);
	translate([0,0,-1]) motorShaft(totalThickness+2, motorShaftDiameter, motorShaftSideInset, motorShaftSideInset);
	translate([0,0,totalThickness/2]) beadChainCutout(gearDiameter, chainDiameter);
	translate([0,0,totalThickness/2]) beadCutout(gearDiameter, beadDiameter, beadAngle);
}

module beadChainCutout(loopDiameter, chainDiameter) {
	rotate_extrude(convexity = 4) translate([loopDiameter/2, 0, 0]) circle(r = chainDiameter/2);
}

module beadCutout(loopDiameter, beadDiameter, beadAngle) {
	union()
	for(i = [0:360/beadAngle-1]) {
		rotate(i*beadAngle, [0,0,1]) translate([loopDiameter/2,0]) sphere(beadDiameter/2);
	}	
}

module motorShaft(length, diameter, leftSideInset, rightSideInset, extra=0.1) {
	difference() {
		cylinder(length, diameter/2, diameter/2);
		translate([-diameter/2-extra, -diameter/2-extra, -extra]) cube([leftSideInset+extra, diameter+extra*2, length+2]);
		translate([diameter/2-rightSideInset, -diameter/2-extra, -extra]) cube([rightSideInset+extra, diameter+extra*2, length+2]);
	}
}