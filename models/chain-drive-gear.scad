PI = 3.141592653589793;

beadDiameter = 3.8;
beadDistance = 4.3;
chainDiameter = 2;
beadsAlongGearDiameter = 36;

motorShaftDiameter = 5;
motorShaftSideInset = 1;

edgeThickness = 1.5;

circumference = beadsAlongGearDiameter*beadDistance;
chainPathDiameter = circumference/(2*PI);
gearOuterDiameter = chainPathDiameter;
beadAngle = beadDistance/(chainPathDiameter/2*(PI/180));
totalThickness = beadDiameter+edgeThickness*2;

echo ("chainPathDiameter", chainPathDiameter);

retainBoltDiameter = 3.2;
retainExtra = 2;
retainThickness = 2;
retainTop = 4;
retainWidth = 12;
retainGap = beadDiameter/2;
retainCutout = retainGap+gearOuterDiameter/2;
retainHeight = gearOuterDiameter/2+retainBoltDiameter/2+retainExtra;
retainTabLength = retainThickness+totalThickness;

assembly();

module print() {
	gear();
	translate([0, gearOuterDiameter/2 + 4]) chainRetainerExample();
}

module assembly() {
	gear();
	translate([0,-retainExtra-retainBoltDiameter/2,-retainThickness-0.1]) chainRetainerExample();
}

module gear() {
	difference() {
		cylinder(totalThickness, gearOuterDiameter/2, gearOuterDiameter/2, $fn = 50);
		translate([0,0,-1]) motorShaft(totalThickness+2, motorShaftDiameter, motorShaftSideInset, motorShaftSideInset);
		translate([0,0,totalThickness/2]) beadChainCutout(chainPathDiameter, chainDiameter);
		translate([0,0,totalThickness/2]) beadCutout(chainPathDiameter, beadDiameter, beadAngle);
	}
}

module chainRetainerExample() {
	difference() {
		union() {
			translate([-retainWidth/2,0]) cube([retainWidth, retainTop+retainHeight+retainGap, retainTabLength]);
		}

	
		translate([0,retainBoltDiameter/2+retainExtra,retainThickness]) cylinder(retainTabLength-retainThickness+1, retainCutout, retainCutout);

		translate([0,retainBoltDiameter/2+retainExtra,-1]) cylinder(retainThickness+2, retainBoltDiameter/2, retainBoltDiameter/2);
	}
}

module beadChainCutout(loopDiameter, chainDiameter) {
	rotate_extrude(convexity = 4) translate([loopDiameter/2, 0, 0]) circle(r = chainDiameter/2, $fn=5);
}

module beadCutout(loopDiameter, beadDiameter, beadAngle) {
	union()
	for(i = [0:360/beadAngle]) {
		rotate(i*beadAngle, [0,0,1]) translate([loopDiameter/2,0]) cylinder(beadDiameter, beadDiameter/2, beadDiameter/2, center = true, $fn=12);
	}	
}

module motorShaft(length, diameter, leftSideInset, rightSideInset, extra=0.1) {
	difference() {
		cylinder(length, diameter/2, diameter/2);
		translate([-diameter/2-extra, -diameter/2-extra, -extra]) cube([leftSideInset+extra, diameter+extra*2, length+2]);
		translate([diameter/2-rightSideInset, -diameter/2-extra, -extra]) cube([rightSideInset+extra, diameter+extra*2, length+2]);
	}
}