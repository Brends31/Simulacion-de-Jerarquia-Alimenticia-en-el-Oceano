class Prey extends Fish{
  Prey(float x, float y, PVector vel){
    super(x, y, vel);
    this.c = color(0,0,255);
    this.mass = 10;
    this.size = mass/2 + 5;
  }
  
  void seek(){
  }
  
  void hunt(ArrayList<Marine> marines){
    for (Marine target : marines) {
      if (target instanceof Seaweed) {
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
