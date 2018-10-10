void movieEvent(Movie m) {
  m.read();
}

void mousePressed() {
}

void keyPressed() {
  if (key == 'c') {
    seq=-1;
  } else if (key == '1') {
    seq=3;
    textT.line = 4;
  } else if (key == '2') {
    seq=6;
    textT.line = 8;
  } else if (key == '3') {
    seq=9;
    textT.line = 10;
  } else if (key == CODED) {
    if (keyCode == RIGHT) {
      seq ++;
    } else if (keyCode == LEFT) {
      seq--;
    } else if (keyCode == UP) {
    } else if (keyCode == DOWN) {
    }
  }
}


void userimg_DP(float uR, float uG, float uB, float uA, float bR, float bG, float bB, float bA) {
  userMap = kinect.userMap();
  userImage.loadPixels(); //현재 사이즈로 부르고
  userImage.resize(640, 480); // 줄였다가
  for (int y = 0; y< 480; y++) { //때려박고
    for (int x = 0; x< 640; x++) { 
      int i = x + y * 640; 
      if (userMap[i]!=0) { 
        userImage.pixels[i] = color(uR, uG, uB, uA);
      } else {
        userImage.pixels[i] = color(bR, bG, bB, bA);
      }
    }
  }
  userImage.updatePixels();  //갱신된 배열값들을 이미지로 로드
  userImage.resize(displayWidth, displayHeight); // 다시 늘려서
  image(userImage, 0, 0);
}

void userimg_DP(float R, float G, float B, float al, PImage back) {
  userMap = kinect.userMap();
  userImage.loadPixels(); //현재 사이즈로 부르고
  userImage.resize(640, 480); // 줄였다가
  for (int y = 0; y< 480; y++) { //때려박고
    for (int x = 0; x< 640; x++) { 
      int i = x + y * 640; 
      if (userMap[i]!=0) { 
        userImage.pixels[i]  = color(R, G, B);
      } else {

        float r=red(back.pixels[i]);
        float g=green(back.pixels[i]);
        float b=blue(back.pixels[i]);
        userImage.pixels[i] = color(r, g, b, al);
      }
    }
  }
  userImage.updatePixels();  //갱신된 배열값들을 이미지로 로드
  userImage.resize(displayWidth, displayHeight); // 다시 늘려서
  image(userImage, 0, 0);
}

void getMotion() {
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    if ( kinect.isTrackingSkeleton(userId)) {
      //drawSkeleton(userId);
      drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
      drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
      drawJoint(userId, SimpleOpenNI.SKEL_TORSO);

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    }
  }
}
float getDistance (PVector a, PVector b) {
  PVector differenceVector = PVector.sub(a, b);
  float magnitude = differenceVector.mag()*0.1;
  //fill(255);
  //text("Centimeters: " + magnitude, displayWidth/2, 100);
  differenceVector.normalize();
  pushMatrix();
  scale(4);
  popMatrix();
  return magnitude;
}

void drawSkeleton(int userId) {
  noStroke();
  fill(255, 0, 0);
  drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

void drawJoint(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = kinect.getJointPositionSkeleton(userId, jointID, 
    joint);
  if (confidence < 0.5) {
    return;
  }
  PVector convertedJoint = new PVector();
  kinect.convertRealWorldToProjective(joint, convertedJoint);
  PVector pixelPosition = PVectorPlus.mult(convertedJoint, normalizedPosition); //변환
  //ellipse(pixelPosition.x, pixelPosition.y, 15, 15);
  if (jointID == SimpleOpenNI.SKEL_RIGHT_HAND) {
    rightHand_cv = pixelPosition;
    ellipse(pixelPosition.x, pixelPosition.y, 15, 15);
  } else if (jointID == SimpleOpenNI.SKEL_LEFT_HAND) {
    leftHand_cv = pixelPosition;
    ellipse(pixelPosition.x, pixelPosition.y, 15, 15);
  } else if (jointID ==SimpleOpenNI.SKEL_TORSO) {
    torso_cv = pixelPosition;
  }
  noStroke();
  fill(255, 0, 0);
  ellipse(rightHand_cv.x, rightHand_cv.y, 15, 15);
  ellipse(leftHand_cv.x, leftHand_cv.y, 15, 15);
}

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
