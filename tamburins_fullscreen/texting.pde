PFont bold; 
PFont regular; 

timing textT;
PImage text1_bg;
PImage text2_bg;
PImage text3_bg;

void text_setup() {
  //String[] fontList = PFont.list();
  //printArray(fontList);
  bold = createFont("NotoSansCJKkr-Bold.otf", 35);
  regular = createFont("NotoSansCJKkr-Regular.otf", 30);

  textFont(regular);
  textFont(bold);
  textAlign(CENTER, CENTER);
  textT = new timing();
  text1_bg = loadImage("text1_bg.png");
  text2_bg = loadImage("text2_bg.png");
  text3_bg = loadImage("text3_bg.png");
}

class timing {
  final int DISPLAY_TIME = 3000; 
  int lastTime; 
  float alphaVal = 0;
  float opa_increse;
  float opa_diff = 150;
  int frame_rate = 30;
  float a = 255.0 * frame_rate/(DISPLAY_TIME/(255/opa_diff)); 
  int fade =1;
  int line = 0;

  timing() {
  } 
  //void text_1(String t1,int DP_T) {
  //  if (millis() - lastTime >= DP_T) { //5초 주기 if문 스탑워치 키기
  //    lastTime = millis();
  //    a*=-1;
  //    if (fade ==1) {
  //      alphaVal = 255+opa_diff;
  //    } else {
  //      alphaVal = 0;
  //    }
  //    fade *= -1;
  //    line ++;
  //  }
  //  alphaVal += a;

  //  if (fade == 1) {
  //    fill(255, alphaVal); 
  //    text(t1, displayWidth/2, displayHeight/2-30);
  //  } else if (fade == -1) {
  //    fill(255, alphaVal-opa_diff); 
  //    text(t1, displayWidth/2, displayHeight/2+30);
  //  }
  //}
  void text_2(String t1, String t2) {
    if (millis() - lastTime >= DISPLAY_TIME) { //5초 주기 if문 스탑워치 키기
      lastTime = millis();
      a*=-1;
      if (fade ==1) {
        alphaVal = 255+opa_diff;
      } else {
        alphaVal = 0;
      }
      fade *= -1;
      line ++;
    }
    alphaVal += a;
    if (fade == 1) {
      textFont(bold);
      fill(255, alphaVal); 
      text(t1, displayWidth/2, displayHeight/2-30);
      textFont(regular);
      fill(255, alphaVal-opa_diff); 
      text(t2, displayWidth/2, displayHeight/2+30);
    } else if (fade == -1) {
      textFont(bold);
      fill(255, alphaVal); 
      text(t1, displayWidth/2, displayHeight/2-30);  
      textFont(regular);
      fill(255, alphaVal);
      text(t2, displayWidth/2, displayHeight/2+30);
    }
  }
}
