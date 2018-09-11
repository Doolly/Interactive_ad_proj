import SimpleOpenNI.*;
import processing.opengl.*;
SimpleOpenNI  kinect;      
int [] userMap;
boolean mode;
PImage depthImage;
PImage userImage;
PImage rgbImage;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  if (kinect.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  kinect.enableDepth(); // enable depthMap generation 
  kinect.enableRGB();  // enable RGB camera
  kinect.enableUser(); // enable skeleton generation for all joints
  kinect.alternativeViewPointDepthToImage(); // turn on depth-color alignment 
  background(0);
}

void draw()
{
  background(0);
  kinect.update(); // update the cam
  rgbImage = kinect.rgbImage(); // get the Kinect color image
  rgbImage.loadPixels(); // prepare the color pixels

  depthImage = kinect.depthImage(); // get the Kinect Depth image
  depthImage.loadPixels(); // prepare the Depth pixels 

  int[] userList = kinect.getUsers();
  if (userList.length>0)
  {
    userMap = kinect.userMap();

    loadPixels(); // load sketches pixels
    if (mode==true) {
      for (int i = 0; i < userMap.length; i++) { 
        if (userMap[i] != 0) { // if the current pixel is on a user
          //pixels[i] = depthImage.pixels[i];
          pixels[i] = color(200, 0, 200); // wanted color
        }
      }
    } else {
      for (int i=0; i<userMap.length; i++) {
        if (userMap[i]!=0) { // if the current pixel is on a user
          pixels[i] = rgbImage.pixels[i]; // set the sketch pixel to the color pixel
        } else{
          pixels[i] = color(0);
        }
      }
    }
    updatePixels();
  }
}

void keyPressed() {
  if (key == 'c') {
    mode = !mode;
  }
}
