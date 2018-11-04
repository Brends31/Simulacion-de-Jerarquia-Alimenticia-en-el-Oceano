class Prey extends Fish{
  Prey(float x, float y, PVector vel){
    super(x, y, vel);
    this.c = color(0,0,255);
    this.mass = 10;
    this.size = mass/2 + 5;
  }
  
  void wandering(){
    if (pos. x > 25) {
      PVector desired = new PVector(maxSpeed,vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxSpeed);
      applyForce(steer);
    } else if(pos.x < (width-25)){
      PVector desired = new PVector(-maxSpeed,vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }
  }
  
  void hunt(ArrayList<Marine> marines){
    for (Marine target : marines) {
      if (target instanceof Seaweed) {
        PVector targetPos = target.pos;
        arrive(targetPos);
      }
    }
  
  }
  
}
