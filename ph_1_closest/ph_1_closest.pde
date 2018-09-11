import SimpleOpenNI.*; 
SimpleOpenNI kinect; 

PImage depthCam; 
PImage result;

void setup() {
  size(640,480);
  background(0);
  kinect  = new SimpleOpenNI(this);
  kinect.enableDepth();
  result = createImage(width, height, RGB);
}

void draw() {
  background(0);
  kinect.update();
  depthCam = kinect.depthImage();
  int[] depthVals = kinect.depthMap(); // get the depthMap (mm) values
  result.loadPixels(); // load the pixel array of the result image

  //go through the matrix - for each row go through every column
  for (int y=0; y<depthCam.height; y++) {
    //go through each col
    for (int x =0; x<depthCam.width; x++) {
      // get the location in the depthVals array
      int loc = x+(y*depthCam.width);
      // if the depth values of the sampled image are in range
      if (depthVals[loc]< 900) {
        //let the pixel value in the result image be white
        result.pixels[loc] = color(255, 0, 0);
      } else {
        result.pixels[loc] = depthCam.pixels[loc];
      }
    }
  }
  // update
  result.updatePixels();
  //display the result
  image(result, 0, 0);
}
