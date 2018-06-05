original = getImageID();
setBatchMode(true);
run("Select All");

for (i = 2; i <= nSlices; i++) {
	selectImage(original);
	setSlice(1);
	run("FFT");
	rename("a");
	
	selectImage(original);
	setSlice(i);
	run("FFT");
	rename("b");
	
	run("FD Math...", "image1=a operation=Correlate image2=b result=c do");
	
	List.setMeasurements;
	
	cx = getWidth / 2;
	cy = getHeight / 2;
	max = 0;
	
	// the maximum should be somewhere in the center
	for (y = cy - 20; y <= cy + 20; y++) {
		for (x = cx - 20; x <= cx + 20; x++) {
			pixel = getPixel(x, y);
			
			if (pixel > max) {
				max = pixel;
				dx = x;
				dy = y;
			}
			
		}
	}
	
	dx -= cx;
	dy -= cy;
	
	// close all temporary images
	selectImage("a");
	close();
	
	selectImage("b");
	close();
	
	selectImage("c");
	close();
	
	// correct for drift
	selectImage(original);
	setSlice(i);
	run("Translate...", "x=" + dx + " y=" + dy + " interpolation=Bilinear slice");
}

setBatchMode(false);
