class Seaweed extends Marine{
  Seaweed(float x, float y){
    super(x, y);
    c = color(0, 255, 0);
  }
  
  void display(){
    fill(c);
    ellipse(pos.x, pos.y, 10, 10);
  }
}
