// Paramètres
SIZE_PX = 1200; // 1200 si résolution la plus haute, 400 si 2e plus haute
nom = "U55_from_whole_segmented_image";
OUT_DIR = "C:/Users/Emilie/Documents/Epifluorescence/OTR et asma/analyses OTR/U55";

// Dimensions de l'image
getDimensions(width, height, channels, slices, frames);

// Nom de base
title = getTitle();
baseName = substring(title, 0, lastIndexOf(title, "."));
count = roiManager("count");

// Boucle sur tous les ROIs
for (i = 0; i < count; i++) {
    roiManager("select", i);
    getSelectionBounds(x, y, w, h);
    cx = x + w/2;
    cy = y + h/2;
    x0 = round(cx - SIZE_PX/2);
    y0 = round(cy - SIZE_PX/2);

    // Empêche de sortir des bords
    if (x0 < 0) x0 = 0;
    if (y0 < 0) y0 = 0;
    if (x0 + SIZE_PX > width)  x0 = width - SIZE_PX;
    if (y0 + SIZE_PX > height) y0 = height - SIZE_PX;

    // Crop et sauvegarde directe
    makeRectangle(x0, y0, SIZE_PX, SIZE_PX);
    run("Duplicate...", "title=CROP");
	roiNumber = IJ.pad(i+1, 2);  // ROI_01, ROI_02, …
	saveAs("Tiff", OUT_DIR + "/" + nom + "_ROI" + roiNumber + ".tif");
    close();
}

print(count + " crops enregistrés dans : " + OUT_DIR);
