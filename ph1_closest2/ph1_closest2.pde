import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;

void setup() {
 size (640, 480);  //only working with depth image now
 kinect = new SimpleOpenNI(this);
 kinect.setMirror(true);
 kinect.enableDepth();
 
}

void draw() {
 closestValue = 8000;
 kinect.update();
 
 int[] depthValues = kinect.depthMap();
 // for each row
 for (int y = 0; y< width; y++) {
   //for each pixel in each row
   for (int x = 0; x< height; x++) {
     //calculate the index for the currentPixel
     int i = x + y * height;
     //retrieve the depthValue for that pixel
     int currentDepthValue = depthValues[i];
     
     if (currentDepthValue > 0 && currentDepthValue < closestValue) {
        
        closestValue = currentDepthValue;
        closestX = x;
        closestY = y; 
     }
   }
 }
 // depthImage on screen
 PImage depthImage = kinect.depthImage();
 image(depthImage,0,0);
 
 //superimpose a red circle
 fill (255,0,0);
 ellipse(closestX, closestY, 25,25);
 
}
