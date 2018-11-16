import java.util.Iterator;

import controlP5.*;
ControlP5 cp5;

Sea sea;
ArrayList<Marine> marines;
ArrayList<Fish> preys;
ArrayList<Fish> predators;
ArrayList<Fish> superpredators;

int agentCount;
PImage prey;
PImage predator;
PImage superPredator;

boolean campoVisible = false;
boolean viewRatio = false;
boolean settingPreys = false;
boolean settingSeaweeds = false;
boolean settingPredators = false;
boolean settingSuperPredators = false;

float extraDegrees = TWO_PI/360;
float wallx, wally;

void setup() {
  //fullScreen(P2D);

  //Cargado de Imágenes Único
  prey = loadImage("Prey.png");
  predator = loadImage("Predator.png");
  superPredator = loadImage("SuperPredator.png");

  size(1280, 720, P2D);
  background(#27CED6);

  initControls();

  sea = new Sea(35, 0.2, 0.000001);

  marines = new ArrayList<Marine>();
  preys = new ArrayList();
  predators = new ArrayList();
  superpredators = new ArrayList();

  wallx = -width/10;
  wally = -height/10;
}

void draw() {
  color c = color(#27CED6);
  fill(c);
  rect(0, 0, width, height);

  sea.update();
  removeMarines();
  if (frameCount % (60 * 10) == 0) addMarines();

  if (campoVisible)
    sea.display();


  for (Marine v : marines) {

    if (v instanceof Fish) {

      Fish v1 = (Fish) v;
      if (viewRatio) v1.displayViewRatio();
      v1.move(marines, sea);
      
      if (v1 instanceof Prey) {
        preys.add(v1);
        v1.behave(preys);
      }
      else if(v1 instanceof Predator){
        predators.add(v1);
        v1.behave(predators);
      } 
      else if(v1 instanceof SuperPredator){
        superpredators.add(v1);
        v1.behave(superpredators);
      }
    }

    v.display();
    
  }

  if (mousePressed && mouseY > 40) {
    if (settingPreys) {
      marines.add(new Prey(mouseX, mouseY, PVector.random2D(), prey));
    } else if (settingPredators) {
      marines.add(new Predator(mouseX, mouseY, PVector.random2D(), predator));
    } else if (settingSuperPredators) {
      marines.add(new SuperPredator(mouseX, mouseY, PVector.random2D(), superPredator));
    } else if (settingSeaweeds) {
      marines.add(new Seaweed(mouseX, mouseY));
    }
  }
}

void removeMarines() {
  Iterator<Marine> i = marines.iterator();
  while (i.hasNext()) {
    Marine m = i.next();
    if (m.getState() == false)
      i.remove();
  }
}

void addMarines() {
  ArrayList<Marine> m2 = new ArrayList();
  for (Marine m : marines) {
    m2.add(m);
    if (random(0, 1) < m.reproductionProb) m2.add(m.reproduce());
  }
  marines = m2;
}

void initControls() {
  cp5 = new ControlP5(this);

  cp5.addButton("seaweed")
    .setPosition(20, 10)
    .setSize(65, 20);

  cp5.addButton("prey")
    .setPosition(100, 10)
    .setSize(65, 20);

  cp5.addButton("predator")
    .setPosition(180, 10)
    .setSize(65, 20);

  cp5.addButton("superPredator")
    .setPosition(260, 10)
    .setSize(65, 20);

  cp5.addButton("flowfield")
    .setPosition(340, 10)
    .setSize(65, 20);

  cp5.addButton("fishratio")
    .setPosition(420, 10)
    .setSize(65, 20);
}

void seaweed() {
  settingPreys = false;
  settingPredators = false;
  settingSuperPredators = false;
  settingSeaweeds = true;
}

void prey() {
  settingPreys = true;
  settingPredators = false;
  settingSuperPredators = false;
  settingSeaweeds = false;
}

void predator() {
  settingPreys = false;
  settingPredators = true;
  settingSuperPredators = false;
  settingSeaweeds = false;
}

void superPredator() {
  settingPreys = false;
  settingPredators = false;
  settingSuperPredators = true;
  settingSeaweeds = false;
}

void flowfield() {
  campoVisible = !campoVisible;
}

void fishratio() {
  viewRatio = !viewRatio;
}
