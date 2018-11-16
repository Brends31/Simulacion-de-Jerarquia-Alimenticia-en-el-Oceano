class Seaweed extends Marine{
	int size = 2;

	Seaweed(float x, float y){
	super(x, y);
	this.c = color(0, 255, 0);
	}
  
  Marine reproduce(){
    float corrX = random(-10, 10); 
    float corrY= random(-10, 10);
    Marine son = new Seaweed(pos.x + corrX, pos.y+ corrY);
    return son;
  }
	void display(){
		fill(c);
		ellipse(pos.x, pos.y, size, size);
	}
  
}
