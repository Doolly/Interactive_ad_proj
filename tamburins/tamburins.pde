/*------ Headers to Include ------*/
import processing.video.*;
import SimpleOpenNI.*;


/*------ Value Define ------*/

/*------ Objects ------*/
Movie routine_movie;
Movie opening_movie;
SimpleOpenNI kinect;
PImage result;

/*------ Functions ------*/

/*------ Global Variables ------*/
int phase = 1;
int time_ms;
int time_stamp;


void setup() {
  size(1440, 800, P2D);
  //fullScreen();
  //frameRate(30);
  smooth(4);
  time_stamp = millis();

  routine_movie = new Movie(this, "sample_video_1.mp4");
  opening_movie = new Movie(this, "sample_video_2.mp4");

  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth(); // enable depthMap generation 
  kinect.enableRGB();  // enable RGB camera
  kinect.enableUser(); // enable skeleton generation for all joints
  kinect.alternativeViewPointDepthToImage(); // turn on depth-color alignment 

  result = createImage(width, height, RGB);
  phase1_setup ();
}

void draw() {
  background(0, 60);
  println("phase = ", phase);

  if (phase == -1) {
    routine_movie.loop();
    image(routine_movie, 0, 0, width, height);
  } else if (phase == 0) {
    routine_movie.stop();
    opening_movie.play();
    image(opening_movie, 0, 0, width, height);
    float md = opening_movie.duration();
    float mt = opening_movie.time();
    if (mt == md) {
      time_stamp = millis();
      phase = 1;
    }
  } else if (phase == 1) {
    phase1_kinect_update();
    phase1_DP_update(closestX, closestY);
    phase1_display();
  }
}
