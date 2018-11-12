class Prey extends Fish{
  
  Prey(float x, float y, PVector vel){
    super(x, y, vel);
    this.c = color(0,0,255);
    this.mass = 1;
    this.size = mass/2 + 5;
    viewRatio = 150;
    hunger = 60;
  }
  
  void wandering(){
    if (pos. x < wall) {
      PVector desired = new PVector(maxSpeed,vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    } 
    else if (pos.x > (width-wall)){
      PVector desired = new PVector(-maxSpeed,vel.y);
      PVector steer = PVector.add(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }

    if(pos.y < wall){
      PVector desired = new PVector(vel.x,maxSpeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    } else if(pos.y > (height - wall)){
      PVector desired = new PVector(-maxSpeed,vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }
  }
  
  void hunt(ArrayList<Marine> marines){
    for (Marine target : marines) {
      if (target instanceof Seaweed) {
        eat(target);
    }
  }
  }

}
