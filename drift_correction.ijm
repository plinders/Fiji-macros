// 20160302 drift correction
// measures drift on one image and 
// corrects for drift on another image (can be the same image)
//
// C.M. Punter (c.m.punter@rug.nl)
// Rijksuniversiteit Groningen, 2016
//
// 

max_drift = 50;

// determine all open images
image_titles = newArray(nImages);
for (i = 0; i < nImages; i++) {
    selectImage(i + 1);
    image_titles[i] = getTitle;
}

// show dialog
Dialog.create("Drift Correction");
Dialog.addChoice("Measure_image", image_titles);
Dialog.addChoice("Correct_image", image_titles);
Dialog.show;

measure_image = Dialog.getChoice;
correct_image = Dialog.getChoice;

// measure drift using fft (correlation)
setBatchMode(true);

selectImage(measure_image);
run("Properties...", "pixel_width=1 pixel_height=1");
n = nSlices;

slices = newArray(nSlices);
x_drift = newArray(nSlices);
y_drift = newArray(nSlices);

setSlice(1);
run("FFT");
rename("fft_first");

run("Set Measurements...", "center redirect=None decimal=5");

for (s = 2; s <= n; s++) {
    
    selectImage(measure_image);
    setSlice(s);
    run("FFT");
    rename("fft_n");
    
    run("FD Math...", "image1=fft_first operation=Correlate image2=fft_n result=fft_correlated do");
    
    makeRectangle(getWidth / 2 - max_drift, getHeight / 2 - max_drift, max_drift * 2, max_drift * 2);
    List.setMeasurements;
	
	slices[s - 2] = s;
    x_drift[s - 2] = parseFloat(List.get("XM")) - getWidth / 2;
	y_drift[s - 2] = parseFloat(List.get("YM")) - getHeight / 2;
	
    close("fft_n");
    close("fft_correlated");
}

close("fft_first");

selectImage(correct_image);
run("Properties...", "pixel_width=1 pixel_height=1");

for (s = 2; s <= nSlices; s++) {
    setSlice(s);
    run("Translate...", "x=" + x_drift[s - 2] + " y=" + y_drift[s - 2] + " interpolation=Bilinear slice");
    IJ.log("x=" + x_drift[s - 2] + " y=" + y_drift[s - 2]);
}



setBatchMode(false);



