/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */
PVector t = new PVector(700, 400);

ParticleSystem2 ps2;
color[] particleClr2 = new color[]{ 
  color(137, 138, 230), 
  color(137, 138, 230), 
  color(249, 177, 43), 
  color(216, 89, 26), 
  color(249, 177, 43)
};

void setup() {
  size(1440, 800);
  frameRate(20);
  ps2 = new ParticleSystem2(new PVector(width/2, 300), particleClr2[(int)random(0, 4)]);
}

void draw() {

  //background(0);
  for (int i=0; i<10; i++){
    ps2.addParticle(t);
  }
  ps2.run();
  fill(0,50);
  rect(0,0,1440,800);
}
