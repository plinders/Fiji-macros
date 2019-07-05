import ij.blob.*;

private ManyBlobs allBlobs;

public void someMethod(ImagePlus imp) {
    ManyBlobs allBlobs = new ManyBlobs(imp); // Extended ArrayList
        allBlobs.setBackground(0); // 0 for black, 1 for 255
    allBlobs.findConnectedComponents(); // Start the Connected Component Algorithm
    allBlobs.get(0).getPerimeter(); // Read the perimeter of a Blob
}