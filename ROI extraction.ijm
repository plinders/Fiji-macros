n = roiManager("count");

title = getTitle();
dir = getDirectory("image");
newdir = title + "_processed";
File.makeDirectory(dir+"\\"+newdir);
ID = getImageID();

for (i=0; i<n; i++) {
	roiManager("Select", i);
	name = "ROI_"+i;
	run("Duplicate...", "duplicate");
	saveAs("Tiff", dir+"\\"+newdir+"\\"+name);
	close();
	selectWindow(title);
}

roiManager("Reset");