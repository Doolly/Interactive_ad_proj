class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector origin_pos;
  float m;
  float g;
  float d;


  Particle(PVector o, float _m) {
    //  acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    origin_pos = o.copy();
    position = o.copy();
    acceleration = new PVector(0, 0);
    m = _m;
    g = -0.005;
  }

  void resetAcceleration() {
    acceleration = PVector.mult(acceleration, 0);
  }

  void updatePartialAcceleration(Particle neighbor, boolean clicked) {
    if (neighbor != this) {
      PVector dist = PVector.sub(position, neighbor.position);
      d = PVector.dist(position, neighbor.position);
      float common;
      if (d < 1) d = 1;          //너무 가까우면 1로봄 common이 너무 커지지 않게
      if (clicked) {
        common = m * neighbor.m / (d*d);  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      } else {
        common = abs(m) * abs(neighbor.m) / (d);  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      }
      acceleration = PVector.add(dist.mult(common), acceleration);
    }
  }

  void reverseGravity() {
    g *= -1;
  }

  void updateVelocityAndPosition() {
    velocity = PVector.add(velocity.mult(0.99), acceleration.mult(g));
    position.add(velocity);
    if ((position.x < 0 && velocity.x < 0) || (position.x > width  && velocity.x > 0)) {
      velocity.x *= -1;   //벽에 튕기는 코드
      acceleration.x *= -1;
    }
    if ((position.y < 0 && velocity.y < 0) || (position.y > height && velocity.y > 0)) {
      velocity.y *= -1;
      acceleration.y *= -1;
    }
  }
}
