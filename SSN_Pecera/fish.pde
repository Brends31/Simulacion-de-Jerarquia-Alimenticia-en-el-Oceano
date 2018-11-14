abstract class Fish extends Marine {
  PVector vel;
  PVector acc;
  float mass;
  float size;
  float maxSpeed;
  float maxForce;
  float arrivalRadius;
  float separationDistance = 1000;
  float separationRatio = 100;
  float alignmentDistance = 500;
  float alignmentRatio = 0.25;
  float cohesionDistance = 100;
  float cohesionRatio = 0.02;
  float hunger;
  float viewRatio;
  PImage image;

  Fish(float x, float y, PVector vel, PImage image) {
    super(x, y);
    this.vel = vel;
    acc = new PVector(0, 0);
    maxSpeed = 2;
    maxForce = 1.5;
    arrivalRadius = 200;
    this.image = image;
    setHunger();
  }
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  void display() {
    float ang = vel.heading();

    noStroke();
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(ang);
    image(image, -20, -25, 50, 50);

    beginShape();
    vertex(0, size);
    vertex(0, -size);
    vertex(size * 3, 0);
    endShape(CLOSE);
    popMatrix();
  }

  void displayViewRatio() {
    stroke(10);
    noFill();
    ellipse(pos.x, pos.y, viewRatio, viewRatio);
  }

  void update() {
    checkBorders();
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  void checkBorders() {
    if (pos.x < -size*5 || pos.x > width + size*5) {
      pos.x = constrain(pos.x, -size*5, width + size*5);
      vel.x *=-0.6;
    }
    if (pos.y < -size*5 || pos.y > height + size*5) {
      pos.y = constrain(pos.y, -size*5, height + size*5);
      vel.y *= -0.6;
    }
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeed);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);
    applyForce(steering);
  }

  void arrive(PVector targetPos) {
    PVector desired = PVector.sub(targetPos, pos);
    float d = PVector.dist(targetPos, pos);
    d = constrain(d, 0, arrivalRadius);
    float speed = map(d, 0, arrivalRadius, 0, maxSpeed);
    vel.setMag(speed);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);
    applyForce(steering);
  }

  void behave(ArrayList<Fish> fishes) {
    PVector averageSeparation = new PVector(0, 0);
    PVector averageAlignment = new PVector(0, 0);
    PVector averageCohere = new PVector(0, 0);
    int countSeparation = 0;
    int countAlignment = 0;
    int countCohere = 0;

    // separate & align & cohere //
    for (Fish f : fishes) {
      float d = PVector.dist(pos, f.pos);

      if (this != f && d < separationDistance) {
        PVector difference = PVector.sub(pos, f.pos);
        difference.normalize();
        difference.div(d);
        averageSeparation.add(difference);
        countSeparation++;
      }

      if (this != f && d < alignmentDistance) {
        averageAlignment.add(f.vel);
        countAlignment++;
      }

      if (this != f && d < cohesionDistance) {
        averageCohere.add(f.pos);
        countCohere++;
      }
    }

    if (countSeparation > 0) {
      averageSeparation.div(countSeparation);
      averageSeparation.mult(separationRatio);
      averageSeparation.limit(maxSpeed);
      applyForce(averageSeparation);
    }

    if (countAlignment > 0) {
      averageAlignment.div(countAlignment);
      averageAlignment.mult(alignmentRatio);
      averageAlignment.limit(maxSpeed);
      applyForce(averageAlignment);
    }

    if (countCohere > 0) {
      averageCohere.div(countCohere);
      PVector force = averageCohere.sub(pos);
      force.mult(cohesionRatio);
      force.limit(maxSpeed);
      applyForce(force);
    }
  }

  void eat(Marine target) {
    PVector targetPos = target.pos;
    if (PVector.dist(pos, target.pos) < 10) {
      target.setDead();
      setHunger();
    }
    if (PVector.dist(pos, target.pos) < viewRatio)
      arrive(targetPos);
  }

  void move(ArrayList<Marine> marines, Sea sea) {
    PVector f = sea.getForce(pos.x, pos.y);
    f.normalize();
    wandering();
    applyForce(f);
    if (isHungry()) hunt(marines);
    update();
    hunger--;
    if (hunger == 0) setDead();
  }

  void wandering() {
    if (pos.x < wallx) {
      PVector desired = new PVector(maxSpeed, vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    } else if (pos.x > (width-wallx)) {
      PVector desired = new PVector(-maxSpeed, vel.y);
      PVector steer = PVector.add(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }

    if (pos.y < wally) {
      PVector desired = new PVector(vel.x, maxSpeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    } else if (pos.y > (height - wally)) {
      PVector desired = new PVector(vel.x, -maxSpeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }
  }

  abstract void setHunger();
  abstract boolean isHungry();

  abstract void hunt(ArrayList<Marine> marines);
}
