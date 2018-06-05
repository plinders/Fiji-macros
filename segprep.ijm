function bfCorrect(img) {
	open(img);
	var X_LENGTH = 8;
	var Y_LENGTH = 8;
	var RESOLUTION = 1024;
	var windowname = getTitle();

	arr = newArray();
	dir = getDirectory("image");
	filename = getInfo("image.filename");
	outdir = dir + File.separator + "Corrected";

	roiManager("reset");

	for (y = 0; y < Y_LENGTH; y++) {
		for (x = 0; x < X_LENGTH; x++) {
			xpos = RESOLUTION * x;
			ypos = RESOLUTION * y;
			makeRectangle(xpos, ypos, RESOLUTION, RESOLUTION);
			newname = "x"+x+"y"+y;
			Roi.setName(newname);
			roiManager("Add");

		}
	}

	for (i = 0; i < roiManager("count"); i++) {
		roiManager("Select", i);
		rName = Roi.getName();
		run("Duplicate...", "title="+rName);
		arr = Array.concat(arr, rName);
		selectWindow(windowname);
		// print(Roi.getName());
	}

	run("Images to Stack", "name=Stack title=y use");
	run("BaSiC ", "processing_stack=Stack flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	//Array.print(arr);
	newdir = dir + File.separator + "out";
	File.makeDirectory(newdir);
	selectWindow("Corrected:Stack");
	run("Image Sequence... ", "format=TIFF use save=["+newdir+"/.tif]");

	run("Grid/Collection stitching", "type=[Filename defined position] order=[Defined by filename         ] grid_size_x=8 grid_size_y=8 tile_overlap=0 first_file_index_x=0 first_file_index_y=0 directory=[D:\\180518 PL025.2\\BF\\Input\\out] file_names=x{x}y{y}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 display_fusion computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");

	selectWindow("Fused");
	saveAs("Tiff", outdir+File.separator+filename+".tif");

	selectWindow(filename+".tif");
	close();
	selectWindow("Corrected:Stack");
	close();
	selectWindow("Flat-field:Stack");
	close();
	selectWindow("Stack");
	close();
	selectWindow(filename);
	close();
	seglist = getFileList(newdir);
	 for (i=0; i<seglist.length; i++)
     	File.delete(newdir + File.separator + seglist[i]);
  	//ok = File.delete(myDir);
	//File.delete(newdir);
}

print('step1');
input = getDirectory("Choose a Directory ");
print('step2');
filelist = getFileList(input);
// print(filelist);

for (i = 0; i < filelist.length; i++) {
	if (endsWith(filelist[i], ".tif"))  {
		print('starting');
		bfCorrect(filelist[i]);
		print(i + " done");
	}
}
