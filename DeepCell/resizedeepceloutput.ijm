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

function processDir(basedir, dir) {
	workdir = basedir + File.separator + dir + File.separator + "out" + File.separator;
	list = getFileList(workdir);
	//print(workdir);
	//Array.print(list);

	setBatchMode(true);               // runs up to 6 times faster 
	for (f=0; f<list.length; f++) {	//main files loop 
    	path = workdir+list[f]; 
		if (!endsWith(path,"/")) open(path); 
		if (nImages>=1) { 
			if (endsWith(path,"f")) {	//do only tif files 

   start = getTime(); 
	run("8-bit");
	run("Canvas Size...", "width=1024 height=1024 position=Center zero");
   saveAs("tif", path); 
   run("Close"); 
       	} 
		}	
	}
}


setBatchMode(true);
basedir = getDirectory("Choose a Directory ");
count = 0;
//countDirs(basedir);
dirlist = countDirs(basedir);
//print("number of dirs");
//print(count);
//print("actual dirs");
//Array.print(dirlist);
for (i=0; i<dirlist.length; i++) {
	processDir(basedir, dirlist[i]);
}
