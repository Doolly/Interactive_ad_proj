ArrayList<ParticleSystem> systems;
int count_sys = 5;
PShape[] shapes = new PShape[count_sys];
PImage [] flower = new PImage[count_sys];
float partSize;

void setup() {
  size(1440, 800, P2D);
  phase2_shape_setup();
}


void draw() {
  background(0);

  for (ParticleSystem ps : systems) {
    ps.check(new PVector(mouseX, mouseY));
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
  for (ParticleSystem ps : systems) {
    if (ps.poped && !ps.clicked) {
      ps.reverseGravity();
    }
  }
}
void phase2_shape_setup() {
  noStroke();
  systems = new ArrayList<ParticleSystem>();
  partSize = random(70, 100);
  flower[0] = loadImage("flower[1].png");
  flower[1] = loadImage("flower[1].png");
  flower[2] = loadImage("flower[2].png");
  flower[3] = loadImage("flower[3].png");
  flower[4] = loadImage("flower[2].png");
  
  for (int i = 0; i < count_sys; i++) {
    shapes[i] = createShape();
    shapes[i].beginShape(QUAD);
    shapes[i].noStroke();
    shapes[i].texture(flower[i]);       
    shapes[i].normal(0, 0, 1);
    shapes[i].vertex(-partSize/2, -partSize/2, 0, 0);
    shapes[i].vertex(+partSize/2, -partSize/2, flower[i].width, 0);
    shapes[i].vertex(+partSize/2, +partSize/2, flower[i].width, flower[i].height);
    shapes[i].vertex(-partSize/2, +partSize/2, 0, flower[i].height);
    shapes[i].endShape();
  }
  for (int i = 0; i < count_sys; i++) {
    systems.add(new ParticleSystem(300, new PVector(random(0, width), random(0, height)), shapes[i]));
  }
}
