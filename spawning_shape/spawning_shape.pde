
ArrayList<ParticleSystem> systems;
PImage star;  

import processing.sound.*;
SoundFile file;

void setup() {
  size(1024, 768, P2D);
//  star = loadImage("ry.png");
  star = loadImage("bono.png");
  systems = new ArrayList<ParticleSystem>();
  //file = new SoundFile(this, "aa.mp3");
  //file.cue(9.7);
 
 file = new SoundFile(this, "ww.mp3");
}

void draw() {
  background(0);
  for (ParticleSystem ps : systems) {
    ps.run();
    ps.addParticle();
    ps.show();
  }
  if (systems.isEmpty()) {
    fill(255);
    textAlign(CENTER);
    text("click mouse to add particle systems", width/2, height/2);
  }
  fill(255);
  textSize(16);
  text("Frame rate: " + int(frameRate), 10, 20);
}

void mousePressed() {
  systems.add(new ParticleSystem(1, new PVector(mouseX, mouseY)));
  file.play();
}
