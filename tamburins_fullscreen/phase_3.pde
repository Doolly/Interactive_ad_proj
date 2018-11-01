PImage rgbImage = createImage(640, 480, RGB);
PImage userImage = createImage(640, 480, RGB);
float r=0;
float g=0;
float b=0;
int rgb_portion=100;
boolean target1_start=false;
boolean target2_start=false;
boolean target3_start=false;
boolean frame_start=false;

float current_r, current_g, current_b;

PVector torso_cv = new PVector();

void phase_3() {
  rgbImage = kinect.rgbImage(); 
  rgbImage.loadPixels(); // prepare the color pixels
  userMap = kinect.userMap();
  userImage.loadPixels(); //현재 사이즈로 부르고
  userImage.resize(640, 480); // 줄였다가
  for (int y = 0; y< 480; y++) { //때려박고
    for (int x = 0; x< 640; x++) { 
      int i = x + y * 640; 
      if (userMap[i]!=0) {
        if (rgb_portion<0) rgb_portion=0;
        else if (rgb_portion>100) rgb_portion=100;
        r=(red(rgbImage.pixels[i])*rgb_portion+current_r*(100-rgb_portion))/100;
        g=(green(rgbImage.pixels[i])*rgb_portion+current_g*(100-rgb_portion))/100;
        b=(blue(rgbImage.pixels[i])*rgb_portion+current_b*(100-rgb_portion))/100;

        userImage.pixels[i] = color(r, g, b);
      } else {
        float r=red(phase3_bg.pixels[i]);
        float g=green(phase3_bg.pixels[i]);
        float b=blue(phase3_bg.pixels[i]);
        userImage.pixels[i] = color(r, g, b);
      }
    }
  }

  if (target3_start==false) rgb_portion=0;
  if (target1_start==true) {
    target2_start=ColorSet(255, 84, 84);
    if (target2_start==true) target1_start = false;
  }
  if (target2_start==true) {
    target3_start = ColorSet(255, 166, 255);
    if (target3_start==true) target2_start = false;
  }
  if (target3_start==true) rgb_portion++;
  if (rgb_portion==100) frame_start=true;


  userImage.updatePixels();  //갱신된 배열값들을 이미지로 로드
  userImage.resize(displayWidth, displayHeight); // 다시 늘려서
  image(userImage, 0, 0);
  //fill(255);
  //textSize(16);
  ////text("Frame rate: " + int(frameRate), displayWidth/2, 100);
  //text(theta, displayWidth/2, 100);
}


boolean ColorSet(int r, int g, int b) {
  int speed=3;
  if (r>current_r) current_r+=speed;
  else if (r<current_r) current_r-=speed;
  if (g>current_g) current_g+=speed;
  else if (g<current_g) current_g-=speed;
  if (b>current_b) current_b+=speed;
  else if (b<current_b) current_b-=speed;
  
  if (abs(r-current_r)<speed && abs(g-current_g)<speed && abs(b-current_b)<speed) return true;
  else return false;
}
