include <thirdparty/CornerCutout.scad>;
include <thirdparty/RoundedRect.scad>;

baseThickness = 2;
cornerRadius = 3;

supportArmWidth = 8;
supportArmLength = 30;
supportArmThickness = 2;
supportArmPadExtra = 3.4;
supportArmPadBolt = 3.5;


numSixCountersinkBoltSize = 3.5;
numSixCountersinkHeadDiameter = 7.3;
numSixCountersinkDepth = 2.3;


chainClampBoltDiameter = numSixCountersinkBoltSize;
chainClampBoltExtra = 4;
chainClampBoltMountSideSpace = 1;
chainClampAttachDiameter = chainClampBoltDiameter+chainClampBoltExtra*2;

chainNotchDiameter = 3.5;
chainNotchCurveDiameter = 42;
chainNotchShift = 1;

chainAttachEdge = 2;
chainAttachGap = 0.2;
chainAttachDiameter = chainClampAttachDiameter+chainAttachGap*2+chainAttachEdge*2;
chainAttachThicknessExtra = 1.3;
chainAttachThickness = chainNotchDiameter-chainNotchShift+chainAttachThicknessExtra;
chainAttachLipLength = chainAttachDiameter/2-chainAttachGap;
chainAttachLipHeight = baseThickness+chainNotchShift;
chainAttachTotalHeight = chainAttachThickness+chainAttachLipHeight;

penClampBoltDiameter = 3.2;

penHoleSize = 20;
penClampExtra = 3;
penClampHeight = 20;
penClampWallThickness = 3;
penClampBackingMinThickness = 2;
penClampDimple = 3;
penClampLength = penHoleSize+penClampWallThickness+penClampBackingMinThickness;
penClampWidth = penHoleSize+penClampWallThickness*2;
penClampBoltShift = penHoleSize/5;

servoWidth = 23.5;
servoHeight = 26;
servoThickness = 12.5;
servoTabWidth = 5.3;
servoTabDrop = 7;
servoCutoutEdgeExtra = 4;
servoMountCutoutHeight = 10;
servoTabMountThickness = servoThickness;
servoTabMountLength = servoMountCutoutHeight+servoTabDrop;
servoMountScrewDiameter = 2.1;
servoMountScrewDepth = 10;
servoMountScrewFromInside = 2.65;



baseWidth = servoWidth+servoTabWidth*2;
baseLength = chainClampBoltMountSideSpace+chainAttachDiameter/2+servoHeight+servoMountCutoutHeight;
baseServoMountThickness = servoTabMountThickness+baseThickness;
totalLength = baseLength+penClampLength;

servoCutoutWidth = baseWidth-servoCutoutEdgeExtra*2-servoTabWidth*2;
servoCutoutLength = servoHeight-servoCutoutEdgeExtra*2;

//frame();
//chainAttach();
print();

module print() {
	frame();
	translate([0,-chainAttachDiameter/2-chainClampBoltMountSideSpace,chainAttachTotalHeight]) rotate([0,180]) chainAttach();
	//#translate([-servoWidth/2, baseLength-servoHeight-servoMountCutoutHeight, baseThickness]) cube([servoWidth, servoHeight, servoThickness]);
}

module chainAttach() {
	difference() {
		union() {
			cylinder(chainAttachTotalHeight, chainAttachDiameter/2, chainAttachDiameter/2, $fn=50);
			translate([-chainAttachDiameter/2-0.005, 0,-0.005]) cube([chainAttachDiameter+0.01, chainAttachDiameter/2+0.01, chainAttachThickness]);
		}	
		translate([0,0,chainAttachThickness]) cylinder(baseThickness+1+chainNotchShift, chainAttachDiameter/2-chainAttachEdge, chainAttachDiameter/2-chainAttachEdge);
	
		translate([-chainAttachDiameter/2-1, -chainAttachDiameter/2+chainAttachLipLength, chainAttachThickness+0.01]) cube([chainAttachDiameter+2, chainAttachDiameter-chainAttachLipLength+1, chainAttachLipHeight+1]);

		translate([0,0,-1]) cylinder(chainAttachThickness+2, chainClampBoltDiameter/2, chainClampBoltDiameter/2, $fn=30);

		translate([0, -chainNotchCurveDiameter/2+chainClampBoltDiameter/2+chainNotchDiameter/2, chainAttachThickness-chainNotchDiameter/2+chainNotchShift]) rotate_extrude(convexity = 4) translate([chainNotchCurveDiameter/2, 0, 0]) circle(r = chainNotchDiameter/2, $fn=20);

		translate([-chainAttachDiameter/2, chainAttachDiameter/2]) CornerCutout(3, chainAttachThickness, cornerRadius);
		translate([chainAttachDiameter/2, chainAttachDiameter/2]) CornerCutout(2, chainAttachThickness, cornerRadius);

	}
}

module frame() {
	difference() {
		union() { 
			//supportArms();
			translate([0,-chainAttachDiameter/2-chainClampBoltMountSideSpace]) attachPoint();
			centerShape();
		}
		translate([0, penClampLength-penClampBackingMinThickness, -1]) rotate([0,0,180]) penClampShape(penHoleSize, penClampHeight+2, penClampDimple);
		translate([0, -1, penClampHeight/2+penClampBoltShift]) rotate([-90,0]) cylinder(penClampWallThickness+2, penClampBoltDiameter/2, penClampBoltDiameter/2);
		

		//translate([0, baseLength-servoMountCutoutHeight-servoCutoutLength/2-servoCutoutEdgeExtra, -1]) RoundedRect(servoCutoutWidth, servoCutoutLength, baseThickness+2, 2);
	}
}

module centerShape() {
	//translate([-baseWidth/2, 0]) cube([baseWidth, baseLength-servoMountCutoutHeight, baseThickness]);
	translate([-baseWidth/2, penClampLength+servoTabMountLength]) mirror([0,1]) servoAttachTab();
	mirror([1,0]) translate([-baseWidth/2, penClampLength+servoTabMountLength]) mirror([0,1]) servoAttachTab();

	
	translate([-baseWidth/2, 0]) linear_extrude(height = penClampHeight) assign(halfSize = (baseWidth-penClampWidth)/2) polygon([[0, penClampLength], [baseWidth, penClampLength], [baseWidth-halfSize, 0], [halfSize, 0]]);
}

module servoAttachTab() {
	difference() {
		cube([servoTabWidth, servoTabMountLength, baseServoMountThickness]);
	
		translate([servoTabWidth-servoMountScrewFromInside, -1, servoThickness/2+baseThickness])  rotate([-90,0]) cylinder(servoMountScrewDepth+1, servoMountScrewDiameter/2, servoMountScrewDiameter/2);

	}
}

module attachPoint() {
	difference() {
		union() {
			cylinder(baseThickness, chainClampAttachDiameter/2, chainClampAttachDiameter/2);
			translate([-chainAttachDiameter/2, 0]) cube([chainAttachDiameter, chainAttachDiameter/2+chainClampBoltMountSideSpace, baseThickness]);
		}
		
		mirror([0,0,1]) counterSunkBolt(baseThickness-numSixCountersinkDepth, numSixCountersinkBoltSize, numSixCountersinkHeadDiameter, numSixCountersinkDepth);
	}
} 

module supportArms() {
	translate([0,supportArmWidth/2]) {
		supportArm(supportArmWidth, supportArmLength, supportArmThickness, supportArmPadBolt, supportArmPadExtra);

		mirror([1,0]) 
		supportArm(supportArmWidth, supportArmLength, supportArmThickness, supportArmPadBolt, supportArmPadExtra);
	}
}
 
module supportArm(width, length, thickness, boltDiameter, padExtra) {
	difference() {
		union() {
			translate([0, -width/2]) cube([length, width, thickness]);
			translate([length, 0]) cylinder(thickness, boltDiameter/2+padExtra, boltDiameter/2+padExtra);
		}

		translate([length, 0, -1]) cylinder(thickness+2, boltDiameter/2, boltDiameter/2);
	}
}

module penClampShape(size, height, dimpleDepth) {
	translate([0, dimpleDepth]) { 
		assign(length = size-dimpleDepth) translate([0, length/2]) RoundedRect(size, length, height, 1);
		rotate([0,0,45]) assign(diamond = sqrt(((dimpleDepth*2)*(dimpleDepth*2))/2)) translate([-diamond/2, -diamond/2]) cube([diamond, diamond, height]);
	}
}

module counterSunkBolt(boltLength, boltDiameter, headDiameter, headHeight, extra=0.1) {
	translate([0,0,-headHeight-boltLength-extra]) cylinder(boltLength+extra*2, boltDiameter/2, boltDiameter/2);
	translate([0,0,-headHeight]) cylinder(headHeight+extra, boltDiameter/2, headDiameter/2);
}
