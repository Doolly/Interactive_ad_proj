PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector normalizedPosition = new PVector(2.25, 1.66); //(640, 480)->(1440, 800)
PVector leftShoulder = new PVector();
PVector rightShoulder = new PVector();

PVector rightHand_cv = new PVector();
PVector leftHand_cv = new PVector();


ArrayList<ParticleSystem> systems;
int count_sys = 5;
PShape[] shapes = new PShape[count_sys];
PImage [] flower = new PImage[count_sys];
float partSize;

void phase2_kinect_update() {
  kinect.update();
  userimg_DP(200, 200, 200, 255, 4, 54, 101, 255);
}

void phase2_shape_setup() {
  noStroke();
  systems = new ArrayList<ParticleSystem>();
  partSize = random(150, 200);
  flower[0] = loadImage("flower[1].png");
  flower[1] = loadImage("flower[1].png");
  flower[2] = loadImage("flower[2].png");
  flower[3] = loadImage("flower[3].png");
  flower[4] = loadImage("flower[2].png");

  color[] particleClr = new color[]{ 
    color(137, 138, 230), 
    color(137, 138, 230), 
    color(249, 177, 43), 
    color(216, 89, 26), 
    color(249, 177, 43)
  };

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
    systems.add(new ParticleSystem(300, new PVector(random(width*0.1, width*0.9), random(height*0.1, height*0.9)), shapes[i], particleClr[i]));
    //systems.remove(i);
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
      drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);

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
  if (jointID == SimpleOpenNI.SKEL_RIGHT_HAND) {
    rightHand_cv = pixelPosition;
  } else if (jointID == SimpleOpenNI.SKEL_LEFT_HAND) {
    leftHand_cv = pixelPosition;
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
