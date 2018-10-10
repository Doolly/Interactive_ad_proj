/*------ Headers to Include ------*/
import processing.video.*;
import SimpleOpenNI.*;
import processing.opengl.*;
/*------ Value Define ------*/

/*------ Objects ------*/
Movie routine_movie;
Movie opening_movie;
Movie outro_movie;
SimpleOpenNI kinect;
PImage result;

PImage phase1_bg;
PImage phase2_bg;
PImage phase3_bg;

/*------ Functions ------*/

/*------ Global Variables ------*/
int seq = -1;

int p2_count;
boolean p2_wait=false;

void setup() {
  //size(1440, 900, P3D); 
  fullScreen(P3D);
  smooth(6);
  routine_movie = new Movie(this, "routine.mp4");
  opening_movie = new Movie(this, "intro.mp4");
  outro_movie = new Movie(this, "outro.mp4");
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth(); // enable depthMap generation 
  kinect.enableRGB();  // enable RGB camera
  kinect.enableUser(); // enable skeleton generation for all joints
  kinect.alternativeViewPointDepthToImage(); // turn on depth-color alignment 

  result = createImage(displayWidth, displayHeight, RGB);
  phase1_setup();
  text_setup();
  phase2_shape_setup();
  //ps2 = new ParticleSystem2(new PVector(displayWidth/2, 300), particleClr2[(int)random(0, 4)]);
  pts = new ArrayList<Particle3>();
  phase1_bg = loadImage("phase1_bg.png");
  phase3_bg = loadImage("phase3_bg.png");
  phase2_bg = loadImage("phase2_bg.png");
}

void draw() {
  //background(0, 60);
  kinect.update();
  userList = kinect.getUsers();

  if (seq == -1) {
    routine_movie.loop();
    image(routine_movie, 0, 0, displayWidth, displayHeight);
    if (userList.length>0) {
      seq =0;
    }
  } 
  if (seq==0) { 
    routine_movie.stop();
    opening_movie.play();
    image(opening_movie, 0, 0, displayWidth, displayHeight);
    float md = opening_movie.duration();
    float mt = opening_movie.time();
    if (mt > md-0.5) {
      opening_movie.stop();
      textT.lastTime = millis();
      seq = 1;
    }
  } else if (seq == 1) {
    background(text1_bg);
    textT.text_2("See-Through", "나를 온전히 마주하여 들여다보다");
    if (textT.line == 2) seq ++;
  } else if (seq == 2) {
    background(text1_bg);
    textT.text_2("손을 뻗어 그림을 찢고 내면으로 한걸음 들어가 보세요", " ");
    if (textT.line == 4) seq ++;
  } else if (seq == 3) {
    println(closestValue);
    phase1_kinect_update();
    if ( userList.length>0) {
      phase1_DP_update(closestX, closestY);
      userimg_DP(255, 255, 255, 20, phase1_bg);
      phase1_DP();
    } else {
      image(img, 0, 0);
    }
    if (closestValue<phase_throttle) {
      textT.lastTime = millis();
      seq = 4;
    }
  } else if (seq == 4) {
    getMotion();
    background(text2_bg);
    textT.text_2("Boundless", "무한하고 다채로운 나를 발견하다");
    if (textT.line == 6) seq ++;
  } else if (seq == 5) {
    getMotion();
    background(text2_bg);
    textT.text_2("그래픽을 터치하고 두 손을 맞잡으며 당신의 색을 찾아보세요", " ");
    if (textT.line == 8) seq ++;
  } else if (seq == 6) {
    //getMotion();
    //kinect.update();
    userimg_DP(200, 200, 200, 255, phase2_bg);
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

      if (ps.poped && ps.clicked) {
        p2_count++;
      }
    }

    if (p2_count>6) {
      if (p2_wait==false) {
        for (ParticleSystem ps : systems) {
          if (ps.clicked) {
            ps.opacity=-500;
          }
        }
        textT.lastTime = millis();
        p2_wait=true;
      } else if (p2_wait==true) {
        if (millis()-textT.lastTime>10000)
          seq = 7;
      }
    }
    p2_count=0;
  } else if (seq == 7) {
    getMotion();
    background(text3_bg);
    textT.text_2("Touch Moment", "어루만짐으로 내가 작품이 되는 순간");
    if (textT.line == 10) seq ++;
  } else if (seq == 8) {
    getMotion();
    background(text3_bg);
    textT.text_2("아름다운 내 모습이 드러날 때까지 내 어깨를 어루만져 주세요", "모습이 드러나면 멋진 자세를 취해보세요");
    if (textT.line == 12) seq ++;
  } else if (seq == 9) {
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    if (userList.size() > 0) {
      int userId = userList.get(0);
      if (kinect.isTrackingSkeleton(userId)) {
        if (frame_start==false) {
          drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
          kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);      
          kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
          kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
          kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

          phase_3();
          frame(torso_cv.x, torso_cv.y);

          if (getDistance(leftShoulder, rightHand)<15) {
            target1_start=true;
          }
          textT.lastTime=millis();
        } else if (frame_start==true) {
          frame(torso_cv.x, torso_cv.y);

          if (millis() - textT.lastTime >= 5000) {
            saveFrame();
            seq++;
          }
        }
      }
    }
  } else if (seq == 10) {
    outro_movie.play();
    image(outro_movie, 0, 0, displayWidth, displayHeight);
    float md = outro_movie.duration();
    float mt = outro_movie.time();
    if (mt > md-0.5) {
      delay(5000);
      seq = -1;
      textT.line = 0;
      frameCount=-1;
    }
  }
}
