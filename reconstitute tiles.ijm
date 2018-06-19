function countDirs(basedir) {
  list = getFileList(basedir);
  worklist = newArray();
  for (i=0; i<list.length; i++) {
      if (endsWith(list[i], "/") && !endsWith(list[i], "f")) {
          count++;
          worklist = Array.concat(worklist, list[i]);
      }
  }
  //print('temp');
  //Array.print(worklist);
  
  //print(list);
  return worklist;
}

function reconstituteTiles(basedir, direc) {
	workdir = basedir + File.separator + direc + "out";
	run("Grid/Collection stitching", "type=[Filename defined position] order=[Defined by filename         ] grid_size_x=8 grid_size_y=8 tile_overlap=0 first_file_index_x=0 first_file_index_y=0 directory="+workdir+" file_names=feature_0_{x}{y}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Intensity of random input tile] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 display_fusion computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	selectWindow("Fused");
	rename("feature_0");
	run("Grid/Collection stitching", "type=[Filename defined position] order=[Defined by filename         ] grid_size_x=8 grid_size_y=8 tile_overlap=0 first_file_index_x=0 first_file_index_y=0 directory="+workdir+" file_names=feature_1_{x}{y}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Intensity of random input tile] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 display_fusion computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	selectWindow("Fused");
	rename("feature_1");
	run("Grid/Collection stitching", "type=[Filename defined position] order=[Defined by filename         ] grid_size_x=8 grid_size_y=8 tile_overlap=0 first_file_index_x=0 first_file_index_y=0 directory="+workdir+" file_names=feature_2_{x}{y}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Intensity of random input tile] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 display_fusion computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	selectWindow("Fused");
	rename("feature_2");
	run("Images to Stack", "name=Stack title=feature_ use");
	selectWindow("Stack");
	name = File.getName(direc);
	saveAs("tif", basedir + File.separator + name + "_segmented.tif");
}

setBatchMode(true);
basedir = getDirectory("Choose a Directory ");
count = 0;

dirlist = countDirs(basedir);

for (i=0; i<dirlist.length; i++) {
	reconstituteTiles(basedir, dirlist[i]);
}