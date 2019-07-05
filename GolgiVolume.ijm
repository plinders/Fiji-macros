//Generate ROIs for ratiometric calculation
//User adds cells to ROI manager by drawing a ROI first
golgi_chan = getNumber("Golgi channel", 2);
n_cell = roiManager("count"); //Count number of cells to be processed
windowname = getTitle(); //Get title of original image
dir = getDirectory("image"); //Get directory of original image

out_dir = dir + File.separator + windowname + "_volumes";
File.makeDirectory(out_dir);
seriesname = getInfo("image.filename");
selectWindow(windowname);

//Generate single cell images from user-defined ROIs
for (i=0; i < n_cell; i++) {
	roiManager("Select", i);
	name = seriesname+"_cell"+i+1;
	run("Duplicate...", "duplicate channels="+golgi_chan);
	rename(name); //Renames new image to <seriesname>_cell_<number>
	selectWindow(name);
	run("3D Objects Counter");
	selectWindow("Statistics for "+name);
	saveAs("Results", out_dir + File.separator + name + ".csv");
	selectWindow(name + ".csv");
	run("Close");
	close();
	selectWindow(windowname);
}
