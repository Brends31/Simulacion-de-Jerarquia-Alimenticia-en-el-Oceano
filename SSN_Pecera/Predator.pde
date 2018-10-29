class Predator extends Fish {
  Predator(float x, float y, PVector vel) {
    super(x, y, vel);
    this.c = color(255, 0, 0);
    this.mass = 25;
    this.size = mass/2 + 5;
  }

  void seek() {
  }

  void hunt(ArrayList<Fish> fish) {

    for (Fish target : fish) {
      if (target instanceof Prey) {
        PVector targetPos = target.pos;
        PVector desired = PVector.sub(targetPos, pos);
        float d = PVector.dist(targetPos, pos);
        d = constrain(d, 0, arrivalRadius);
        float speed = map(d, 0, arrivalRadius, 0, maxSpeed);
        vel.setMag(speed);
        PVector steering = PVector.sub(desired, vel);
        steering.limit(maxForce);
        applyForce(steering);
      }
    }
  }
}
