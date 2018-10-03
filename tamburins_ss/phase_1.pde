// hand tracking 으로??
PVector[] pos;
PVector[] speed;
PVector[] target;
PVector[] tar_speed;
PImage img;
PImage phase1_bg;
int closestValue = 8000;
int closestX;
int closestY;
int phase_throttle = 500;
int close_d = 800;
int far_d = 1300;

int [] userMap;
int[] userList;

int cellSize = 4;  //입자 크기 파라미터
int rows, cols;
float count = 0;
float number = 4;  // 속도 조절 파라미터
float rotation = 0;

void phase1_setup () {
  rows=width/cellSize;
  cols=height/cellSize;
  pos=new PVector[rows*cols];
  speed=new PVector[rows*cols];
  target=new PVector[rows*cols];
  tar_speed=new PVector[rows*cols];
  img = loadImage("pumkin.png");
  phase1_bg = loadImage("phase1_bg.png");
  for (int j=0; j<cols; j++) {
    for (int i=0; i<rows; i++) {
      int x = i*cellSize + cellSize/2;   
      int y = j*cellSize + cellSize/2;   
      speed[i+j*rows]=new PVector(random(-3, 3), random(-3, 3));
      pos[i+j*rows]=new PVector(x, y);
      target[i+j*rows]=new PVector(x, y);
      tar_speed[i+j*rows] = new PVector(random(.01, .1), random(.01, .1));
    }
  }
}

void phase1_kinect_update() {
  closestValue = 8000;
  //kinect.update();
  int[] depthValues = kinect.depthMap();
  for (int y = 0; y< 480; y++) { // for each row
    for (int x = 0; x< 640; x++) { //for each pixel in each row
      int i = x + y * 640;  //calculate the index for the currentPixel
      int currentDepthValue = depthValues[i];  //retrieve the depthValue for that pixel
      if (currentDepthValue > 100 && currentDepthValue < closestValue) {
        closestValue = currentDepthValue;
        closestX = x*width/640;
        closestY = y*height/480;
      }
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
  userImage.resize(width, height); // 다시 늘려서
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
        userImage.pixels[i] = userImage.pixels[i] = color(R, G, B, al);
      } else {
        userImage.pixels[i] = back.pixels[i];
      }
    }
  }
  userImage.updatePixels();  //갱신된 배열값들을 이미지로 로드
  userImage.resize(width, height); // 다시 늘려서
  image(userImage, 0, 0);
}

void phase1_DP_update(int mx, int my) {
  count+=number;
  for (int j=0; j<cols; j++) { //for loop for spreading
    for (int i=0; i<rows; i++) {
      if (dist(pos[i+j*rows].x, pos[i+j*rows].y, mx, my)<count) { 
        float dx= pos[i+j*rows].x - mx;
        float dy= pos[i+j*rows].y - my;
        float DRoation = atan2(dy, dx);
        float WRotation = radians(DRoation/PI*180); 
        //타원 공식 집어 넣기
        pos[i+j*rows].x+= round( count/dist(pos[i+j*rows].x, pos[i+j*rows].y, mx, my) * cos(WRotation) );    //마우스 포인트된 거리에 비례해서 이동후 정수변환
        pos[i+j*rows].y+= round( 2*count/dist(pos[i+j*rows].x, pos[i+j*rows].y, mx, my) * sin(WRotation) );
      } else {   //너무 멀면 원상복귀
        pos[i+j*rows].x = lerp(pos[i+j*rows].x, target[i+j*rows].x, tar_speed[i+j*rows].x);  //현재 위치부터 타겟까지 타겟스피드 비율만큼 가까워짐 
        pos[i+j*rows].y = lerp(pos[i+j*rows].y, target[i+j*rows].y, tar_speed[i+j*rows].y);
      }
    }
  }
  int windowsize = 30;
  int sumD = 0;
  int sumX = 0;
  int sumY= 0;
  int [] senser_D = new int[30];
  int [] senser_X = new int[30];
  int [] senser_Y = new int[30];
  for (int k=0; k<windowsize; k++) {
    senser_D[k]=closestValue;
    senser_X[k]=closestX;
    senser_Y[k]=closestY;
    sumD += senser_D[k];
    sumX += senser_X[k];
    sumY += senser_Y[k];
  }
  closestValue = sumD/windowsize;
  closestX = sumX/windowsize;
  closestY = sumY/windowsize;
  constrain(closestValue, far_d, phase_throttle);
}

void phase1_DP() {
  //tint(255, 60);
  //image(userImage, 0, 0); //최종 이미지 출력  int[] userList = kinect.getUsers();

  //tint(120, 60);
  //image(kinect.depthImage(), 0, 0, width, height);

  //fill(0, 60);   //window opacity ctrl  잔상 조절, 배경 검정
  //rect(0, 0, width, height);

  noStroke();
  fill (255, 0, 0);
  ellipse(closestX, closestY, 15, 15);

  for (int j=0; j<cols; j++) { //for loop for displaying 
    for (int i=0; i<rows; i++) {
      int x = i*cellSize + cellSize/2;   // x position
      int y = j*cellSize + cellSize/2;   // y position
      float z = map(closestValue, far_d, close_d, 0, 150);
      if (closestValue<close_d) {
        z=map(closestValue, close_d, phase_throttle, 150, 700);
      }
      int loc = x + y*width;             // Pixel array location
      color c = img.pixels[loc];         // Grab the color of selected image

      strokeWeight(cellSize);
      stroke(c);
      point(pos[i+j*rows].x, pos[i+j*rows].y, z);
      pushMatrix();
      translate(x, y, z);
      popMatrix();
    }
  }
}
