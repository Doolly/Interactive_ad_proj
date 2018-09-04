class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan = 255;
  
  PShape part;
  float partSize;
  
  Particle(PVector l) {
   // acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    
    //이미지 형상
    partSize = random(10,60);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(star);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, star.width, 0);
    part.vertex(+partSize/2, +partSize/2, star.width, star.height);
    part.vertex(-partSize/2, +partSize/2, 0, star.height);
    part.endShape();
    
    rebirth(width/2,height/2);
    lifespan = random(255);
  }

  PShape getShape() {
    return part;
  }
  
  void rebirth(float x, float y) {
    float a = random(TWO_PI);
    float speed = random(0.5,4);
    velocity = new PVector(cos(a), sin(a));
    velocity.mult(speed);
    
    lifespan = 255;   
    part.resetMatrix();
    part.translate(x, y); 
  }
  
  boolean isDead() {
    if (lifespan < 0) {
     return true;
    } else {
     return false;
    } 
  }
  

  public void update() {
    lifespan = lifespan - 1;
    part.setTint(color(255,255,255,lifespan));
    /*
      if(dist(position.x , position.y, x ,y)>5)  {
     velocity.x = velocity.x *-1;
     velocity.y = velocity.y *-1;
      }
      */
    part.translate(velocity.x, velocity.y);
  }
}
