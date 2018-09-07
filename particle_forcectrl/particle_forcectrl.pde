float g = 0.005;
Particle[] particles = new Particle[700];

////////////////////////////////////////////////////////////////////////////////

void setup() {
  fullScreen();
  noStroke();
  
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
    
    particles[i].px = random(width);
    particles[i].py = random(height);
    
    if (i % 2 == 0) particles[i].m =  randomGaussian() * 8;
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
    
    float opacity = sqrt(particles[i].vx * particles[i].vx + particles[i].vy * particles[i].vy) * 128;
    
    if (particles[i].m < 0) fill(255, opacity);
    else                    fill(128, 128, 255, opacity);
    
    float radius = abs(particles[i].m);
    ellipse(particles[i].px, particles[i].py, radius, radius);
  }
}

////////////////////////////////////////////////////////////////////////////////

void mousePressed() {
  g *= -1;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


class Particle {
  float px, py, vx, vy, ax, ay,dx,dy, m;

////////////////////////////////////////////////////////////////////////////////

  void resetAcceleration() {
    ax = 0;
    ay = 0;
  }

////////////////////////////////////////////////////////////////////////////////

  void updatePartialAcceleration(Particle neighbor) {
    if (neighbor != this) {
      dx = px - neighbor.px;
      dy = py - neighbor.py;

      float d = dx*dx + dy*dy;
      if (d < 1) d = 1;

      float common = m * neighbor.m / d;

      ax += common * dx;
      ay += common * dy;
    }
  }

////////////////////////////////////////////////////////////////////////////////

  void updateVelocityAndPosition() {
    vx = vx * 0.99 + ax * g;
    vy = vy * 0.99 + ay * g;
    
    px += vx;
    py += vy;
    
    if ((px < 0 && vx < 0) || (px > width  && vx > 0))   vx = -vx;
    if ((py < 0 && vy < 0) || (py > height && vy > 0))   vy = -vy;
  }
}
