function wellCorrect(dir) {
    filelist = getFileList(dir);
    subfolders = newArray();
    for (i=0; i<filelist.length; i++) {
        if (endsWith(filelist[i], "/")) {
            subfolders = Array.concat(subfolders, filelist[i]);
        }
    }

    for (i=0; i<subfolders.length; i++) {
        imglist = getFileList(dir + File.separator + subfolders[i]);
        for (img=0; img<imglist.length; img++) {
            if (endsWith(imglist[img], "_ch03.tif")) {
                open(dir + File.separator + subfolders[i] + File.separator + imglist[img]);
            }
        }
    }

    run("Images to Stack", "name=Stack title=[] use");
	run("BaSiC ", "processing_stack=Stack flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	selectWindow("Flat-field:Stack");
	close();
	selectWindow("Stack");
    close();
    selectWindow("Corrected:Stack");    
    slices = nSlices();
    for (slice=1; slice<=slices; slice++) {
        setSlice(slice);
        sliceName = getInfo("slice.label");
        origdir = substring(sliceName, 1, indexOf(sliceName, "_ch03"));
        run("Duplicate...", sliceName);
        for (folder=0; folder<subfolders.length; folder++) {
            trimFolder = substring(subfolders[folder], 0, indexOf(subfolders[folder], '/'));
            if (matches(origdir, trimFolder)) {
                saveAs("Tiff", dir + File.separator + subfolders[folder] + File.separator + sliceName + "_corrected.tif");
                close();
            }
        }
    }
    selectWindow("Corrected:Stack");
    close();
    


    
    
}

input = getDirectory("Choose a Directory ");
folderlist = getFileList(input);
wells = newArray();
for (i=0; i<folderlist.length; i++) {
    if (endsWith(folderlist[i], "/") && !endsWith(folderlist[i], "Composites/")) {
        wells = Array.concat(wells, folderlist[i]);
    }
}

Array.print(wells);
for (well=0; well<wells.length; well++) {
    wellCorrect(input + File.separator + wells[well]);
}
