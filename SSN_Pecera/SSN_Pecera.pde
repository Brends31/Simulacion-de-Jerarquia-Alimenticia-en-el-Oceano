Sea sea;
ArrayList<Fish> fish;
int agentCount;
boolean campoVisible = true;
float extraDegrees = TWO_PI/360;

void setup() {
  fullScreen(P2D);
  background(#27CED6);
  sea = new Sea(20, 0.2, 0.000001);
  fish = new ArrayList<Fish>();
  fish.add(new Prey(random(width),random(height),PVector.random2D()));
  fish.add(new Prey(random(width),random(height),PVector.random2D()));
  fish.add(new Predator(random(width),random(height),PVector.random2D()));
  fish.add(new Predator(random(width),random(height),PVector.random2D()));

}

void draw() {
  color c = color(#27CED6);
  fill(c, 40);
  rect(0, 0, width, height);

  sea.update();
  if (campoVisible)sea.display();

  for (Fish v : fish) {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector f = sea.getForce(v.pos.x, v.pos.y);
    f.normalize();
    v.applyForce(f);
    v.hunt(fish);
    v.update();
    v.display();
  }
  //if (mousePressed) {
  //  for (int i = 0; i < 2; i++) {
  //    Pez v = new Pez(mouseX + 50, mouseY + 50, PVector.random2D());
  //    peces.add(v)
  //  }
  //}
}

void keyPressed() {
  if (keyPressed) {
    if (key == 'q' || key == 'Q') {
      if (campoVisible) {
        campoVisible = false;
      } else {
        campoVisible = true;
      }
    }
  }
}
