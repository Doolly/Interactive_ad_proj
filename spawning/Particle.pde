// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector origin_pos;
  float lifespan;

  Particle(PVector l) {
    //  acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    origin_pos = l.copy();
    position = l.copy();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    //    velocity.add(acceleration);
    if (position.dist(origin_pos)>30) {
      velocity.mult(-1);
    }
    position.add(velocity);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    return (lifespan < 0.0);
  }
}
