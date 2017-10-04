//Generate ROIs for ratiometric calculation
//User adds cells to ROI manager by drawing a ROI first

n_cell = roiManager("count"); //Count number of cells to be processed
windowname = getTitle(); //Get title of original image
dir = getDirectory("image"); //Get directory of original image
cell_array = newArray(); //Initiate array to store names of generate cell images

selectWindow(windowname);
//Extract series name from filename + window title
filename = getInfo("image.filename");
seriesname = substring(windowname, lengthOf(filename) + 3, lengthOf(windowname));

//Save ROIs to zip so they can be reused later
roiManager("Save", dir+"\\"+seriesname+"_ROIs.zip");

//Generate single cell images from user-defined ROIs
for (i=0; i < n_cell; i++) {
	roiManager("Select", i);
	name = seriesname+"_cell"+i+1;
	run("Duplicate...", "duplicate");
	rename(name); //Renames new image to <seriesname>_cell_<number>
	run("Clear Outside", "stack"); //remove content outside original ROI
	selectWindow(windowname);
	cell_array = Array.concat(cell_array, name); //Add name of new cell image to array
}
//Remove ROIs
roiManager("Reset");

//Run following code over generated cell images
for (j=0; j < cell_array.length; j++) {

	selectWindow(cell_array[j]);
	newdir = cell_array[j];
	File.makeDirectory(dir+"\\"+newdir);

	run("Duplicate...", "title=thres");
	selectWindow("thres");
	run("Threshold...");
		waitForUser("Set appropriate threshold");
		setOption("BlackBackground", false);
		run("Convert to Mask");
	selectWindow("thres");
	run("Analyze Particles...", "size=0.5-Infinity clear include add");
	selectWindow("thres");
	close();

	n_roi = roiManager("count");
	selectWindow(cell_array[j]);

	for (k=0; k < n_roi; k++) {
		selectWindow(cell_array[j]);
		roiManager("Select", k);
		ROIname = "ROI_"+k;
		run("Duplicate...", "duplicate");
		run("Clear Outside", "stack"); //remove content outside duplicated ROI
		saveAs("Tiff", dir+"\\"+newdir+"\\"+ROIname);
		close();
	}
	roiManager("Reset");
	selectWindow(cell_array[j]);
	close();
}
