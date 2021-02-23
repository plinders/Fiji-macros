// assume open stack

stackSlices = nSlices;

pt3dir = getDirectory("Directory with pt3s");
outdir = getDirectory("Output directory");

n_cell = roiManager("count");

for (i = 0; i < n_cell; i++) {
    cellName = "cell" + (i+1);
    outputDir = outdir + File.separator + cellName;
    if (!File.exists(outputDir)) {
        File.makeDirectory(outputDir);
    }
}

for (i = 0; i < stackSlices; i++) {
    setSlice(i + 1);
    label = getInfo("slice.label");
    trimLabel = substring(label, 4, indexOf(label, "_C"));
    pt3File = pt3dir + trimLabel + ".pt3";

    run("PTU Reader v0.0.9", "choose="+pt3File+" load load_0=[Load whole stack] bin=1 range=1-6");

    pt3name = trimLabel + "_C1_LifetimeAll";

    selectWindow(pt3name);
    for (j = 0; j < n_cell; j++) {
        setBackgroundColor(0,0,0);
        roiManager("Select", j);
        cellName = "cell" + (j+1);

        name = cellName + "_" +trimLabel;
        run("Duplicate...", "duplicate");
        rename(name); //Renames new image to <seriesname>_cell_<number>
        run("Clear Outside", "stack"); //remove content outside original ROI
        selectWindow(name);
        saveName = outputDir + File.separator + cellName + File.separator + name;

        run("OME-TIFF...", "save="+saveName+" compression=Uncompressed");

        close();
        selectWindow(pt3name);
        //cell_array = Array.concat(cell_array, name); //Add name of new cell image to array
    }
    close(pt3name);

}

