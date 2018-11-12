import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SSN_Pecera extends PApplet {



Sea sea;

ArrayList<Marine> marines;
ArrayList<Fish> preys;

int agentCount;

boolean campoVisible = true;
boolean settingPreys = true;
boolean viewRatio = false;
boolean settingSeaweeds = false;
boolean settingPredators = false;

float extraDegrees = TWO_PI/360;
float wall;

public void setup() {
  //fullScreen(P2D);
  
  background(0xff27CED6);

  sea = new Sea(20, 0.2f, 0.000001f);

  marines = new ArrayList<Marine>();
  preys = new ArrayList();

  wall = width/10;
}

public void draw() {
  int c = color(0xff27CED6);
  fill(c, 40);
  rect(0, 0, width, height);

  sea.update();
  remove();

  if (campoVisible)
    sea.display();


  for (Marine v : marines) {
    if (v instanceof Fish) {
      Fish v1 = (Fish) v;
      if (viewRatio) 
        v1.displayViewRatio();
      v1.move(marines, sea);
    }
    if (v instanceof Prey) {
      Fish v1 = (Fish) v;
      preys.add(v1);
      //v1.behave(preys);
      v1.update();
    }
    v.display();
  }

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

public void remove(){
  Iterator<Marine> i = marines.iterator();
  while (i.hasNext()){
    Marine m = i.next();
    if (m instanceof Seaweed) println("getState(): "+m.getState());
    if (m.getState() == false)
      i.remove();
  }
}

public void keyPressed() {
  if (keyPressed) {
    campoVisible = (key == 'q' || key == 'Q') ? !campoVisible : campoVisible;
    viewRatio = (key == 'a' || key == 'A') ? !viewRatio : viewRatio;
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
abstract class Fish extends Marine {
  PVector vel;
  PVector acc;
  float mass;
  float size;
  float maxSpeed;
  float maxForce;
  float arrivalRadius;
  float separationDistance = 2;
  float separationRatio = 5;
  float alignmentDistance = 150;
  float alignmentRatio = 0.5f;
  float cohesionDistance = 250;
  float cohesionRatio = 0.02f;
  float hunger;
  float viewRatio;

  Fish(float x, float y, PVector vel) {
    super(x, y);
    this.vel = vel;
    acc = new PVector(0, 0);
    maxSpeed = random(1, 3);
    maxForce = random(1.2f, 2);
    arrivalRadius = 200;
  }
  public void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  public void display() {
    float ang = vel.heading();
    noStroke();
    fill(c, 100);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(ang);
    beginShape();
    vertex(0, size);
    vertex(0, -size);
    vertex(size * 3, 0);
    endShape(CLOSE);
    popMatrix();
  }

  public void displayViewRatio() {
    stroke(10);
    noFill();
    ellipse(pos.x, pos.y, viewRatio, viewRatio);
  }

  public void update() {
    checkBorders();
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  public void checkBorders() {
    if (pos.x < -size*5 || pos.x > width + size*5) {
      pos.x = constrain(pos.x, -size*5, width + size*5);
      vel.x *=-0.6f;
    }
    if (pos.y < -size*10 || pos.y > height + size*5) {
      pos.y = constrain(pos.y, -size*5, height + size*5);
      vel.y *= -0.6f;
    }
  }

  public void seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeed);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);
    applyForce(steering);
  }

  public void arrive(PVector targetPos) {
    PVector desired = PVector.sub(targetPos, pos);
    float d = PVector.dist(targetPos, pos);
    d = constrain(d, 0, arrivalRadius);
    float speed = map(d, 0, arrivalRadius, 0, maxSpeed);
    vel.setMag(speed);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);
    applyForce(steering);
  }

  // void separate(ArrayList<Fish> fishes) {
  //   PVector average = new PVector(0, 0);
  //   int count = 0;
  //   for (Fish f : fishes) {
  //     float d = PVector.dist(pos, v.pos);
  //     if (this != v && d < separationDistance) {
  //       PVector difference = PVector.sub(pos, v.pos);
  //       difference.normalize();
  //       difference.div(d);
  //       average.add(difference);
  //       count ++;
  //     }
  //   }
  //   if (count > 0) {
  //     average.div(count);
  //     average.mult(separationRatio);
  //     average.limit(maxSpeed);
  //     applyForce(average);
  //   }
  // }

  // void align(ArrayList<Fish> fishes) {
  //   PVector average = new PVector(0, 0);
  //   int count = 0;
  //   for (Fish f : fishes) {
  //     float d = PVector.dist(pos, v.pos);
  //     if (this != v && d < alignmentDistance) {
  //       average.add(v.vel);
  //       count++;
  //     }
  //   }
  //   if (count > 0) {
  //     average.div(count);
  //     average.mult(alignmentRatio);
  //     average.limit(maxSpeed);
  //     applyForce(average);
  //   }
  // }

  // void cohere(ArrayList<Fish> fishes) {
  //   PVector average = new PVector(0, 0);
  //   int count = 0;
  //   for (Fish f : fishes) {
  //     float d = PVector.dist(pos, v.pos);
  //     if (this != v && d < cohesionDistance) {
  //       average.add(v.pos);
  //       count++;
  //     }
  //   }
  //   if (count > 0) {
  //     average.div(count);
  //     PVector force = average.sub(pos);
  //     force.mult(cohesionRatio);
  //     force.limit(maxSpeed);
  //     applyForce(force);
  //   }
  // }

  public void behave(ArrayList<Fish> fishes){
    PVector averageSeparation = new PVector(0, 0);
    PVector averageAlignment = new PVector(0, 0);
    PVector averageCohere = new PVector(0, 0);
    int countSeparation = 0;
    int countAlignment = 0;
    int countCohere = 0;

    // separate & align & cohere //
    for (Fish f : fishes) {
      float d = PVector.dist(pos, f.pos);
      
      if (this != f && d < separationDistance) {
        PVector difference = PVector.sub(pos, f.pos);
        difference.normalize();
        difference.div(d);
        averageSeparation.add(difference);
        countSeparation++;
      }

      if (this != f && d < alignmentDistance) {
        averageAlignment.add(f.vel);
        countAlignment++;
      }

      if (this != f && d < cohesionDistance) {
        averageCohere.add(f.pos);
        countCohere++;
      }
    }

    if (countSeparation > 0) {
      averageSeparation.div(countSeparation);
      averageSeparation.mult(separationRatio);
      averageSeparation.limit(maxSpeed);
      applyForce(averageSeparation);
    }

    if (countAlignment > 0) {
      averageAlignment.div(countAlignment);
      averageAlignment.mult(alignmentRatio);
      averageAlignment.limit(maxSpeed);
      applyForce(averageAlignment);
    }

    if (countCohere > 0) {
      averageCohere.div(countCohere);
      PVector force = averageCohere.sub(pos);
      force.mult(cohesionRatio);
      force.limit(maxSpeed);
      applyForce(force);
    }

  }


  public void eat(Marine food) {
    if (PVector.dist(pos, food.pos) < 10) {
      food.setDead();
    }
  }

  public void move(ArrayList<Marine> marines, Sea sea) {
    PVector f = sea.getForce(pos.x, pos.y);
    f.normalize();
    wandering();
    applyForce(f);
    if(hunger < 20) hunt(marines);
    update();
    hunger--;
  }

  public abstract void wandering();
  public abstract void hunt(ArrayList<Marine> marines);
}
abstract class Marine{
	PVector pos;
	int c;
	boolean state = true; // true -> alive; false -> dead
  
	Marine(float x, float y){
		pos = new PVector(x, y);
	}

	public void setDead(){
		state = false;
	}

	public boolean getState(){
		return state;
	}

	public abstract void display();
}
class Predator extends Fish {

  Predator(float x, float y, PVector vel) {
    super(x, y, vel);
    this.c = color(255, 0, 0);
    this.mass = 5;
    this.size = mass/2 + 5;
    viewRatio = 250;
    hunger = 30;
  }

  public void wandering() {
  }
  
  public void hunt(ArrayList<Marine> marines) {
    for (Marine target : marines) {
      if (target instanceof Prey) {
        PVector targetPos = target.pos;
        if (PVector.dist(pos, target.pos) < viewRatio)
          arrive(targetPos);
        if (PVector.dist(pos, target.pos) < 10)
          target.setDead();
      }
    }
  }

}
class Prey extends Fish{
  
  Prey(float x, float y, PVector vel){
    super(x, y, vel);
    this.c = color(0,0,255);
    this.mass = 1;
    this.size = mass/2 + 5;
    viewRatio = 150;
    hunger = 60;
  }
  
  public void wandering(){
    if (pos. x < wall) {
      PVector desired = new PVector(maxSpeed,vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    } 
    else if (pos.x > (width-wall)){
      PVector desired = new PVector(-maxSpeed,vel.y);
      PVector steer = PVector.add(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }

    if(pos.y < wall){
      PVector desired = new PVector(vel.x,maxSpeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    } else if(pos.y > (height - wall)){
      PVector desired = new PVector(-maxSpeed,vel.y);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      applyForce(steer);
    }
  }
  
  public void hunt(ArrayList<Marine> marines){
    for (Marine target : marines) {
      if (target instanceof Seaweed) {
        PVector targetPos = target.pos;
        if (PVector.dist(pos, target.pos) < viewRatio)
          arrive(targetPos);
      }
    }
  }

}
class Seaweed extends Marine{
	int size = 6;

	Seaweed(float x, float y){
	super(x, y);
	this.c = color(0, 255, 0);
	}

	public void display(){
		fill(c);
		ellipse(pos.x, pos.y, size, size);
	}
  
}
class Sea {
  PVector[][] grid;
  float res;
  int rows;
  int columns;
  float resolution;
  float noiseResolution; // amplitud del ruido
  float directionNoiseOffset;
  float directionChangeSpeed;

  Sea(float resolution, float noiseResolution, float directionChangeSpeed) {
    this.resolution = resolution;
    this.noiseResolution = noiseResolution;
    this.directionChangeSpeed = directionChangeSpeed;
    rows = (int)(height / resolution);
    columns = (int)(width / resolution);
    initGrid();
  }

  public void initGrid() {
    grid = new PVector[rows][];
    for (int r = 0; r < rows; r++) {
      grid[r] = new PVector[columns];
      for (int c = 0; c < columns; c++) {
        grid[r][c] = new PVector(0, 0);
      }
    }
  }

  public void updateVectors() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        float angle = noise((float)r * noiseResolution, (float)c * noiseResolution, directionNoiseOffset);
        angle = map(angle, 0, 1, 0, TWO_PI);
        float mag = 2;
        grid[r][c] = PVector.fromAngle(angle+extraDegrees);
        grid[r][c].mult(mag);
        //grid[r][c].set(cos(radians(angle)) * mag, sin(radians(angle)) * mag); // oh geez rick idk
        directionNoiseOffset += directionChangeSpeed;
      }
    }
    extraDegrees+=TWO_PI/360;
  }

  public void update() {
    updateVectors();
  }


  public void display() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        displayVector(grid[r][c], c * resolution, r * resolution);
      }
    }
  }

  public void displayVector(PVector vector, float x, float y) {
    PVector v = vector.copy();
    v.setMag(resolution / 2);
    pushMatrix();
    stroke(128);
    strokeWeight(1);
    translate(x + resolution / 2, y + resolution / 2);
    line(0, 0, v.x, v.y);
    popMatrix();
  }

  public PVector getForce(float x, float y) {
    if (x >= 0 && x < width) {
      if (y >= 0 && y < height) {
        int r = (int)(y / resolution) % rows;
        int c = (int)(x / resolution) % columns;
        return grid[r][c];
      }
    }
    return new PVector(0, 0);
  }
}
  public void settings() {  size(1280, 720, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SSN_Pecera" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
