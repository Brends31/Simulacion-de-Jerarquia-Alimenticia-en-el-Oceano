class Prey extends Fish{
  
  Prey(float x, float y, PVector vel, PImage image){
    this(x, y, vel,image, 1);
  }
  
  Prey(float x, float y, PVector vel, PImage image, float mass){
    super(x, y, vel,image);
    this.c = color(0,0,255);
    this.mass = mass;
    this.size = mass/2 + 5;
    viewRatio = 150;
    hunger = 600;
  }
  
  void setHunger(){
    hunger = 600;
  }
  
  Marine reproduce(){
    float corrX = random(-10, 10); 
    float corrY= random(-10, 10);
    float massVar = 1/(map(hunger, 0, 600, 50, 1));
    
    Marine son = new Prey(pos.x + corrX, pos.y + corrY, vel, image, mass * massVar);
    return son;
  }
  
  boolean isHungry(){
    return hunger<300;
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
