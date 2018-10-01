// 파티클은 시스템으로부터 초기위치 origin이 정해짐 그 정해진 값에 락이 걸리고 그림이 씌워짐
// 오리진에 마우스가 가까이 오면 락이 풀림
// 풀리면 손에 모였다가 털면 흩어짐-> 반복    (손벡터에 질량을?)
// 풀리면 손에 모였다 박수치면 터짐-> 반복

// g값을 시스템에서 관장 하다 그 g값만 터지게 색을 넣는것도 시스템에서 관장
// 메인에선 몇개가 생기는지만 관장

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector origin_pos;

  float lifespan;
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

    lifespan = 255.0;
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
      
      if(clicked){
        common = m * neighbor.m / (d*d);  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      }
      else{
        common = abs(m) * abs(neighbor.m) / (d);  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      }
      
      //acceleration.add(PVector.mult(position, common, acceleration));
      acceleration = PVector.add(dist.mult(common), acceleration);
     
      
    }
  }
 //void changeAcc(int _x, int _y){
 //  //acceleration.x = _x;
 //  //acceleration.y = _y;
 //  velocity.x = random(0,1);
 //  velocity.y = random(0,1);
   
 //}
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
