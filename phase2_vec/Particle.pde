// 파티클은 시스템으로부터 초기위치 origin이 정해짐 그 정해진 값에 락이 걸리고 그림이 씌워짐
// 오리진에 마우스가 가까이 오면 락이 풀림
// 풀리면 손에 모였다가 털면 흩어짐-> 반복    (손벡터에 질량을?)
// 풀리면 손에 모였다 박수치면 터짐-> 반복

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector origin_pos;
  PVector hand_pos;
  float lifespan;
  float m;
  float g;
  float sys_size;

  Particle(PVector o, PVector h) {
    //  acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    origin_pos = o.copy();
    position = o.copy();
    hand_pos = h.copy();
    g = 0.005;
    sys_size = 100;
    lifespan = 255.0;
  }

  void resetAcceleration() {
    acceleration.mult(0);
  }

  void updatePartialAcceleration(Particle neighbor) {
    if (neighbor != this) {
      //     PVector dist = PVector.sub(position, neighbor.position);
      float d = PVector.dist(position, neighbor.position);

      if (d < 1) d = 1;          //너무 가까우면 1로봄 common이 너무 커지지 않게

      float common = m * neighbor.m / d;  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      acceleration.add(PVector.mult(position, common, acceleration));
    }
  }

  boolean poped() {
    float d = PVector.dist(origin_pos, hand_pos);
    return (d<sys_size);
  }

  void updateVelocityAndPosition() {
    if (poped()) {
      velocity = PVector.add(velocity.mult(0.99), acceleration.mult(g));
    } else {
      velocity = PVector.add(velocity.mult(0.99), acceleration.mult(g));       //PVector.add(velocity.mult(0.99), acceleration.mult(0.005), velocity);
      if (position.dist(origin_pos)>30) {  //거리제한
        velocity.mult(-1);
      }

      position.add(velocity);

      if ((position.x < 0 && velocity.x < 0) || (position.x > width  && velocity.x > 0))   velocity.mult(-1);   //벽에 튕기는 코드
      if ((position.y < 0 && velocity.y < 0) || (position.y > height && velocity.y > 0))   velocity.mult(-1);
    }
  }
}
