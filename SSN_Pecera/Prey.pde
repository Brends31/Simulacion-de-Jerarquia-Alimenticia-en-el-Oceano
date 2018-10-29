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
        arrive(targetPos);
      }
    }
  
  }
  
}
