abstract class Marine{
  PVector pos;
  color c;
  
  Marine(float x, float y){
    pos = new PVector(x, y);
  }
  
  abstract void display();
  
}
