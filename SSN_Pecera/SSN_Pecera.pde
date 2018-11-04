Sea sea;
ArrayList<Marine> marines;
ArrayList<Fish> preys;
int agentCount;
boolean campoVisible = true;
boolean settingPreys = true;
boolean settingSeaweeds = false;
boolean settingPredators = false;

float extraDegrees = TWO_PI/360;
float wall;

void setup() {
  //fullScreen(P2D);
  size(1280,720,P2D);
  background(#27CED6);
  sea = new Sea(20, 0.2, 0.000001);
  marines = new ArrayList<Marine>();
  preys = new ArrayList();
  
  wall = width/10;
}

void draw() {
  color c = color(#27CED6);
  fill(c, 40);
  rect(0, 0, width, height);

  sea.update();
  if (campoVisible)
    sea.display();

  for (Marine v : marines) {
    if (v instanceof Fish) {
      move(v);
    }
    v.display();
  }

  // ESTO DA UN PUTAZO DE LAG 
  
  //for (Marine v : marines) {
  //  if (v instanceof Prey) {
  //    Fish v1 = (Fish) v;
  //    preys.add(v1);
  //    v1.separate(preys);
  //    v1.align(preys);
  //    v1.cohesion(preys);
  //    v1.update();
  //  }
  //  v.display();
  //}

  if (mousePressed) {
    if (settingPreys) {
      marines.add(new Prey(mouseX, mouseY, PVector.random2D()));
    } else if (settingPredators) {
      marines.add(new Predator(mouseX, mouseY, PVector.random2D()));
    } else if (settingSeaweeds) {
      marines.add(new Seaweed(mouseX, mouseY));
    }
  }
}

void move(Marine v){
  Fish v1 = (Fish) v;
  PVector f = sea.getForce(v.pos.x, v.pos.y);
  f.normalize();
  v1.wandering();
  v1.applyForce(f);
  v1.hunt(marines);
  v1.update();
}

void keyPressed() {
  if (keyPressed) {
    campoVisible = (key == 'q' || key == 'Q') ? !campoVisible : campoVisible;
    if (key == 'w' || key == 'W') {
      settingPreys = true;
      settingPredators = false;
      settingSeaweeds = false;
    }
    if (key == 'e' || key == 'E') {
      settingPreys = false;
      settingPredators = true;
      settingSeaweeds = false;
    }

    if (key == 'r' || key == 'R') {
      settingPreys = false;
      settingPredators = false;
      settingSeaweeds = true;
    }
  }
}
