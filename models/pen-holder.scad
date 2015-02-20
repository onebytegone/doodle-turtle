
supportArmWidth = 8;
supportArmLength = 20;
supportArmThickness = 2;

chainClampBoltDiameter = 3.5;
 
boltDiameter = 3.2;

weightBoltDiameter = 3.5;

penHoleSize = 20;
penClampExtra = 3;
penClampHeight = 20;
penClampWallThickness = 4;
penClampSize = penHoleSize+penClampWallThickness*2;

servoTabWidth = 10;

servoWidth = 40;
servoHeight = 20;
servoMountToCutout = 10;
servoMountToCutoutWidth = 30;
servoMountToCutoutHeight = 10;

baseThickness = 3;



edgeExtra = 10;

totalWidth = servoWidth+servoTabWidth+edgeExtra*2;
totalHeight = penClampSize+servoMountToCutoutHeight+servoMountToCutout+edgeExtra*2;


/*difference() {
	translate([-totalWidth/2, 0]) cube([totalWidth, totalHeight, baseThickness]);
	translate([-servoMountToCutoutWidth/2, edgeExtra+penClampSize+servoMountToCutoutHeight, -1]) cube([servoMountToCutoutWidth, servoMountToCutoutHeight, baseThickness+2]);
	translate([0, edgeExtra+penHoleSize/2+penClampExtra, -1]) penClampShape(penHoleSize, baseThickness+2, penClampExtra);
}
translate([0, edgeExtra+penHoleSize/2+penClampExtra, baseThickness-0.01]) 
*/

translate([0, penClampSize/2+penClampExtra, 0]) 
penClamp(penClampSize, penHoleSize, penClampExtra, penClampHeight, boltDiameter);

translate([penClampSize/2-0.01, supportArmWidth/2, 0]) 
supportArm(supportArmWidth, supportArmLength, supportArmThickness);

mirror([1,0]) 
translate([penClampSize/2-0.01, supportArmWidth/2, 0]) 
supportArm(supportArmWidth, supportArmLength, supportArmThickness);

 
module supportArm(width, length, thickness) {
	translate([0, -width/2]) cube([length, width, thickness]);
}


module penClamp(outsideSize, insideSize, insideExtra, height, boltDiameter) {
	difference() {
		penClampShape(outsideSize, height, insideExtra);
		translate([0, 0, -1]) penClampShape(insideSize, height+2, insideExtra);
		translate([0, -outsideSize/2-insideExtra-1, height/2]) rotate([-90,0]) cylinder(outsideSize/2+insideExtra+1, boltDiameter/2, boltDiameter/2);
	}
}

module penClampShape(size, height, extraLength = 0) {
	translate([-size/2, -size/2-extraLength]) cube([size, size/2+extraLength, height]);
	rotate([0,0,45]) assign(diamond = sqrt((size*size)/2)) translate([-diamond/2, -diamond/2]) cube([diamond, diamond, height]);
}