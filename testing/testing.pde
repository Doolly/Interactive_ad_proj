PVector[] pos;
PVector[] speed;
PVector[] target;
PVector[] tar_speed;
PImage img;

int cellSize = 4;
int rows, cols;
float count = 0;
float number = 4;
int diagonal;
float rotation = 0;

void setup() {
  size(1152, 648);
  rows=width/cellSize;
  cols=height/cellSize;
  background(0);
  diagonal = (int)sqrt(width*width + height * height)/2;
  pos=new PVector[rows*cols];
  speed=new PVector[rows*cols];
  target=new PVector[rows*cols];
  tar_speed=new PVector[rows*cols];
  img = loadImage("kusama.png");
  //smooth(2);
  //noStroke();
  //fill(255);
  //frameRate(30);
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

void draw() {
  if (mousePressed) {
    count+=number;
    //window opacity ctrl
    fill(0, 50);
    rect(0, 0, width, height);

    for (int j=0; j<cols; j++) { //for loop for spreading
      for (int i=0; i<rows; i++) {

        if (dist(pos[i+j*rows].x, pos[i+j*rows].y, mouseX, mouseY)<count) { 
          float dx= pos[i+j*rows].x - mouseX;
          float dy= pos[i+j*rows].y - mouseY;
          float DRoation = atan2(dy, dx);   
          float WRotation = radians(DRoation/PI*180); 

          
          //타원 공식 집어 넣기
          pos[i+j*rows].x+= round( count/dist(pos[i+j*rows].x, pos[i+j*rows].y, mouseX, mouseY) * cos(WRotation) );    //마우스 포인트된 거리에 비례해서 이동후 정수변환
          pos[i+j*rows].y+= round( 2*count/dist(pos[i+j*rows].x, pos[i+j*rows].y, mouseX, mouseY) * sin(WRotation) ); 
        } 
        
        else {   //너무 멀면 원상복귀
          pos[i+j*rows].x = lerp(pos[i+j*rows].x, target[i+j*rows].x, tar_speed[i+j*rows].x);  //현재 위치부터 타겟까지 타겟스피드 비율만큼 가까워짐 
          pos[i+j*rows].y = lerp(pos[i+j*rows].y, target[i+j*rows].y, tar_speed[i+j*rows].y);  
        } 
      }
    }
  } 


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

/*
class Particle {
 float n;
 float r;
 float o;
 int l;
 Particle() {
 l = 1;
 n = random(1, width/2);
 r = random(0, TWO_PI);
 o = random(1, random(1, width/n));
 }
 
 void draw() {
 l++;
 pushMatrix();
 rotate(r);
 translate(drawDist(), 0);
 fill(255, min(l, 255));
 ellipse(0, 0, width/o/8, width/o/8);
 popMatrix();
 
 o-=0.07;
 }
 float drawDist() {
 return atan(n/o)*width/HALF_PI;
 }
 }
 */
