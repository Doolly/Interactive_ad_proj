class ParticleSystem {
  ArrayList<Particle> particles;    
  PVector origin;  
  float sys_size;
  boolean poped;
  boolean clicked;
  color c;
  float g = 0.005;
  PShape part;
  float opacity;

  ParticleSystem(int num, PVector _origin, PShape pic, color a) {  //초기 개수랑 출몰위치
    particles = new ArrayList<Particle>();
    origin = _origin.copy();
    c= a;
    //c = color(random(0, 255), random(0, 255), random(0, 255));
    sys_size = 30;
    poped = false;
    clicked = false;
    part = pic;
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin, randomGaussian() * 8)); 
      //particles.add(new Particle(origin, random(-16,16)));
    }
  }

  boolean check(PVector mouse) {
    if (!poped) {
      float d = PVector.dist(origin, mouse);
      if ( d < sys_size) {
        poped = true;
      }
      return poped;
    } else {
      return poped;
    }
  }

  void reverseGravity() {
    for (int i=0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.reverseGravity();
    }
    if (!clicked) {
      clicked = true;
    }
  }

  void display() {
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.updateVelocityAndPosition();

      float opacity_v = p.velocity.mag() * 128;  //느리면 안보이게 빠르면 잘보이게

      //stroke(3);
      fill(c, opacity+opacity_v);  

      ellipse(p.position.x, p.position.y, abs(p.m), abs(p.m));
      if (!poped) {  // 안터졌으면
        pushMatrix();
        translate(origin.x, origin.y);
        shape(part);
        popMatrix();
      }
      if (poped && !clicked) {  
        part.setVisible(false);
      }
    }
  }

  //void ascend(PVector mouse){
  //for (int i = particles.size()-1; i >= 0; i--) {
  //      Particle p = particles.get(i);
  //}

  void run(PVector mouse) {
    Particle m = new Particle(mouse, 70);
    for (int me = 0; me < particles.size(); me++) {
      Particle p = particles.get(me);
      p.resetAcceleration();

      if (!poped) {  // 안터졌으면
        if (p.position.dist(origin) > sys_size) {
          p.velocity.mult(-1);
        }
      }
      if (poped && !clicked) {  // Follow Mouse
        p.updatePartialAcceleration(m, false);
      }
      if (clicked) {  //thrown
        for (int neighbor = 0; neighbor < particles.size()-1; neighbor++) {
          Particle p_neighbor = particles.get(neighbor);
          p.updatePartialAcceleration(p_neighbor, true);
        }
      }
    }
  }
}
