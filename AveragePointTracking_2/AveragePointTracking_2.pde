// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;


PImage rgbimage;

int num = 60;
float mx[] = new float[num];
float my[] = new float[num];
float deg;

void setup() {
  size(1280, 1040);
  kinect = new Kinect(this);
  tracker = new KinectTracker();


  kinect.initDepth();
  kinect.initVideo();
  kinect.enableIR(false);

  deg = kinect.getTilt();
}

void draw() {
  background(255);
  tracker.track();  // Run the tracking analysis
    tracker.display();     // Show the image
  image(kinect.getVideoImage(), 640, 0);
  image(kinect.getDepthImage(), 0, 540);
  fill(255);
  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  fill(50, 100, 250, 200);
  noStroke();
  ellipse(v1.x, v1.y, 20, 20);

  // Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  fill(100, 250, 50, 200);
  noStroke();
  ellipse(v2.x, v2.y, 60, 60);

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "RIGHT increase threshold, LEFT decrease threshold", 10, 500);



  int which = frameCount % num;
  mx[which] = v2.x;
  my[which] = v2.y;

  for (int i = 0; i < num; i++) {
    // which+1 is the smallest (the oldest in the array)
    int index = (which+1 + i) % num;
    ellipse(mx[index], my[index], i, i);
  }
}
// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == RIGHT) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == LEFT) {
      t-=5;
      tracker.setThreshold(t);
    }
    else if (keyCode == UP) {
      deg++;
    } else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.setTilt(deg);
  }
}
