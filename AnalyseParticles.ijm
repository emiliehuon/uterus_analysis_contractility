// Select "Area" on Set Measurements 

id = getImageID();
setAutoThreshold("Default");

// Disable display update to prevent focus theft
setBatchMode(true);

for (i=0 ; i<roiManager("count"); i++) {
    selectImage(id);
    roiManager("select", i);
    run("Analyze Particles...", "size=2000-Infinity show=Nothing display stack"); // SIZE must be < smallest 96-well plate explant
    
    // Optional: show progress in status bar without stealing focus
    if (i % 10 == 0) {  // Displays every 10 ROIs
        showProgress(i, roiManager("count"));
    }
}

// Reactivate the display at the end
setBatchMode(false);

print("Analysis is complete : " + roiManager("count") + " ROIs processed");
beep();  // Done !
