//Generate ROIs for ratiometric calculation
//User adds cells to ROI manager by drawing a ROI first

n_cell = roiManager("count"); //Count number of cells to be processed
windowname = getTitle(); //Get title of original image
dir = getDirectory("image"); //Get directory of original image
//cell_array = newArray(); //Initiate array to store names of generate cell images
out_dir = dir + "\\masks\\";
File.makeDirectory(out_dir);

selectWindow(windowname);
//Extract series name from filename + window title
seriesname = getInfo("image.filename");
//seriesname = substring(windowname, lengthOf(filename) + 3, lengthOf(windowname));

//Save ROIs to zip so they can be reused later
//roiManager("Save", dir+"\\"+seriesname+"_ROIs.zip");

setSlice(1);
run("Duplicate...", " ");
nucleus_name = seriesname + "_nucleus";
rename(nucleus_name);

run("Threshold...");
	waitForUser("Set appropriate threshold");
	setOption("BlackBackground", false);
	run("Convert to Mask");

run("Analyze Particles...", "size=10-Infinity exclude clear include add slice");

selectWindow(nucleus_name);
roiManager("Select", 0);
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);
run("Clear Outside");
run("Fill", "slice");
run("Invert LUT");

selectWindow(windowname);

setSlice(2);
run("Duplicate...", " ");
golgi_name = seriesname + "_golgi";
rename(golgi_name);

run("Threshold...");
	waitForUser("Set appropriate threshold");
	setOption("BlackBackground", false);
	run("Convert to Mask");


chan_merge_var = "c1="+golgi_name+" c2="+nucleus_name+" create";
run("Merge Channels...", chan_merge_var);
selectWindow("Composite");
Stack.setDisplayMode("color");
mask_name = seriesname + "_mask";
rename(mask_name);
saveAs("Tiff", out_dir + mask_name);
close();

//Generate single cell images from user-defined ROIs
/*for (i=0; i < n_cell; i++) {
	roiManager("Select", i);
	name = seriesname+"_cell"+i+1;
	run("Duplicate...", "duplicate");
	rename(name); //Renames new image to <seriesname>_cell_<number>
	run("Clear Outside", "stack"); //remove content outside original ROI
	selectWindow(name);
	saveAs("Tiff", dir+"\\"+name);
	close();
	selectWindow(windowname);
	//cell_array = Array.concat(cell_array, name); //Add name of new cell image to array
}
*/
roiManager("Reset");
selectWindow(seriesname);
close();
