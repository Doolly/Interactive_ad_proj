// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector origin_pos;
  float lifespan;

  PShape part;
  float partSize;

  Particle(PVector l) {
    //  acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    origin_pos = l.copy();
    position = l.copy();
    lifespan = 255.0;

    //이미지 형상
    partSize = random(10, 60);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(star);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, star.width, 0);
    part.vertex(+partSize/2, +partSize/2, star.width, star.height);
    part.vertex(-partSize/2, +partSize/2, 0, star.height);
    part.endShape();
  }

  PShape getShape() {
    return part;
  }
  void run() {
    update();
    display();
  }

  void update() {   // Method to update position
    //    velocity.add(acceleration);
    //if (position.dist(origin_pos)>30) {  //거리제한
    //  velocity.mult(-1);
    //}
    part.setTint(color(255, 255, 255, lifespan));
    part.translate(velocity.x, velocity.y);

    lifespan -= 2.0;
  }

  void display() {   // Method to display
    shape(part);
  }

  boolean isDead() {    // Is the particle still useful?
    return (lifespan < 0.0);
  }
}
