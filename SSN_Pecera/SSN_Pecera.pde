import java.util.Iterator;

import controlP5.*;
ControlP5 cp5;

Sea sea;
ArrayList<Marine> marines;
ArrayList<Fish> preys;

int agentCount;
PImage prey;
PImage predator;
PImage superPredator;

boolean campoVisible = false;
boolean viewRatio = false;
boolean settingPreys = true;
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

  sea = new Sea(20, 0.2, 0.000001);

  marines = new ArrayList<Marine>();
  preys = new ArrayList();

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
      //print(v1.size + "\n");
      if (viewRatio) 
        v1.displayViewRatio();
      v1.move(marines, sea);
    }
    if (v instanceof Prey) {
      Fish v1 = (Fish) v;
      preys.add(v1);
      v1.behave(preys);
      v1.update();
    }
    v.display();
  }

  if (mousePressed) {
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
    if(random(0, 1) < m.reproductionProb)
    m2.add(m.reproduce());
  }
  marines = m2;
}

void keyPressed() {
  if (keyPressed) {
    campoVisible = (key == 'q' || key == 'Q') ? !campoVisible : campoVisible;
    viewRatio = (key == 'a' || key == 'A') ? !viewRatio : viewRatio;
    if (key == 'w' || key == 'W') {
      settingPreys = true;
      settingPredators = false;
      settingSuperPredators = false;
      settingSeaweeds = false;
    }
    if (key == 'e' || key == 'E') {
      settingPreys = false;
      settingPredators = true;
      settingSuperPredators = false;
      settingSeaweeds = false;
    }

    if (key == 'r' || key == 'R') {
      settingPreys = false;
      settingPredators = false;
      settingSuperPredators = true;
      settingSeaweeds = false;
    }

    if (key == 't' || key == 'T') {
      settingPreys = false;
      settingPredators = false;
      settingSuperPredators = false;
      settingSeaweeds = true;
    }
  }
}


void initControls(){
  cp5 = new ControlP5(this);

  cp5.addButton("seaweed")
     .setValue(0)
     .setPosition(100,10)
     .setSize(100,19);

  cp5.addButton("prey")
     .setValue(0)
     .setPosition(300,10)
     .setSize(100,19);

  cp5.addButton("predator")
     .setValue(0)
     .setPosition(500,10)
     .setSize(100,19);

  cp5.addButton("superPredator")
     .setValue(0)
     .setPosition(700,10)
     .setSize(100,19);
}

void seaweed(){
  settingPreys = false;
  settingPredators = false;
  settingSuperPredators = false;
  settingSeaweeds = true;
}

void prey(){
  settingPreys = true;
  settingPredators = false;
  settingSuperPredators = false;
  settingSeaweeds = false;
}

void predator(){
  settingPreys = false;
  settingPredators = true;
  settingSuperPredators = false;
  settingSeaweeds = false;
}

void superPredator(){
  settingPreys = false;
  settingPredators = false;
  settingSuperPredators = true;
  settingSeaweeds = false;
}