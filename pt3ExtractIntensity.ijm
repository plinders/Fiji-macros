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

function extractIntensity(dir, img, outdir) {
	imgWithDir = dir + img;
	basename = substring(img, 0, indexOf(img, ".pt3"));
	print("loading "+basename);
   run("PTU Reader v0.0.9", "choose="+imgWithDir+" load_0=[Load whole stack] load_1 bin=12 range=1-12");
   close(basename+"_C1_LifeTimePFrame_Bin=12");
   print("rotating "+basename);
   run("Bin...", "x=2 y=2 bin=Average");
   run("Rotate 90 Degrees Right");
   run("Flip Horizontally");
   outname = basename + " intensity.tif";
   print("saving "+basename);
   saveAs("tif", outdir + File.separator + outname);
   selectWindow(outname);
   close();

}


basedir = getDirectory("Choose a directory ");
baselist = pruneFilelist(basedir);
outdir = getDirectory("Directory for output");


setBatchMode(true);
for (i=0; i<baselist.length; i++) {
    extractIntensity(basedir, baselist[i], outdir);
}
