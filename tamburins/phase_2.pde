PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector pre_leftHand = new PVector();
PVector pre_rightHand = new PVector();

PVector normalizedPosition = new PVector(2.25, 1.66); //(640, 480)->(1440, 800)

PVector leftShoulder = new PVector();
PVector rightShoulder = new PVector();

void phase2_kinect_update() {
  kinect.update();
  image(kinect.depthImage(), 0, 0, width, height);
}

void phase2_DP_update() {
}

int getMotion() {
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    if ( kinect.isTrackingSkeleton(userId)) {
      drawSkeleton(userId);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      //getDistance(leftHand, rightHand);

      getDistance(pre_rightHand, rightHand);

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, pre_leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, pre_rightHand);
    }

 if (getDistance(leftShoulder, rightHand)<15 || getDistance(rightShoulder, leftHand)<15) {
      fill(255);
      text("touch", width/2, 150);
      text(getDistance(leftShoulder, rightHand), width/2, 100);
    }
    else if (getDistance(pre_rightHand, rightHand)>15) {
      fill(255);
      text("through ", width/2, 150);
      text(getDistance(pre_rightHand, rightHand), width/2, 100);
    }
    else if (getDistance(leftHand, rightHand)<15) {

      fill(255);
      text("clap", width/2, 150);
      text(getDistance(leftHand, rightHand), width/2, 100);
    }
   
  }
  return 0;
}
float getDistance (PVector a, PVector b) {
  PVector differenceVector = PVector.sub(a, b);
  float magnitude = differenceVector.mag()*0.1;
  fill(255);
  text("Centimeters: " + magnitude, width/2, 100);
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
  ellipse(pixelPosition.x, pixelPosition.y, 15, 15);
}

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
