// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem2 {
  ArrayList<Particle2> particles2;
  PVector origin;
  color c;
  ParticleSystem2(PVector position, color a) {
    origin = position.copy();
    particles2 = new ArrayList<Particle2>();
    c=a;
  }

  void addParticle(PVector origin) {
    particles2.add(new Particle2(origin, particleClr2[(int)random(0,4)]));
  }

  void run() {
    for (int i = particles2.size()-1; i >= 0; i--) {
      Particle2 p = particles2.get(i);
      p.run();
      if (p.isDead()) {
        particles2.remove(i);
      }
    }
  }
}
