
ArrayList<ParticleSystem> systems;
PImage star;  
void setup() {
  size(1024, 768, P2D);
  star = loadImage("ry.png");
  systems = new ArrayList<ParticleSystem>();
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
}
