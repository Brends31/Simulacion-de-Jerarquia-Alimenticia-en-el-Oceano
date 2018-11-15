abstract class Marine{
	PVector pos;
	color c;
	boolean state = true; // true -> alive; false -> dead
  float reproductionProb;
  
	Marine(float x, float y){
		pos = new PVector(x, y);
    reproductionProb = random(0, 0.25);
	}

	void setDead(){
		state = false;
	}

	boolean getState(){
		return state;
	}
  
  abstract Marine reproduce();
	abstract void display();
}
