/*------ Headers to Include ------*/
import processing.video.*;
import SimpleOpenNI.*;
import processing.opengl.*;
/*------ Value Define ------*/

/*------ Objects ------*/
Movie routine_movie;
Movie opening_movie;
SimpleOpenNI kinect;
PImage result;

/*------ Functions ------*/

/*------ Global Variables ------*/
int seq = 3;

int time_ms;
int time_stamp;


void setup() {
  size(1440, 800, P3D);
  //size(640, 480,P2D);
  //fullScreen(P2D);

  smooth(4);

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
  text_setup();
  time_stamp = millis();
  lastTime = millis();
}

void draw() {
  background(0, 60);
  kinect.update();
  userList = kinect.getUsers();
  if (userList.length>0) {
  }

  if (seq == -1) {
    routine_movie.loop();
    image(routine_movie, 0, 0, width, height);
  } 
  if (seq == 0) { // 사람이 오면으로 변경   userList.length>0
    seq = 0;
    routine_movie.stop();
    opening_movie.play();
    image(opening_movie, 0, 0, width, height);
    float md = opening_movie.duration();
    float mt = opening_movie.time();
    if (mt == md) {
      time_stamp = millis();
      seq = 1;
    }
  } else if (seq == 1) {
    phase1_kinect_update();
    if (closestValue > close_d && closestValue < far_d) {
      phase1_DP_update(closestX, closestY);
    }
    phase1_DP();
  } else if (seq == 2) {
    text_1();
  } else if (seq == 3) {
    phase2_kinect_update();
    getMotion();
  } else if (seq == 4) {
    text_1();
  }
}
