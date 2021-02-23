//run("Spot Counter", "pre-filter=None noise=750");
function pruneFilelist(basedir) {
    list = getFileList(basedir);
    worklist = newArray();

    for (i=0; i < list.length; i++) {
        if (endsWith(list[i], ".tif") && !endsWith(list[i], "/")) {
            worklist = Array.concat(worklist, list[i]);
        }
    }
    return worklist;
}

function countSpots(img) {
	setBatchMode(true);
	open(img);

	originalName = getTitle();
    basename = substring(originalName, 0, indexOf(originalName, ".tif"));
    dir = getDirectory("image");

	resultsDir = dir + File.separator + "Results";
	if (!File.exists(resultsDir)) {
		File.makeDirectory(resultsDir);
	}
    
	//run("Make Substack...", "channels=1");
	selectWindow(originalName);
	//close();
	//selectWindow(basename + "-1.tif");
	run("Spot Counter", "pre-filter=None boxsize=5 noise=750");
	saveAs("Results", resultsDir + File.separator + basename + ".txt");
	
    if (isOpen(basename + ".txt")) { 
        selectWindow(basename + ".txt"); 
        run("Close"); 
    } 

	selectWindow(originalName);
    close();
}

basedir = getDirectory("Choose a directory ");
baselist = pruneFilelist(basedir);

for (i=0; i<baselist.length; i++) {
    countSpots(baselist[i]);
}
{
list = getList("window.titles");
     for (i=0; i<list.length; i++){
     winame = list[i];
      selectWindow(winame);
     run("Close");
     } 
