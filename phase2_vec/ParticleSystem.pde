class ParticleSystem {
  ArrayList<Particle> particle_group;    // An arraylist for all the particles
  PVector origin;                   // An origin point for where particles are birthed
  PVector hand_pos;
  Particle[] particles = new Particle[700];
  float g = 0.005;

  ParticleSystem(int num) {  //초기 개수랑 출몰위치
    particle_group = new ArrayList<Particle>();   //한종류의 군집



    for (int i = 0; i < particles.length; i++) {
     // particles[i] = new Particle();
      particles[i].m =  randomGaussian() * 8;
    }

    for (int i = 0; i < num; i++) {
      origin = new PVector(random(width), random(height));
      particle_group.add(new Particle(origin, hand_pos));    // Add "num" amount of particles to the arraylist
    }
  }


  void fff() {
    for (int me = 0; me < particles.length; me++) { 
      particles[me].resetAcceleration();

      for (int neighbor = 0; neighbor < particles.length; neighbor++) {
        particles[me].updatePartialAcceleration(particles[neighbor]);
      }
    }

    for (int i = 0; i < particles.length; i++) {
      particles[i].updateVelocityAndPosition();

      float opacity = sqrt(particles[i].velocity.x * particles[i].velocity.x + particles[i].velocity.y * particles[i].velocity.y) * 128;  //느리면 안보이게 빠르면 잘보이게

      if (particles[i].m < 0) fill(255, opacity);    //반은 흰색
      else                    fill(128, 128, 255, opacity);  //반은 보라색

      float radius = abs(particles[i].m);
      ellipse(particles[i].position.x, particles[i].position.y, radius, radius);
    }
  }
}
