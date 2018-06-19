function countBF(basedir) {
	list = getFileList(basedir);
	worklist = newArray();
	for (i=0; i<list.length; i++) {
		if (!endsWith(list[i], "segmented.tif") && !endsWith(list[i], "/")) {
			worklist = Array.concat(worklist, list[i]);
		}
	}
	return worklist;
}

function mergeBFandSegmentation(img, basedir) {
	setBatchMode(true);
	basename = substring(img, 0, indexOf(img, ".tif.tif"));
	segmented = basename + "_segmented.tif";
	merged = basename + "_merged.tif";
	open(img);
	open(segmented);
	selectWindow(segmented);
	run("Stack to Images");
	run("Merge Channels...", "c1=feature_0 c2=feature_1 c3=feature_2 c4="+img+" create keep");
	selectWindow("Composite");
	saveAs("tif", basedir + File.separator + merged);
	selectWindow(merged);
	close();
	selectWindow("feature_2");
	close();
	selectWindow("feature_1");
	close();
	selectWindow("feature_0");
	close();
	selectWindow(img); 
	close();
	print(img + " done!");
}

basedir = getDirectory("Choose a Directory ");
setBatchMode(true);
baselist = countBF(basedir);

for (i=0; i<baselist.length; i++) {
	mergeBFandSegmentation(baselist[i], basedir);
}

