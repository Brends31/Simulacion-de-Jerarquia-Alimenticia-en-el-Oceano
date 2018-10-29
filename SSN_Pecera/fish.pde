abstract class Fish extends Marine{
  PVector vel;
  PVector acc;
  float mass;
  float size;
  float maxSpeed;
  float maxForce;
  float arrivalRadius;
  color c;

  Fish(float x, float y, PVector vel) {
    super(x, y);
    this.vel = vel;
    acc = new PVector(0, 0);
    maxSpeed = random(3, 5);
    maxForce = random(1.2, 2);
    arrivalRadius = 200;
  }
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  void display() {
    float ang = vel.heading();
    noStroke();
    fill(c, 100);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(ang);
    beginShape();
    vertex(0, size);
    vertex(0, -size);
    vertex(size * 3, 0);
    endShape(CLOSE);
    popMatrix();
  }

  void update() {
    checkBorders();
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  void checkBorders() {
    if (pos.x < size/2 || pos.x > width - size/2) {
      pos.x = constrain(pos.x, size/2, width - size/2);
      vel.x *=-0.8;
    }
    if (pos.y < size/2 || pos.y > height - size/2) {
      pos.y = constrain(pos.y, size/2, height - size/2);
      vel.y *= -0.6;
    }
  }
  
  //void seek(PVector target) {
  //  PVector desired = PVector.sub(target, pos);
  //  desired.setMag(maxSpeed);
  //  PVector steering = PVector.sub(desired, vel);
  //  steering.limit(maxForce);
  //  applyForce(steering);
  //}

  abstract void seek();
  abstract void hunt(ArrayList<Marine> marines);
}
