class ParticleSystem {
  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin;                   // An origin point for where particles are birthed
  PVector hand_pos;
  float sys_size;
  boolean poped;
  boolean clicked;
  boolean done;
  color c;
  //Particle[] particles = new Particle[700];
  float g = 0.005;

  ParticleSystem(int num, PVector _origin) {  //초기 개수랑 출몰위치
    particles = new ArrayList<Particle>();
    origin = _origin.copy();
    c = color(random(0, 255), random(0, 255), random(0, 255));
    sys_size = 100;
    poped = false;
    done = false;
    clicked = false;
    for (int i = 0 ; i < num; i++){
      particles.add(new Particle(origin, randomGaussian() * 8));   //한종류의 군집
    }
    

    /*for (int i = 0; i < num; i++) {
      origin = new PVector(random(width), random(height));
      particle_group.add(new Particle(origin, hand_pos));    // Add "num" amount of particles to the arraylist
    }*/
  }
  
  boolean check(PVector mouse){
    if(!poped){
      float d = PVector.dist(origin, mouse);
      if( d < sys_size){
        poped = true;
      }
      return poped;
    }
    else{
      return poped;
    }
  }
  
  void followMouse(PVector mouse){
    if(poped && !clicked){
      //Particle m = new Particle(mouse, 10);
      for (int i = 0 ; i <particles.size() -1 ; i ++ ){
        Particle p = particles.get(i);
        p.resetAcceleration();
        //p.updatePartialAcceleration(m);
        p.updateVelocityAndPosition();
      }
    }
  }
  
  void reverseGravity(){
    for(int i=0 ; i < particles.size() ; i++){
      Particle p = particles.get(i);
      p.reverseGravity();
    }
    if(!clicked){
      clicked = true;
    }
  }
  
  void display(){
    for (int i = 0; i < particles.size() ; i++) {
      Particle p = particles.get(i);
      p.updateVelocityAndPosition();

      float opacity = p.velocity.mag() * 128;  //느리면 안보이게 빠르면 잘보이게

      fill(c, opacity);  //반은 보라색
      //fill(c);
      ellipse(p.position.x, p.position.y, abs(p.m), abs(p.m));
    }
  }
  
  void run(PVector mouse) {
    Particle m = new Particle(mouse, 15);
    for (int me = 0; me < particles.size(); me++) {
      Particle p = particles.get(me);
      p.resetAcceleration();
      
      if(!poped){  // 안터졌으면
        if(p.position.dist(origin) > 20){
          p.velocity.mult(-1);
        }
      }
      if(poped && !clicked){  // Follow Mouse
        p.updatePartialAcceleration(m, false);
               
      }
      if(clicked){  //
     // p.changeAcc(5,5);
        for (int neighbor = 0; neighbor < particles.size()-1; neighbor++) {
          Particle p_neighbor = particles.get(neighbor);
          p.updatePartialAcceleration(p_neighbor, true);
        }
      } 
    }
        
  }
  
}
