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
    maxSpeed = random(1, 3);
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

  // void separate(ArrayList<Fish> fishes) {
  //   PVector average = new PVector(0, 0);
  //   int count = 0;
  //   for (Fish f : fishes) {
  //     float d = PVector.dist(pos, v.pos);
  //     if (this != v && d < separationDistance) {
  //       PVector difference = PVector.sub(pos, v.pos);
  //       difference.normalize();
  //       difference.div(d);
  //       average.add(difference);
  //       count ++;
  //     }
  //   }
  //   if (count > 0) {
  //     average.div(count);
  //     average.mult(separationRatio);
  //     average.limit(maxSpeed);
  //     applyForce(average);
  //   }
  // }

  // void align(ArrayList<Fish> fishes) {
  //   PVector average = new PVector(0, 0);
  //   int count = 0;
  //   for (Fish f : fishes) {
  //     float d = PVector.dist(pos, v.pos);
  //     if (this != v && d < alignmentDistance) {
  //       average.add(v.vel);
  //       count++;
  //     }
  //   }
  //   if (count > 0) {
  //     average.div(count);
  //     average.mult(alignmentRatio);
  //     average.limit(maxSpeed);
  //     applyForce(average);
  //   }
  // }

  // void cohere(ArrayList<Fish> fishes) {
  //   PVector average = new PVector(0, 0);
  //   int count = 0;
  //   for (Fish f : fishes) {
  //     float d = PVector.dist(pos, v.pos);
  //     if (this != v && d < cohesionDistance) {
  //       average.add(v.pos);
  //       count++;
  //     }
  //   }
  //   if (count > 0) {
  //     average.div(count);
  //     PVector force = average.sub(pos);
  //     force.mult(cohesionRatio);
  //     force.limit(maxSpeed);
  //     applyForce(force);
  //   }
  // }

  void behave(ArrayList<Fish> fishes){
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
        if(PVector.dist(pos, target.pos) < 1){
          target.setDead();
          hunger = 100;
        }
        if (PVector.dist(pos, target.pos) < viewRatio)
          arrive(targetPos);
      
  }

  void move(ArrayList<Marine> marines, Sea sea) {
    PVector f = sea.getForce(pos.x, pos.y);
    f.normalize();
    wandering();
    applyForce(f);
    if(hunger < 20) hunt(marines);
    update();
    hunger--;
    if(hunger == 0) setDead();
  }

  abstract void wandering();
  abstract void hunt(ArrayList<Marine> marines);
}
