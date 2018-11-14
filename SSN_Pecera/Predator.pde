class Predator extends Fish {

  Predator(float x, float y, PVector vel,PImage image) {
    super(x, y, vel,image);
    this.c = color(255, 0, 0);
    this.mass = 5;
    this.size = mass/2 + 5;
    viewRatio = 600;
    hunger = 1800;
  }
  
  void setHunger(){
    hunger = 1800;
  }
  
  Marine reproduce(){
    float corrX = random(-10, 10); 
    float corrY= random(-10, 10);
    Marine son = new Predator(pos.x + corrX, pos.y +corrY, vel, image);
    return son;
  }
  
  boolean isHungry(){
    return hunger < 1000;
  }

  void wandering() {
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
  
  void hunt(ArrayList<Marine> marines) {
    Prey newTarget = null;
    for (Marine target : marines) {
      if (target instanceof Prey) {
        if (newTarget == null) { 
          newTarget = (Prey) target;
        } else {
          if (PVector.dist(pos, newTarget.pos) > PVector.dist(pos, target.pos)) {
            newTarget = (Prey) target;
          }
        }
      }
    }
    if(newTarget!=null)
    eat(newTarget);
  }

}
