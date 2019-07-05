function countFiles(basedir) {
	list = getFileList(basedir);
	worklist = newArray();
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], ".tif") && !endsWith(list[i], "/")) {
			worklist = Array.concat(worklist, list[i]);
		}
	}
	return worklist;
}

function correctImg(img, basedir) {
	//setBatchMode(true);
	roiManager("Reset");
	seq_dir = basedir + File.separator + "seq";
	if (!File.exists(seq_dir)) {
		File.makeDirectory(seq_dir);
	} else {
		File.delete(seq_dir);
		File.makeDirectory(seq_dir);
	}

	open(img);

	seq_start_name = img + "_t001_c001.tif";

	run("Image Sequence...", "format=TIFF save=["+seq_dir+File.separator+seq_start_name+"]");
	

};


basedir = getDirectory("Choose a Directory ");
//setBatchMode(true);
baselist = countFiles(basedir);

print(baselist.length);

correctImg(baselist[0], basedir);

//for (i=0; i<baselist.length; i++) {
	
//}