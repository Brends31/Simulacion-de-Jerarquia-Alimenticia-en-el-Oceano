class Prey extends Fish {

  float preySize = 3;
  float preyViewRatio = 100*preySize;

  Prey(float x, float y, PVector vel, PImage image) {
    this(x, y, vel, image, 1);
  }

  Prey(float x, float y, PVector vel, PImage image, float mass) {
    super(x, y, vel, image);
    this.c = color(0, 0, 255);
    this.mass = mass;
    this.size = preySize;
    viewRatio = preyViewRatio;
  }

  void setHunger() {
    hunger += 700;
  }

  Marine reproduce() {
    float corrX = random(-10, 10); 
    float corrY= random(-10, 10);
    float massVar = 1/(map(hunger, 0, 600, 50, 1));

    Marine son = new Prey(pos.x + corrX, pos.y + corrY, vel, image, mass * massVar);
    return son;
  }

  boolean isHungry() {
    return hunger<1000;
  }

  void hunt(ArrayList<Marine> marines) {
    Seaweed newTarget = null;
    for (Marine target : marines) {
      if (PVector.dist(target.pos, pos) < viewRatio) {
        if (target instanceof Seaweed && isHungry()) {
          if (newTarget == null) { 
            newTarget = (Seaweed) target;
          } 
          else {
            if (PVector.dist(pos, newTarget.pos) > PVector.dist(pos, target.pos)) {
              newTarget = (Seaweed) target;
            }
          }
        } else if (target instanceof Predator) {
          separate((Predator)target);
        } else if (target instanceof SuperPredator){
          separate((SuperPredator)target);
        }
      }
    }
    if (newTarget!=null)
      eat(newTarget);
  }
}
