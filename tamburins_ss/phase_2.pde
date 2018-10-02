PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector pre_leftHand = new PVector();
PVector pre_rightHand = new PVector();
PVector normalizedPosition = new PVector(2.25, 1.66); //(640, 480)->(1440, 800)
PVector leftShoulder = new PVector();
PVector rightShoulder = new PVector();

PVector rightHand_cv = new PVector();

ArrayList<ParticleSystem> systems;
int count_sys = 5;
PShape[] shapes = new PShape[count_sys];
PImage [] flower = new PImage[count_sys];
float partSize;

void phase2_kinect_update() {
  kinect.update();
  userimg_DP(200, 200, 200);
}
void phase2_shape_setup() {
  noStroke();
  systems = new ArrayList<ParticleSystem>();
  partSize = random(70, 100);
  flower[0] = loadImage("flower[1].png");
  flower[1] = loadImage("flower[1].png");
  flower[2] = loadImage("flower[2].png");
  flower[3] = loadImage("flower[3].png");
  flower[4] = loadImage("flower[2].png");

  for (int i = 0; i < count_sys; i++) {
    shapes[i] = createShape();
    shapes[i].beginShape(QUAD);
    shapes[i].noStroke();
    shapes[i].texture(flower[i]);       
    shapes[i].normal(0, 0, 1);
    shapes[i].vertex(-partSize/2, -partSize/2, 0, 0);
    shapes[i].vertex(+partSize/2, -partSize/2, flower[i].width, 0);
    shapes[i].vertex(+partSize/2, +partSize/2, flower[i].width, flower[i].height);
    shapes[i].vertex(-partSize/2, +partSize/2, 0, flower[i].height);
    shapes[i].endShape();
  }
  for (int i = 0; i < count_sys; i++) {
    systems.add(new ParticleSystem(300, new PVector(random(0, width), random(0, height)), shapes[i]));
  }
}

void getMotion() {
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    if ( kinect.isTrackingSkeleton(userId)) {
      //drawSkeleton(userId);
      drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      ////getDistance(leftHand, rightHand);
      ////getDistance(pre_rightHand, rightHand);

      //kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, pre_leftHand);      
      //kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, pre_rightHand);
    }

    //if (getDistance(leftShoulder, rightHand)<15 || getDistance(rightShoulder, leftHand)<15) {
    //  fill(255);
    //  text("touch", width/2, 150);
    //  text(getDistance(leftShoulder, rightHand), width/2, 100);
    //} else if (getDistance(pre_rightHand, rightHand)>15) {
    //  fill(255);
    //  text("through ", width/2, 150);
    //  text(getDistance(pre_rightHand, rightHand), width/2, 100);
    //} else if (getDistance(leftHand, rightHand)<15) {

    //  fill(255);
    //  text("clap", width/2, 150);
    //  text(getDistance(leftHand, rightHand), width/2, 100);
    //}
  }
}
float getDistance (PVector a, PVector b) {
  PVector differenceVector = PVector.sub(a, b);
  float magnitude = differenceVector.mag()*0.1;
  //fill(255);
  //text("Centimeters: " + magnitude, width/2, 100);
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
  rightHand_cv = pixelPosition;
  noStroke();
  fill(255, 0, 0);
  ellipse(rightHand_cv.x, rightHand_cv.y, 15, 15);
}

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
