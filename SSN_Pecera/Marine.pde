abstract class Marine{
	PVector pos;
	color c;
	boolean state = true; // true -> alive; false -> dead
  
	Marine(float x, float y){
		pos = new PVector(x, y);
	}

	void setDead(){
		state = false;
	}

	boolean getState(){
		return state;
	}

	abstract void display();
}
