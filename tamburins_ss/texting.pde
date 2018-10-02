PFont font; 
timing textT;

void text_setup() {
  //String[] fontList = PFont.list();
  //printArray(fontList);
  font = createFont("NanumGothicBold", 30);
  textFont(font);
  textAlign(CENTER, CENTER);
  textT = new timing();
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

  void text_1(String t1) {
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
      fill(255, alphaVal); 
      text(t1, width/2, 200);
    } else if (fade == -1) {
      fill(255, alphaVal-opa_diff); 
      text(t1, width/2, 200);
    }
  }
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
      fill(255, alphaVal); 
      text(t1, width/2, 200);  
      fill(255, alphaVal-opa_diff); 
      text(t2, width/2, 260);
    } else if (fade == -1) {
      fill(255, alphaVal-opa_diff); 
      text(t1, width/2, 200);  
      fill(255, alphaVal);
      text(t2, width/2, 260);
    }
  }
}
