PFont font; 

final int DISPLAY_TIME = 5000; 
int lastTime; 
float alphaVal = 0;
int rate = 60; //frame rate
float a = 255.0*rate/(DISPLAY_TIME*1.5); 
int fade =1;


void text_setup() {
  //String[] fontList = PFont.list();
  //printArray(fontList);
  font = createFont("NanumGothicBold", 30);
  textFont(font);
  textAlign(CENTER, CENTER);
}

void text_1() {
  background(0, 60); 
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
    text("한발짝 앞으로 가면 들어가짐", width/2, 260);
  } else if (fade == -1) {
    fill(255, alphaVal-150); 
    text("손으로 저어보셈", width/2, 200);  
    fill(255, alphaVal);
    text("한발짝 앞으로 가면 들어가짐", width/2, 260);
    if (alphaVal-150 <0) phase =3;
  }
}
