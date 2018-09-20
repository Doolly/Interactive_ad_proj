float g = 0.005;
Particle[] particles = new Particle[700];

////////////////////////////////////////////////////////////////////////////////

void setup() {
  // fullScreen();
  size(640, 480);
  noStroke();
  //stroke(204, 102, 0);

  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();

    particles[i].px = random(width);
    particles[i].py = random(height);

    if (i % 2 == 0) particles[i].m =  randomGaussian() * 8;   //m은 -8에서 8사이
    else            particles[i].m = -randomGaussian() * 8;
  }
}

////////////////////////////////////////////////////////////////////////////////

void draw() {
  background(32);

  for (int me = 0; me < particles.length; me++) { 
    particles[me].resetAcceleration();

    for (int neighbor = 0; neighbor < particles.length; neighbor++) {
      particles[me].updatePartialAcceleration(particles[neighbor]);
    }
  }

  for (int i = 0; i < particles.length; i++) {
    particles[i].updateVelocityAndPosition();

    float opacity = sqrt(particles[i].vx * particles[i].vx + particles[i].vy * particles[i].vy) * 128;  //느리면 안보이게 빠르면 잘보이게

    if (particles[i].m < 0) fill(255, opacity);    //반은 흰색
    else                    fill(128, 128, 255, opacity);  //반은 보라색

    float radius = abs(particles[i].m);
    ellipse(particles[i].px, particles[i].py, radius, radius);
  }
  //println("px =", particles[20].px);
  //println("vx =", particles[20].vx);
  //println("ax =", particles[20].ax);
}

////////////////////////////////////////////////////////////////////////////////

void mousePressed() {
  g *= -1;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


class Particle {
  float px, py, vx, vy, ax, ay, dx, dy, m;

  ////////////////////////////////////////////////////////////////////////////////

  void resetAcceleration() {
    ax = 0;
    ay = 0;
  }

  ////////////////////////////////////////////////////////////////////////////////

  void updatePartialAcceleration(Particle neighbor) {
    if (neighbor != this) {
      dx = px - neighbor.px;   //옆에 놈과의 거리를 재고
      dy = py - neighbor.py;

      float d = dx*dx + dy*dy;   //진짜 거리를 구하고
      if (d < 1) d = 1;          //너무 가까우면 1로봄 common이 너무 커지지 않게

      float common = m * neighbor.m / d;  //m의 곱을 거리로 나눔

      ax += common * dx;     //결국 m의 곱에 cos 값 곱해서 가속도로 - 질량에 제곱에 비례한 만유인력
      ay += common * dy;     //sin값
      //m이 커봐야 8이니까 common은 최대 64
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  void updateVelocityAndPosition() {
    vx = vx * 0.99 + ax * g;  //속도는 루프마다 1%씩 작아지게 
    vy = vy * 0.99 + ay * g;

    px += vx;
    py += vy;

    if ((px < 0 && vx < 0) || (px > width  && vx > 0))   vx = -vx;   //벽에 튕기는 코드
    if ((py < 0 && vy < 0) || (py > height && vy > 0))   vy = -vy;
  }
}
