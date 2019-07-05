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
	roiManager("Reset");
	seq_dir = basedir + File.separator + "seq";
	if (!File.exists(seq_dir)) {
		File.makeDirectory(seq_dir);
	} else {
		files = getFileList(seq_dir);
		for (i=0;i<files.length;i++) {
			File.delete(seq_dir + File.separator + files[i]);
		}
	}
	out_dir = basedir + File.separator + "out";
	if (!File.exists(out_dir)) {
		File.makeDirectory(out_dir);
	}

	open(img);

	seq_start_name = img + "_t001_c001.tif";

	run("Image Sequence... ", "format=TIFF save=["+seq_dir+File.separator+seq_start_name+"]");
	
	selectWindow(img);
	close();

	run("Image Sequence...", "format=TIFF open=["+seq_dir+File.separator+seq_start_name+"] file=c001 sort");
	rename("c001");
	run("BaSiC ", "processing_stack=c001 flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=[Replace with zero] correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	selectWindow("Basefluor");
	close();
	selectWindow("Flat-field:c001");
	close();
	selectWindow("Dark-field:c001");
	close();
	selectWindow("c001");
	close();
	
	run("Image Sequence...", "format=TIFF open=["+seq_dir+File.separator+seq_start_name+"] file=c002 sort");
	rename("c002");
	run("BaSiC ", "processing_stack=c002 flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=[Replace with zero] correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	selectWindow("Basefluor");
	close();
	selectWindow("Flat-field:c002");
	close();
	selectWindow("Dark-field:c002");
	close();
	selectWindow("c002");
	close();
	
	run("Image Sequence...", "format=TIFF open=["+seq_dir+File.separator+seq_start_name+"] file=c003 sort");
	rename("c003");
	run("BaSiC ", "processing_stack=c003 flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	selectWindow("Flat-field:c003");
	close();
	selectWindow("c003");
	close();

	run("Merge Channels...", "c1=Corrected:c001 c2=Corrected:c002 c4=Corrected:c003 create");

	getDimensions(w, h, channels, slices, frames);

	run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames="+slices+" display=Composite");
	saveAs("Tiff", out_dir + File.separator + img + "_corrected.tif");
	run("HyperStackReg v05", "transformation=[Rigid Body] channel1 channel2 show");
	saveAs("Tiff", out_dir + File.separator + img + "_registered.tif");
	close();
	selectWindow(img + "_corrected.tif");
	close();
};


basedir = getDirectory("Choose a Directory ");
//setBatchMode(true);
baselist = countFiles(basedir);

print(baselist.length);

for (i=0; i<baselist.length; i++) {
	correctImg(baselist[i], basedir);
	print("======DONE=====", baselist[i]);
}