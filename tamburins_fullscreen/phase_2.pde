PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector normalizedPosition = new PVector(1.6, 1.6); //(640, 480)->(1024, 768)
PVector leftShoulder = new PVector();
PVector rightShoulder = new PVector();
PVector rightHand_cv = new PVector();
PVector leftHand_cv = new PVector();


ArrayList<ParticleSystem> systems;
int count_sys = 8;
float partSize;
PShape[] shapes = new PShape[count_sys];
PImage [] flower = new PImage[count_sys];

void phase2_shape_setup() {
  noStroke();
  systems = new ArrayList<ParticleSystem>();
  partSize = random(150, 200);
  flower[0] = loadImage("flower[1].png");
  flower[1] = loadImage("flower[1].png");
  flower[2] = loadImage("flower[2].png");
  flower[3] = loadImage("flower[2].png");
  flower[4] = loadImage("flower[3].png");
  flower[5] = loadImage("flower[3].png");
  flower[6] = loadImage("flower[1].png");
  flower[7] = loadImage("flower[2].png");

  color[] particleClr = new color[]{ 
    color(137, 138, 230), 
    color(137, 138, 230), 
    color(249, 177, 43), 
    color(249, 177, 43), 
    color(216, 89, 26), 
    color(216, 89, 26), 
    color(137, 138, 230), 
    color(249, 177, 43)
  };

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
    systems.add(new ParticleSystem(300, new PVector(random(displayWidth*0.1, displayWidth*0.9), random(displayHeight*0.1, displayHeight*0.6)), shapes[i], particleClr[i]));
    //systems.remove(i);
  }
}
