

ArrayList<ParticleSystem> systems;
int size = 5;
void setup() {
  size(640, 480);
  noStroke();
  //stroke(204, 102, 0);
systems = new ArrayList<ParticleSystem>();
for(int i = 0 ; i < size ; i++){
  systems.add(new ParticleSystem(300, new PVector(random(0, width), random(0,height))));  
}

//systems.add(new ParticleSystem(5));

}


void draw() {
 background(32);
 for (ParticleSystem ps : systems) {
   ps.check(new PVector(mouseX, mouseY));
   //ps.followMouse(new PVector(mouseX, mouseY));
   ps.run(new PVector(mouseX, mouseY));
   ps.display();
  }
  if (systems.isEmpty()) {
    fill(255);
    textAlign(CENTER);
    text("click mouse to add particle systems", width/2, height/2);
  }
 
}


void mousePressed() {
  for(ParticleSystem ps : systems){
    if(ps.poped && !ps.clicked){
      ps.reverseGravity();
    }
  }
  //g *= -1;
}
