roiManager("reset");
mainWindow = getTitle();
close("\\Others");
h = getHeight();
w = getWidth();
area = w * h;
gridNum = getNumber("How many grid boxes in total?", 96); // Number of wells
boxArea = area / gridNum;
boxSide = sqrt(boxArea);
numBoxX = round(w / boxSide);
numBoxY = round(h / boxSide);
remainX = (w - (numBoxX * boxSide)) / 2;
remainY = (h - (numBoxY * boxSide)) / 2;

// Cercle : aire = π * r²  →  r = sqrt(4000 / PI)
circleArea = 50000;
r = sqrt(circleArea / PI);
d = 2 * r; // diamètre en pixels

// If offset
offsetX = getNumber("Offset X (pixels) ?", 0);
offsetY = getNumber("Offset Y (pixels) ?", 0);

// From down left to top right (if images are inversed)
for (i = numBoxY - 1; i >= 0; i--) {  // From bottom (numBoxY-1) and up
    for (j = 0; j < numBoxX; j++) {    // From left to right
        // Rectangle center: 
        cx = j * boxSide + remainX + boxSide / 2 + offsetX; 
        cy = i * boxSide + remainY + boxSide / 2 + offsetY;
        
        // makeOval take the top left corner + width + height
        makeOval(cx - r, cy - r, d, d);
        roiManager("add");
    }
}
