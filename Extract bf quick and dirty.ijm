function countBF(basedir) {
	list = getFileList(basedir);
	worklist = newArray();
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], ".tif") && !endsWith(list[i], "/")) {
			worklist = Array.concat(worklist, list[i]);
		}
	}
	return worklist;
}

function saveBF(img, basedir) {
	setBatchMode(true);
	basename = substring(img, 0, indexOf(img, ".tif"));
	outdir = basedir + File.separator + "phase";
	if (!File.exists(outdir)) {
		File.makeDirectory(outdir);
	}
	open(img);
	run("Make Substack...", "channels=3");
	filename = basename + "_phase.tif";
	run("8-bit");
	saveAs('tif', outdir + File.separator + filename);
	selectWindow(filename);
	close();
	selectWindow(img);
	close();
}

basedir = getDirectory("Choose a Directory ");
setBatchMode(true);
baselist = countBF(basedir);

for (i=0; i<baselist.length; i++) {
	saveBF(baselist[i], basedir);
}
