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
			newname = ""+x+""+y;
			Roi.setName(newname);
			roiManager("Add");
		}
	}

	File.makeDirectory(outdir);
	rawdir = outdir + File.separator + "raw";
	cytodir = outdir + File.separator + "cyto";
	nucleardir = outdir + File.separator + "nuclear";
	maskdir = outdir + File.separator + "Masks";
	File.makeDirectory(rawdir);
	File.makeDirectory(cytodir);
	File.makeDirectory(nucleardir);
	File.makeDirectory(maskdir);

	run("8-bit");

	for (i = 0; i < roiManager("count"); i++) {
		roiManager("Select", i);
		rName = Roi.getName();
		run("Duplicate...", "title="+rName);
		saveAs("Tiff", rawdir+File.separator+"phase_"+rName+".tif");
		selectWindow("phase_"+rName+".tif");
		close();
		selectWindow(windowname);
		// print(Roi.getName());
	}

	selectWindow(filename);
	close();

	czidir = "D:\\180518_PL025.2";

	czifile = czidir + File.separator + foldername + ".czi";

	run("Bio-Formats Importer", "open="+czifile+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	setSlice(4);
	run("Duplicate...", "title=nuclear");
	selectWindow(foldername + ".czi");
	close();
	selectWindow("nuclear");
	run("8-bit");
	run("8-bit");

	for (i = 0; i < roiManager("count"); i++) {
		roiManager("Select", i);
		rName = Roi.getName();
		run("Duplicate...", "title="+rName);
		saveAs("Tiff", rawdir+File.separator+"DAPI_"+rName+".tif");
		selectWindow("DAPI_"+rName+".tif");
		close();
		selectWindow("nuclear");
		// print(Roi.getName());
	}


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
