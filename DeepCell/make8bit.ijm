// This macro opens a directory of tiff images and resaves each 
//      as 8-bit 
//	Univ of Chicago, Vytas Bindokas, Jul'06  requires("1.35l"); 

dir = getDirectory("Choose a Directory "); 
list = getFileList(dir); 
print(list.length); 

	setBatchMode(true);               // runs up to 6 times faster 
	for (f=0; f<list.length; f++) {	//main files loop 
    	path = dir+list[f]; 
		 print(path); 
    		showProgress(f, list.length); 
    	if (!endsWith(path,"/")) open(path); 
	if (nImages>=1) { 
			if (endsWith(path,"f")) {	//do only tif files 

   start = getTime(); 
//   t=getTitle(); 
//   s=lastIndexOf(t, '.'); 
//   t=substring(t, 0,s); 
//   t=replace(t," ","_"); 
 //  t2= t +'B16.tif'; 
	run("8-bit");
	run("Canvas Size...", "width=1024 height=1024 position=Center zero");
//   rename(t2); 
   saveAs("tif", path); 
   run("Close"); 
       } 
	} 
} 
print((getTime()-start)/1000); 