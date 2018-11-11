class Seaweed extends Marine{
	int size = 6;

	Seaweed(float x, float y){
	super(x, y);
	this.c = color(0, 255, 0);
	}

	void display(){
		fill(c);
		ellipse(pos.x, pos.y, size, size);
	}
  
}
