boolean mode;
PImage rgbImage = createImage(640, 480, RGB);
PImage userImage = createImage(640, 480, RGB);
float r=0;
float g=0;
float b=0;
int rgb_portion=100;
boolean target1_start=false;
boolean target2_start=false;
boolean target3_start=false;
float current_r, current_g, current_b;


//PImage userImage_color = createImage(640, 480, RGB);

void phase_3() {
  //frameRate(30);
  //colorMode(RGB);
  //colorMode(HSB, 360, 100, 100);
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
        userImage.pixels[i] = color(340, 75, 14);
      }
    }
  }
  if (getDistance(leftShoulder, rightHand)<15) target1_start=true;

  if (target3_start==false) rgb_portion=0;
  if (target1_start==true) {
    target2_start=ColorSet(149, 53, 81);
    if (target2_start==true) target1_start = false;
  }
  if (target2_start==true) {
    target3_start = ColorSet(20, 250, 8);
    if (target3_start==true) target2_start = false;
  }
  if (target3_start==true) rgb_portion++;


  userImage.updatePixels();  //갱신된 배열값들을 이미지로 로드
  userImage.resize(width, height); // 다시 늘려서
  image(userImage, 0, 0);
  //fill(255);
  //textSize(16);
  //text("Frame rate: " + int(frameRate), width/2, 100);
  fill(255);
  textSize(16);
  text(getDistance(leftShoulder, rightHand), width/2, 100);
}


boolean ColorSet(int r, int g, int b) {
  if (r>current_r) current_r++;
  else if (r<current_r) current_r--;
  if (g>current_g) current_g++;
  else if (g<current_g) current_g--;
  if (b>current_b) current_b++;
  else if (b<current_b) current_b--;

  println("r: "+current_r+" g:"+current_g+" b:"+current_b);
  if (r==current_r&&g==current_g&&b==current_b) return true;
  else return false;
}
