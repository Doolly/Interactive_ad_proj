PFont font; 
timing textT;

void setup() {
  size(640, 540);
  font = createFont("NanumGothicBold", 30);
  textFont(font);
  textAlign(CENTER, CENTER);
  textT = new timing();
}
void draw() {
  background(0);

  textT.fadingCtrl(5000, "OUT");
  fill(255, textT.alphaVal); 
  text("손으로 저어보셈", width/2, 200);  
  fill(255, textT.alphaVal); 
  text("ㅎㅎㅎㅎㅎㅎㅎ ", width/2, 260);
  println(textT.opa_increse);
  if (textT.alphaVal == 255) {
    textT.fadingCtrl(5000, "OUT");
    fill(255, textT.alphaVal); 
    text("손으로 저어보셈", width/2, 200);  
    fill(255, textT.alphaVal); 
    text("ㅎㅎㅎㅎㅎㅎㅎ ", width/2, 260);
    println(textT.opa_increse);
  }
}


class timing {
  float time_stamp;
  float opa_increse;
  int alphaVal;
  float frame_rate;

  timing() {
    frame_rate = 30;
    alphaVal = 0;
    opa_increse = 0;
    time_stamp = 0;
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
