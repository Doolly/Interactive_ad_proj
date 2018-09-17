// An ArrayList is used to manage the list of Particles

class ParticleSystem {
  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin;                   // An origin point for where particles are birthed
  PShape particleShape;
  ParticleSystem(int num, PVector v) {  //초기 개수랑 출몰위치
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = v.copy();                        // Store the origin point
    particleShape = createShape(PShape.GROUP);
    for (int i = 0; i < num; i++) {

      Particle p = new Particle(origin);
      particles.add(p);
      particleShape.addChild(p.getShape());
    }
  }


  void run() {
    // Cycle through the ArrayList backwards, because we are deleting while iterating
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void show() {
    shape(particleShape);
  }

  void addParticle() {
    Particle p;
    p = new Particle(origin);
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    return particles.isEmpty();
  }
}
