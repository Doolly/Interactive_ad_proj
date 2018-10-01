boolean mode;
PImage rgbImage = createImage(640, 480, RGB);
PImage userImage = createImage(640, 480, RGB);
int [] userMap;
int[] userList;
void phase_3() {
  background(0);
  kinect.update(); 
  rgbImage = kinect.rgbImage(); 
  rgbImage.loadPixels(); // prepare the color pixels

  if (userList.length>0) { 
    userMap = kinect.userMap();
    userImage.loadPixels(); //현재 사이즈로 부르고
    userImage.resize(640, 480); // 줄였다가

    for (int y = 0; y< 480; y++) { //때려박고
      for (int x = 0; x< 640; x++) { 
        int i = x + y * 640; 
        if (userMap[i]!=0) { 
          userImage.pixels[i] = rgbImage.pixels[i]; //userImage.pixels[i] = color(200, 0, 200); 
        } else {
          userImage.pixels[i] = color(0);
        }
      }
    }
    userImage.updatePixels();  //갱신된 배열값들을 이미지로 로드
    userImage.resize(width, height); // 다시 늘려서
    image(userImage, 0, 0); //최종 이미지 출력
  }
}
