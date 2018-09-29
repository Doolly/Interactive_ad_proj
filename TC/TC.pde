PFont font; 
timing textT;

void setup() {
  size(640, 540);
  font = createFont("NanumGothicBold", 30);
  textFont(font);
  textAlign(CENTER, CENTER);
}
void draw() {
  background(0);
  
  textT.fadingCtrl(5000, "IN");
  fill(255, textT.alphaVal); 
  text("손으로 저어보셈", width/2, 200);  
  fill(255, textT.alphaVal-150); 
  text("ㅎㅎㅎㅎㅎㅎㅎ ", width/2, 260);
}


class timing {
  int time_stamp;
  float opa_increse;
  float alphaVal;
  int frame_rate;
  
  timing() {
    frame_rate = 30;
  }

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
