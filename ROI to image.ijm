//ROI to image
n = roiManager("count");

windowname = getTitle();
//id = getImageID();
//dir = getDirectory("image");
//newdir = title + "_processed";
//File.makeDirectory(dir+"\\"+newdir);

for (i=0; i<n; i++) {
	roiManager("Select", i);
	name = windowname+"_cell"+i;
	run("Duplicate...", "duplicate");
	//ID = getImageID();
	rename(name);
	//align channels
	//saveAs("Tiff", dir+"\\"+newdir+"\\"+name);
	//close();
	selectWindow(windowname);
}

roiManager("Reset");