PVector[] pos;
PVector[] speed;
PVector[] target;
PVector[] tar_speed;
PImage img;

int closestValue = 8000;
int closestX;
int closestY;
int phase_throttle = 200;
int close_d = 500;
int far_d = 1100;

int cellSize = 4;  //입자 크기 파라미터
int rows, cols;
float count = 0;
float number = 5;  // 속도 조절 파라미터
float rotation = 0;

void phase1_setup () {
  rows=width/cellSize;
  cols=height/cellSize;
  pos=new PVector[rows*cols];
  speed=new PVector[rows*cols];
  target=new PVector[rows*cols];
  tar_speed=new PVector[rows*cols];
  img = loadImage("kusama.png");

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
  kinect.update();
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
  image(kinect.userImage(), 0, 0, width, height);
  //image(kinect.rgbImage(),0,0,width,height);
  fill (255, 0, 0);
  ellipse(closestX, closestY, 25, 25);
  number=map(closestValue, close_d, far_d, 5, 10);
}


void phase1_DP_update(int mx, int my) {
  if (closestValue > close_d && closestValue < far_d) {
    count+=number;
    fill(0, 60);   //window opacity ctrl  잔상 조절, 배경 검정
    rect(0, 0, width, height);

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
  }
  // if (closestValue < phase_throttle) {
  //number = 20;
  //}
}

void phase1_display() {
  for (int j=0; j<cols; j++) { //for loop for displaying 
    for (int i=0; i<rows; i++) {
      int x = i*cellSize + cellSize/2;   // x position
      int y = j*cellSize + cellSize/2;   // y position
      int loc = x + y*width;             // Pixel array location
      color c = img.pixels[loc];         // Grab the color of selected image
      strokeWeight(cellSize);
      stroke(c);
      point(pos[i+j*rows].x, pos[i+j*rows].y);
    }
  }
}
