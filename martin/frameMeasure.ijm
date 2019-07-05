roiManager("deselect");
n_rois = roiManager("count");

roiArr = newArray();
for (i = 0; i < n_rois; i++) {
	roiManager("select", i);
	name = Roi.getName();
	coords = split(name, "-");
	frameInt = parseInt(coords[0]);
	roiArr = Array.concat(roiArr, frameInt);
};



maxFrame = roiArr[roiArr.length-1];

var totalLength = 0;
for (frame = 1; frame <= maxFrame; frame++) {
	roiPerFrame = newArray();
	for (i = 0; i < roiArr.length; i++) {
		if (roiArr[i] == frame) {
			roiPerFrame = Array.concat(roiPerFrame, i); 
		}
	}
	
	if (roiPerFrame.length > 1) {
		roiManager("select", roiPerFrame);
		roiManager("combine");
	}
	run("Measure");
	
}

print(frame);


