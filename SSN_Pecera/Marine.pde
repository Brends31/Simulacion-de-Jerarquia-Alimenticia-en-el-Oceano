abstract class Marine{
	PVector pos;
	color c;
	boolean alive = true;
  
	Marine(float x, float y){
		pos = new PVector(x, y);
	}

	abstract void display();
	abstract boolean isDead();
}
