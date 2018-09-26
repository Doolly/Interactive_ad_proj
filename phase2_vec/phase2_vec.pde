

ArrayList<ParticleSystem> systems;

void setup() {
  size(640, 480);
  noStroke();
  //stroke(204, 102, 0);
systems = new ArrayList<ParticleSystem>();
systems.add(new ParticleSystem(5));

}


void draw() {
 background(32);
 
}


void mousePressed() {
  g *= -1;
}
