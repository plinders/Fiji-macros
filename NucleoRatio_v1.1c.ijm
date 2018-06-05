/* NucleoRatio V1.1 ImageJ macro, July 29th 2017
 *  
 * This macro can be used to check signal intensity of a channel in a ROI that is based on the intensity of another channel.
 * For example, you stained nuclei with DAPI and want to measure signal intensity of another channel only in the nucleus.
 * In addition, this macro also measures the cytosolic intensity of your channel of interest.
 * 
 * CHANGELOG
 * v1.1
 * 	- Macro now runs for all TIF files in a folder
 * 	- Autosaves results as .xls file in the same directory as the images
 * 	- Sets freehand selection tool automatically
 * 	- Manual selection of DAPI ROI
 * 
 * This macro is written by Laurent Paardekooper
 * PhD student in the group of Geert van den Bogaart
 * Tumor Immunology Lab, RIMLS, Nijmegen
 */

macro "NucleoRatio" {

roiManager("Reset");
run("Clear Results");

//Run macro for each TIF file in directory
input = getDirectory("Choose  Directory");
filelist = getFileList(input);
//Array.print(filelist);

//Asks user where the 2 corresponding channels are
GFPchan = getNumber("Select GFP channel", 1);
//Cherrychan = getNumber("Select mCherry channel", 2);
DAPIchan = getNumber("Select DAPI channel", 3);
//BFchan = getNumber("Select brightfield channel", 4);

for (i = 0; i < filelist.length; i++){
   
      if (endsWith(filelist[i],".tif") || endsWith(filelist[i],".TIF")){
      open(input+filelist[i]);
      }

//Retrieves filenames and directories of current image window
filename = getInfo("image.filename");
windowname = getTitle();

setTool("freehand");
waitForUser("Use freehand selection tool to select cells of interest and add ROIs to manager by pressing 't'");

//Stepwise selection of all ROIs currently in the manager and performs an operation on each ROI after selection of that ROI
	count = roiManager("count");
	current = roiManager("index");
		for (j = 0; j < count; j++){
		roiManager("select", j);
				
			run("Duplicate...", "duplicate");
			cellname = filename+"_cell"+j+1;
			rename(cellname);
			selectWindow(windowname);

		roiManager("update");
		}
		
		{if (current < 0)
			roiManager("deselect");
		else
			roiManager("select", current);
			roiManager("Reset");
			selectWindow(windowname);
			run("Close");
			}				
				
//runs for each open image
filenumber = nImages;
for (n=1; n<= filenumber; n++){ 
    roiManager("Reset");
    title = getTitle;

//User-defined treshold on GFP channel
	setSlice(GFPchan);
	run("Duplicate...", "use");
	run("Clear Outside");
	setAutoThreshold("Default dark");
	run("Threshold...");
		waitForUser("Set appropriate threshold for GFP");
		setOption("BlackBackground", false);
		run("Convert to Mask");
			run("Analyze Particles...", "size=100-Infinity exclude include add"); //check whether size applies to your images!

		//Combines ROIs if there is more than 1 ROI as a result from the thresholding
		nroi = roiManager("count");
		if (nroi > 1){
		roiManager("deselect");
		roiManager("Combine");
		roiManager("Delete");
		roiManager("Add");
		}
				
			roiManager("select", 0);
			roiManager("rename", "GFP");
			close();

/*
//User-defined treshold on mCherry channel
	setSlice(Cherrychan);
	run("Duplicate...", "use");
	run("Clear Outside");
	setAutoThreshold("Default dark");
	run("Threshold...");
		waitForUser("Set appropriate threshold for mCherry");
		setOption("BlackBackground", false);
		run("Convert to Mask");
			run("Analyze Particles...", "size=100-Infinity exclude include add"); //check whether size applies to your images!

		//Combines ROIs if there is more than 1 ROI as a result from the thresholding
		nroi = roiManager("count");
		if (nroi > 1){
		roiManager("deselect");
		roiManager("Combine");
		roiManager("Delete");
		roiManager("Add");
		}
			roiManager("select", 1);
			roiManager("rename", "mCherry");
			close();
			*/

//User-defined treshold on DAPI channel
	setSlice(DAPIchan);
	run("Duplicate...", "use");
	setTool("freehand");
	run("Select None");
	waitForUser("Select nucleus and click OK");
	run("Clear Outside");
	setAutoThreshold("Default dark");
	run("Threshold...");
		waitForUser("Set appropriate threshold for DAPI");
		setOption("BlackBackground", false);
		run("Convert to Mask");
			run("Analyze Particles...", "size=0-Infinity include add"); //check whether size applies to your images!
			roiManager("select", 1);
			roiManager("rename", "DAPI");
			close();
		
//Measure all ROIs (simple variant)
	roiManager("deselect");
	setSlice(GFPchan);
	run("Set Measurements...", "area mean standard modal min integrated median display redirect=None decimal=3");
	roiManager("Measure");

//Cleanup
close();
roiManager("Reset");

		}
	}
	
resultsname = input+"NucleoRatio_Results.xls"; 
saveAs("Results", resultsname);	

showMessage(filelist.length + " images analyzed!");
}