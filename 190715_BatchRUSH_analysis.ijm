function pruneFilelist(basedir) {
    list = getFileList(basedir);
    worklist = newArray();

    for (i=0; i < list.length; i++) {
        if (endsWith(list[i], ".tif") && !endsWith(list[i], "/")) {
            worklist = Array.concat(worklist, list[i]);
        }
    }
    return worklist;
}

function analyzeCargo(img) {
    giantinChan = getNumber("Giantin channel", 3);
    cargoChan = getNumber("Cargo channel", 1);

    open(img);
    roiManager("reset");

    originalName = getTitle();
    basename = substring(originalName, 0, indexOf(originalName, ".tif"));

    dir = getDirectory("image");
    roiDir = dir + File.separator + "ROIs";
    if (!File.exists(roiDir)) {
        File.makeDirectory(roiDir);
    }
    resultsDir = dir + File.separator + "Results";
    if (!File.exists(resultsDir)) {
        File.makeDirectory(resultsDir);
    }

    run("Duplicate...", "duplicate channels="+cargoChan);
    rename(basename + "_cargo");
    selectWindow(originalName);
    run("Duplicate...", "duplicate channels="+giantinChan);
    rename(basename + "_giantin");

    run("Threshold...");
        waitForUser("Set appropriate threshold");
        setOption("BlackBackground", false);
        run("Convert to Mask", "method=Default background=Dark");

    for (i=1; i <= nSlices; i++) {
        setSlice(i);
        run("Create Selection");
        roiManager("add");	
    }

    roiManager("save", roiDir + File.separator + basename + "_ROIs.zip");

    selectWindow(basename + "_cargo");

    roiManager("Measure");
    saveAs("results",  resultsDir + File.separator + basename + "_cargo.csv"); 

    if (isOpen("Results")) { 
        selectWindow("Results"); 
        run("Close"); 
    } 

    selectWindow(basename + "_cargo");
    roiManager("reset");
    run("Select All");
    roiManager("Add");
    roiManager("Multi Measure");
    saveAs("results",  resultsDir + File.separator + basename + "_total.csv"); 

    if (isOpen("Results")) { 
        selectWindow("Results"); 
        run("Close"); 
    }

    selectWindow(basename + "_cargo");
    close();
    selectWindow(basename + "_giantin");
    close();
    selectWindow(originalName);
    close();


}

basedir = getDirectory("Choose a directory ");
baselist = pruneFilelist(basedir);

for (i=0; i<baselist.length; i++) {
    analyzeCargo(baselist[i]);
}
