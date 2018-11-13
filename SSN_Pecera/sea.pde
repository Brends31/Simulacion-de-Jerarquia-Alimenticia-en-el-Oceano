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

  void initGrid() {
    grid = new PVector[rows][];
    for (int r = 0; r < rows; r++) {
      grid[r] = new PVector[columns];
      for (int c = 0; c < columns; c++) {
        grid[r][c] = new PVector(0, 0);
      }
    }
  }

  void updateVectors() {
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

  void update() {
    updateVectors();
  }

  void display() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        displayVector(grid[r][c], c * resolution, r * resolution);
      }
    }
  }

  void displayVector(PVector vector, float x, float y) {
    PVector v = vector.copy();
    v.setMag(resolution / 2);
    pushMatrix();
    stroke(128);
    strokeWeight(1);
    translate(x + resolution / 2, y + resolution / 2);
    line(0, 0, v.x, v.y);
    popMatrix();
  }

  PVector getForce(float x, float y) {
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
