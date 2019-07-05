function golgiMasks(img, nuc_chan, golgi_chan) {
	open(img);
	windowname = getTitle();
	dir = getDirectory("image");
	out_dir = dir + File.separator + "masks";
	if (!File.exists(out_dir)) {
		File.makeDirectory(out_dir);
	}

	seriesname = getInfo("image.filename");

	setSlice(nuc_chan);
	run("Duplicate...", " ");
	nucleus_name = seriesname + "_nucleus";
	rename(nucleus_name);

		
	run("Auto Threshold", "method=IsoData ignore_black white");
	setOption("BlackBackground", false);
	run("Make Binary");


	// run("Threshold...");
	// 	waitForUser("Set appropriate threshold");
	// 	setOption("BlackBackground", false);
	// 	run("Convert to Mask");

	run("Analyze Particles...", "size=10-Infinity exclude clear include add slice");
	
	selectWindow(nucleus_name);
	roiManager("Select", 0);
	setForegroundColor(0, 0, 0);
	setBackgroundColor(255, 255, 255);
	run("Clear Outside");
	run("Fill", "slice");
	run("Invert LUT");

	selectWindow(windowname);
	setSlice(golgi_chan);
	run("Duplicate...", " ");
	golgi_name = seriesname + "_golgi";
	rename(golgi_name);
	
	run("Auto Threshold", "method=IsoData ignore_black white");
	setOption("BlackBackground", false);
	run("Make Binary");

	// run("Threshold...");
	// 	waitForUser("Set appropriate threshold");
	// 	setOption("BlackBackground", false);
	// 	run("Convert to Mask");

	chan_merge_var = "c1="+golgi_name+" c2="+nucleus_name+" create";
	run("Merge Channels...", chan_merge_var);
	selectWindow("Composite");
	Stack.setDisplayMode("color");
	mask_name = seriesname + "_mask";
	rename(mask_name);
	saveAs("Tiff", out_dir + File.separator + mask_name);
	close();
	selectWindow(windowname);
	close();
}

input = getDirectory("Choose a directory");
filelist = getFileList(input);
nuc_chan = getNumber("Nuclear channel", 3);
golgi_chan = getNumber("Golgi channel", 2);

for (i = 0; i < filelist.length; i++) {
	if (endsWith(filelist[i], ".tif")) {
		golgiMasks(filelist[i], nuc_chan, golgi_chan);
	}
}
