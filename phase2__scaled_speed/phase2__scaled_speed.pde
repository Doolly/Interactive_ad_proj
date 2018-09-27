import SimpleOpenNI.*;
SimpleOpenNI kinect;

PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector pre_leftHand = new PVector();
PVector pre_rightHand = new PVector();

PVector normalizedPosition = new PVector(2.25, 1.66); //(640, 480)->(1440, 800)
void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth();
  kinect.enableUser();// this changed
  //size(640, 480);
  size(1440, 800, P2D);
  fill(255, 0, 0);
}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0, width, height);
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
      drawSkeleton(userId);

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      PVector differenceVector = PVector.sub(pre_rightHand, rightHand);
      float magnitude = differenceVector.mag();
      differenceVector.normalize();
      pushMatrix();
      scale(4);
      fill(differenceVector.x * 255, differenceVector.y * 255, differenceVector.z * 255);
      text("mm/s: " + magnitude*0.06, 5, 10);
      popMatrix();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, pre_leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, pre_rightHand);
    }
  }
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
//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
