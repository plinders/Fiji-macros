n_cell = roiManager("count"); //Count number of cells to be processed
windowname = getTitle(); //Get title of original image
dir = getDirectory("image"); //Get directory of original image
ROI = dir + File.separator + "ROI" + File.separator;
File.makeDirectory(ROI);
SINGLE = dir + File.separator + "Single Cells" + File.separator;
File.makeDirectory(SINGLE);
cell_array = newArray(); //Initiate array to store names of generate cell images

selectWindow(windowname);
//Extract series name from filename + window title
filename = getInfo("image.filename");
//seriesname = substring(windowname, lengthOf(filename) + 3, lengthOf(windowname));
basename = substring(filename, 0, indexOf(filename, ".tif")); //Remove .tif from filename
seriesname = replace(basename, filename + " - ", "");
//Save ROIs to zip so they can be reused later
roiManager("Save", ROI+seriesname+"_ROIs.zip");

//Generate single cell images from user-defined ROIs
for (i=0; i < n_cell; i++) {
    setBackgroundColor(0,0,0);
    roiManager("Select", i);
    name = seriesname+"_cell"+i+1;
    run("Duplicate...", "duplicate");
    rename(name); //Renames new image to <seriesname>_cell_<number>
    run("Clear Outside", "stack"); //remove content outside original ROI
    selectWindow(name);
    saveAs("Tiff", SINGLE + name);
    close();
    selectWindow(windowname);
    //cell_array = Array.concat(cell_array, name); //Add name of new cell image to array
}