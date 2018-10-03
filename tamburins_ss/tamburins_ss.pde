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
int seq = 9;

int p2_count;

int time_ms;
int time_stamp;


void setup() {
  size(1440, 800, P3D); 
  //size(640, 480,P2D);
  //fullScreen(P2D);
  smooth(4);
  routine_movie = new Movie(this, "routine.mp4");
  opening_movie = new Movie(this, "intro.mp4");

  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth(); // enable depthMap generation 
  kinect.enableRGB();  // enable RGB camera
  kinect.enableUser(); // enable skeleton generation for all joints
  kinect.alternativeViewPointDepthToImage(); // turn on depth-color alignment 

  result = createImage(width, height, RGB);
  phase1_setup();
  text_setup();
  time_stamp = millis();
  //lastTime = millis();
  phase2_shape_setup();
}

void draw() {
  background(0, 60);
  kinect.update();
  userList = kinect.getUsers();


  if (seq == -1) {
    routine_movie.loop();
    image(routine_movie, 0, 0, width, height);
    if (userList.length>0) {
      seq =0;
    }
  } 
  if (seq==0) { // 사람이 오면으로 변경   userList.length>0
    //seq = 0;
    routine_movie.stop();
    opening_movie.play();
    image(opening_movie, 0, 0, width, height);
    float md = opening_movie.duration();
    float mt = opening_movie.time();
    if (mt > md-0.5) {
      textT.lastTime = millis();
      seq = 1;
    }
  } else if (seq == 1) {
    background(text1_bg);
    textT.text_2("See-Through", "나를 온전히 마주하여 들여다보다");
    if (textT.line == 2) seq ++;
  } else if (seq == 2) {
    background(text1_bg);
    textT.text_1("손을 뻗어 그림을 찢고 내면으로 들어가 보세요");
    if (textT.line == 4) seq ++;
  } else if (seq == 3) {
    phase1_kinect_update();
    if ( userList.length>0) {
      phase1_DP_update(closestX, closestY);
      userimg_DP(255, 255, 255, 60, phase1_bg);
      phase1_DP();
    } else {
      image(img, 0, 0);
    }
    if (closestValue<phase_throttle) {
      textT.lastTime = millis();
      seq = 4;
    }
  } else if (seq == 4) {
    background(text2_bg);
    textT.text_2("Boundless", "무한하고 다채로운 나를 발견하다");
    if (textT.line == 6) seq ++;
  } else if (seq == 5) {
    background(text2_bg);
    textT.text_1("손으로 그래픽을 만지고 던지며 당신의 색을 찾아보세요");
    if (textT.line == 8) seq ++;
  } else if (seq == 6) {
    phase2_kinect_update();
    getMotion();
    if (getDistance(leftHand, rightHand)<15) {
      for (ParticleSystem ps : systems) {
        if (ps.poped && !ps.clicked) {
          ps.reverseGravity();
        }
      }
    }
    for (ParticleSystem ps : systems) {
      ps.check(rightHand_cv);
      ps.run(rightHand_cv);
      //ps.check(leftHand_cv);
      //ps.run(leftHand_cv);
      ps.display();
    }
    //////////////////////////////////////////////
    for (ParticleSystem ps : systems) {
      if (ps.poped && ps.clicked) {
        p2_count++;
      }
    }
    if (p2_count>3) {
      for (ParticleSystem ps : systems) {
        if (ps.clicked) {
          ps.opacity=-600;
        }
      }
      textT.lastTime = millis();
      seq = 7;
      p2_count=0;
    }
  } else if (seq == 7) {
    background(text3_bg);
    textT.text_2("Touch Moment", "어루만짐으로 내가 작품이 되는 순간");
    if (textT.line == 10) seq ++;
  } else if (seq == 8) {
    background(text3_bg);
    textT.text_1("내 어깨를 마음껏 쓰다듬고 어루만져 주세요");
    if (textT.line == 12) seq ++;
  } else if (seq == 9) {
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    if (userList.size() > 0) {
      int userId = userList.get(0);
      if ( kinect.isTrackingSkeleton(userId)) {
        getMotion();
        phase_3();
      }
    }
  } else if (seq == 10) {
  }
  println(textT.line);
}
