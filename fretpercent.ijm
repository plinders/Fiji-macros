function countBF(basedir) {
	list = getFileList(basedir);
	worklist = newArray();
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "A2.ics") && !endsWith(list[i], "/")) {
			worklist = Array.concat(worklist, list[i]);
		}
	}
	return worklist;
}

function calcFret(img, basedir) {
	setBatchMode(true);
	basename = substring(img, 0, indexOf(img, "A2.ics"));
	A1File = basedir + File.separator + basename + "A1.ics";
	file = basedir + File.separator + img;
	
	run("Bio-Formats Importer", "open="+file+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	rename("A2");
	run("Bio-Formats Importer", "open="+A1File+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	rename("A1");

	imageCalculator("Add create 32-bit", "A1","A2");
	selectWindow("Result of A1");
	rename("Atotal");
	imageCalculator("Divide create 32-bit", "A2","Atotal");
	selectWindow("Result of A2");
	rename("FRET");
	run("Rainbow RGB");
	fret = basename + "_FRET.tif";
	saveAs("Tiff", basedir + File.separator + "fret" + File.separator + fret);
	selectWindow(fret);
	close();
	selectWindow("Atotal");
	close();
	selectWindow("A1");
	close();
	selectWindow("A2");
	close();
}

basedir = getDirectory("Choose a Directory ");
setBatchMode(true);
baselist = countBF(basedir);

for (i=0; i<baselist.length; i++) {
	calcFret(baselist[i], basedir);
}

