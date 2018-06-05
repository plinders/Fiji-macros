var height = getHeight();
var width = getWidth();
setSlice(3);
run("Delete Slice", "delete=channel");
//setSlice(1);
//run("Delete Slice", "delete=channel");
setSlice(1);

var initX = round(0.25 * width);
var initY = round(0.25 * height);
var boxW = round(0.5 * width);
var boxH = round(0.5 * height);


run("Fire");
makeRectangle(initX, initY, boxW, boxH);

var alignInput = "method=5 windowsizex="+boxW+" windowsizey="+boxH+" x0="+initX+" y0="+initY+" swindow=0 subpixel=false itpmethod=0 ref.slice=1 show=true";

run("Align slices in stack...", alignInput);
