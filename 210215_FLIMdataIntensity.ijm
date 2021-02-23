function pruneFilelist(basedir) {
    list = getFileList(basedir);
    worklist = newArray();

    for (i=0; i < list.length; i++) {
        if (endsWith(list[i], ".pt3") && !endsWith(list[i], "/")) {
            worklist = Array.concat(worklist, list[i]);
        }
    }
    return worklist;
}

function projectLifetime(dir, img) {
	imgWithDir = dir + img;
	basename = substring(img, 0, indexOf(img, ".pt3"));

   run("PTU Reader v0.0.9", "choose="+imgWithDir+" load_0=[Load whole stack] load_1 bin=1 range=1-6");
   close(basename+"_C1_LifeTimePFrame_Bin=1");
   run("Z Project...", "projection=[Max Intensity]");
	close(basename+"_C1_Intensity_Bin=1");
}


basedir = getDirectory("Choose a directory ");
baselist = pruneFilelist(basedir);

setBatchMode(true);
for (i=0; i<baselist.length; i++) {
    projectLifetime(basedir, baselist[i]);
}
run("Images to Stack", "name=Stack title=TNFa use");
saveAs("tif", basedir + File.separator + "stack.tif");

