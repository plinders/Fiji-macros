//This FIJI macro convolutes a fluorescence lifetime image 
//with an equally sized fluorescence intensity image
//The resulting file is a FLIM image with
//the gray LUT showing the intensity and LUT 'physics' showing the lifetime.

//Macro created by the MembraneTrafficking in Immune Cells Lab:
//www.membranetrafficking.com

//Please cite our study: 
//Verboogen, D.R.J., GonzÃ¡lez Mancha, N., Ter Beest, M., & van den Bogaart, G. 
//Fluorescence lifetime imaging microscopy reveals rerouting of SNARE trafficking 
//driving dendritic cell activation. (2017) Elife. 6: e23525.
//PMID: 28524818

//tau image is opened and selected
var Intensity = 200000; //intensity of the images
var IDtau = getImageID(); //the imageID of the tau image
var NameTau = getTitle(); //the filename of the image
run("physics");
//run("Invert LUT");
setMinAndMax(1.6000, 3.0000); //contrast from 1.6 ns to 3 ns
//run("RGB Color");
run("Copy to System");
run("System Clipboard");
selectWindow(NameTau);
close();
NameTau = "Clipboard";
run("Split Channels"); //make RGB and split channels

//here the intensity image should be opened
open()
var IDint = getImageID(); //the imageID of the intensity image
var NameInt = getTitle(); //de filename of the image
run("Enhance Contrast", "saturated=0.35");

var NameTauRed = NameTau + " (red)"; //filename of the red output image
var NameTauGreen = NameTau + " (green)"; //filename of the green output image
var NameTauBlue = NameTau + " (blue)"; //filename of the blue output image

imageCalculator("Multiply create 32-bit", NameTauRed, NameInt); //convolute red
var IDflimRed = getImageID(); //the imageID
var NameFlimRed = getTitle(); //the filename of the image
close(NameTauRed);//close red tau channel

imageCalculator("Multiply create 32-bit", NameTauGreen, NameInt); //convolute green
var IDflimGreen = getImageID(); //the imageID
var NameFlimGreen = getTitle(); //the filename of the image
close(NameTauGreen);//close green tau channel

imageCalculator("Multiply create 32-bit", NameTauBlue, NameInt);  //convolute blue
var IDflimBlue = getImageID(); //the imageID
var NameFlimBlue = getTitle(); //the filename of the image
close(NameTauBlue);//close blue tau channel

close(NameInt); //close intensity image
run("Merge Channels...", "c1=[" + NameFlimRed + "] c2=[" + NameFlimGreen + "] c3=[" + NameFlimBlue + "] create"); //merge the convoluted images
var NameFlim32bit = getTitle(); //the filename of the merged convoluted image
Stack.setChannel(1); //set intensity of the red channel
setMinAndMax(0, Intensity);
Stack.setChannel(2); //set intensity of the green channel
setMinAndMax(0, Intensity);
Stack.setChannel(3); //set intensity of the blue channel
setMinAndMax(0, Intensity);
run("RGB Color"); //convert to RGB color
close(NameFlim32bit);//close the image with individual channels