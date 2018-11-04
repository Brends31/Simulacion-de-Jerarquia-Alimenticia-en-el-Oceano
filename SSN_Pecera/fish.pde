abstract class Fish extends Marine {
  PVector vel;
  PVector acc;
  float mass;
  float size;
  float maxSpeed;
  float maxForce;
  float arrivalRadius;
  float separationDistance = 2;
  float separationRatio = 5;
  float alignmentDistance = 150;
  float alignmentRatio = 0.5;
  float cohesionDistance = 250;
  float cohesionRatio = 0.02;
  float hunger;
  float viewRatio;

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
    //displayViewRatio();

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
    if (pos.y < -size*10 || pos.y > height + size*5) {
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

  void separate(ArrayList<Fish> vehicles) {
    PVector average = new PVector(0, 0);
    int count = 0;
    for (Fish v : vehicles) {
      float d = PVector.dist(pos, v.pos);
      if (this != v && d < separationDistance) {
        PVector difference = PVector.sub(pos, v.pos);
        difference.normalize();
        difference.div(d);
        average.add(difference);
        count ++;
      }
    }
    if (count > 0) {
      average.div(count);
      average.mult(separationRatio);
      average.limit(maxSpeed);
      applyForce(average);
    }
  }

  void align(ArrayList<Fish> vehicles) {
    PVector average = new PVector(0, 0);
    int count = 0;
    for (Fish v : vehicles) {
      float d = PVector.dist(pos, v.pos);
      if (this != v && d < alignmentDistance) {
        average.add(v.vel);
        count++;
      }
    }
    if (count > 0) {
      average.div(count);
      average.mult(alignmentRatio);
      average.limit(maxSpeed);
      applyForce(average);
    }
  }

  void cohesion(ArrayList<Fish> vehicles) {
    PVector average = new PVector(0, 0);
    int count = 0;
    for (Fish v : vehicles) {
      float d = PVector.dist(pos, v.pos);
      if (this != v && d < cohesionDistance) {
        average.add(v.pos);
        count++;
      }
    }
    if (count > 0) {
      average.div(count);
      PVector force = average.sub(pos);
      force.mult(cohesionRatio);
      force.limit(maxSpeed);
      applyForce(force);
    }
  }

  void eat(Marine food) {
    if (PVector.dist(food.pos, pos) == 0) {
      food.alive = false;
    }
  }

  void move(ArrayList<Marine> marines, Sea sea) {
    PVector f = sea.getForce(pos.x, pos.y);
    f.normalize();
    wandering();
    applyForce(f);
    hunt(marines);
    update();
  }

  abstract void wandering();
  abstract void hunt(ArrayList<Marine> marines);
}
