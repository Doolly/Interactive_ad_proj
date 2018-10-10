// A simple Particle class

class Particle2 {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color c;

  Particle2(PVector l, color _c) {
    acceleration = new PVector(0, -0.0005);
    velocity = new PVector(random(-2, 2), random(-4, 0));
    position = l.copy();
    c = _c;
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 0.5;
  }

  // Method to display
  void display() {
    noStroke();
    fill(c, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
