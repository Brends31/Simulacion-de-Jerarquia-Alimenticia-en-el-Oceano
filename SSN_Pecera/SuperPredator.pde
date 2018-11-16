class SuperPredator extends Fish {
  
  float superPredatorSize = 5;
  float superPredatorViewRatio = 100*superPredatorSize;

  SuperPredator(float x, float y, PVector vel,PImage image) {
    super(x, y, vel,image);
    this.c = color(255, 0, 255);
    this.mass = 5;
    this.size = superPredatorSize;
    viewRatio = 650;
    
  }
  
  void setHunger(){
    hunger += 950;
  }
  
  Marine reproduce(){
    float corrX = random(-10, 10); 
    float corrY= random(-10, 10);
    Marine son = new SuperPredator(pos.x + corrX, pos.y +corrY, vel, image);
    return son;
  }
  
  boolean isHungry(){
    return hunger < 1000;
  }
  
  void hunt(ArrayList<Marine> marines) {
    Fish newTarget = null;
    for (Marine target : marines) {
      if ((target instanceof Predator || target instanceof Prey) && isHungry()) {
        if (newTarget == null) { 
          newTarget = (Fish) target;
        } else {
          if (PVector.dist(pos, newTarget.pos) > PVector.dist(pos, target.pos)) {
            newTarget = (Fish) target;
          }
        }
      }
    }
    if(newTarget!=null)
    eat(newTarget);
  }

}
