function countFiles(basedir) {
	list = getFileList(basedir);
	worklist = newArray();
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], ".czi") && !endsWith(list[i], "/")) {
			worklist = Array.concat(worklist, list[i]);
		}
	}
	return worklist;
}

function makeSingleCells(img, basedir) {
	setBatchMode(true);
	roiManager("Reset");
	single_dir = basedir + File.separator + "Single Cells" + File.separator;
	if (!File.exists(single_dir)) {
		File.makeDirectory(single_dir);
	}
	run("Bio-Formats Importer", "open="+basedir+img+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	basename = substring(img, 0, indexOf(img, ".czi"));
	ROI = basename + "_ROI.zip";
	roiManager("Open", basedir + File.separator + "ROIs" + File.separator + ROI);
	for (i=0; i<roiManager("count"); i++) {
		setBackgroundColor(0,0,0);
		roiManager("Select", i);
		name = basename +"_cell"+i+1;
		run("Duplicate...", "duplicate");
		rename(name); //Renames new image to <seriesname>_cell_<number>
		run("Clear Outside", "stack"); //remove content outside original ROI
		selectWindow(name);
		saveAs("Tiff", single_dir+name);
		close();
		selectWindow(img);
	}
	close(img);
}


basedir = getDirectory("Choose a Directory ");
setBatchMode(true);
baselist = countFiles(basedir);

for (i=0; i<baselist.length; i++) {
	makeSingleCells(baselist[i], basedir);
}