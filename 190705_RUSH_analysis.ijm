roiManager("reset");

giantinChan = getNumber("Giantin channel", 3);
cargoChan = getNumber("Cargo channel", 1);

originalName = getTitle();
basename = substring(originalName, 0, indexOf(originalName, ".tif"));

dir = getDirectory("image");
roiDir = dir + File.separator + "ROIs";
if (!File.exists(roiDir)) {
	File.makeDirectory(roiDir);
}

run("Duplicate...", "duplicate channels="+cargoChan);
rename(basename + "_cargo");
selectWindow(originalName);
run("Duplicate...", "duplicate channels="+giantinChan);
rename(basename + "_giantin");

run("Threshold...");
	waitForUser("Set appropriate threshold");
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Dark");

for (i=1; i <= nSlices; i++) {
	setSlice(i);
	run("Create Selection");
	roiManager("add");	
}

roiManager("save", roiDir + File.separator + basename + "_ROIs.zip");

selectWindow(basename + "_cargo");

roiManager("Measure");

String.copyResults();
waitForUser("Paste cargo results to Excel");
if (isOpen("Results")) { 
	selectWindow("Results"); 
	run("Close"); 
} 

selectWindow(basename + "_cargo");
roiManager("reset");
run("Select All");
roiManager("Add");
roiManager("Multi Measure");
String.copyResults();
waitForUser("Paste total fluorescence results to Excel");

if (isOpen("Results")) { 
	selectWindow("Results"); 
	run("Close"); 
}

selectWindow(basename + "_cargo");
close();
selectWindow(basename + "_giantin");
close();
selectWindow(originalName);
close();

waitForUser("Done!");