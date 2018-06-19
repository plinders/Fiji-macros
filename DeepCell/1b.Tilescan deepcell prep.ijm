function splitimg(img){
	setBatchMode(true);
	open(img);
	var X_LENGTH = 8;
	var Y_LENGTH = 8;
	var RESOLUTION = 1024;
	var windowname = getTitle();
	dir = getDirectory("image");
	filename = getInfo("image.filename");
	foldername = replace(filename, ".tif", "");
	outdir = dir + File.separator + foldername;

	roiManager("reset");

	for (y = 0; y < Y_LENGTH; y++) {
		for (x = 0; x < X_LENGTH; x++) {
			xpos = RESOLUTION * x;
			ypos = RESOLUTION * y;
			makeRectangle(xpos, ypos, RESOLUTION, RESOLUTION);
			newname = "phase_"+x+""+y;
			Roi.setName(newname);
			roiManager("Add");
		}
	}

	File.makeDirectory(outdir);

	for (i = 0; i < roiManager("count"); i++) {
		roiManager("Select", i);
		rName = Roi.getName();
		run("Duplicate...", "title="+rName);
		saveAs("Tiff", outdir+File.separator+rName+".tif");
		selectWindow(rName+".tif");
		close();
		selectWindow(windowname);
		// print(Roi.getName());
	}

	selectWindow(filename);
	close();
}


print('step1');
input = getDirectory("Choose a Directory ");
print('step2');
filelist = getFileList(input);
// print(filelist);

for (i = 0; i < filelist.length; i++) {
	if (endsWith(filelist[i], ".tif"))  {
		print('starting');
		splitimg(filelist[i]);
		print(i + " done");
	}
}
