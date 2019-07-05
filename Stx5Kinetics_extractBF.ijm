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
	setBatchMode(true);
	dirname = replace(img, ".tif", "");
	File.makeDirectory(basedir + File.separator + dirname);    	
    open(img);

	run("Make Substack...", "channels=3 frames=1-60");

	rename("phase");
	seq_start_name = "phase_000.tif";

	run("Image Sequence... ", "format=TIFF save=["+basedir+dirname + File.separator + seq_start_name+"]");
        
       // run("HyperStackReg v04", "transformation=Affine show");
        //run("HyperStackReg v05", "transformation=[Rigid Body] channel1 channel2 show");
//        run("HyperStackReg v05", "transformation=Affine channel3 channel4 show");
        //saveAs("Tiff", dirD+getTitle());
        //close(); // close registered file
        close(); // close original file
};


basedir = getDirectory("Choose a Directory ");
//setBatchMode(true);
baselist = countFiles(basedir);

print(baselist.length);

for (i=0; i<baselist.length; i++) {
	correctImg(baselist[i], basedir);
	print("======DONE=====", baselist[i]);
}