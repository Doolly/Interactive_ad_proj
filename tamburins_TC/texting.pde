PFont font; 

final int DISPLAY_TIME = 6000; 
int lastTime; 
float alphaVal = 0;
float opa_increse;
int frame_rate = 30;
float a = 255.0 * frame_rate/(DISPLAY_TIME/1.5); 
int fade =1;

void text_setup() {
  //String[] fontList = PFont.list();
  //printArray(fontList);
  font = createFont("NanumGothicBold", 30);
  textFont(font);
  textAlign(CENTER, CENTER);
}

class timing {
void fadingCtrl(int interrupt_t, String IO) {
  opa_increse = 255.0 * frame_rate/interrupt_t; 
  if (millis() - time_stamp >= interrupt_t) { 
    time_stamp = millis();
    if (IO == "IN") {
      opa_increse = abs(opa_increse);
    } else if (IO == "OUT") {
      opa_increse = -abs(opa_increse);
    }
  }
  alphaVal += opa_increse;
  alphaVal = constrain(alphaVal, 0, 255);
}

}
void text_2 () {
  fadingCtrl(5000, "IN");
  fill(255, alphaVal); 
  text("손으로 저어보셈", width/2, 200);  
  fill(255, alphaVal-150); 
  text("ㅎㅎㅎㅎㅎㅎㅎ ", width/2, 260);
}


void text_1() {
  if (millis() - lastTime >= DISPLAY_TIME) { //5초 주기 if문 스탑워치 키기
    lastTime = millis();
    a*=-1;
    if (fade ==1) {
      alphaVal = 405;
    } else {
      alphaVal = 0;
    }
    fade *= -1;
  }
  alphaVal += a;
  if (fade == 1) {
    fill(255, alphaVal); 
    text("손으로 저어보셈", width/2, 200);  
    fill(255, alphaVal-150); 
    text("ㅎㅎㅎㅎㅎㅎㅎ ", width/2, 260);
  } else if (fade == -1) {
    fill(255, alphaVal-150); 
    text("손으로 저어보셈", width/2, 200);  
    fill(255, alphaVal);
    text("한발짝 앞으로 가면 들어가짐", width/2, 260);
    if (alphaVal-150 < -150) seq =3;
  }
}
