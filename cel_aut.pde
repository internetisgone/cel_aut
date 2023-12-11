/**
 * Game of Life
 * by Joan Soler-Adillon.
 *
 * Press SPACE BAR to pause and change the cell's values 
 * with the mouse. On pause, click to activate/deactivate 
 * cells. Press 'R' to randomly reset the cells' grid. 
 * Press 'C' to clear the cells' grid. The original Game 
 * of Life was created by John Conway in 1970.
 */

// Size of cells
int cellSize = 8;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 20; // originally 15

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// temperature decrease each tick
int decreaseAmount = 25;

// Array of cells
int[][] cells; 
// Buffer to record the temperature of the cells and use this 
// while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

// background image 
PImage img;

boolean bgInited = false;

void setup() {
  size (900, 750);

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  //stroke(48);

  noSmooth();

  // Initialization of cells
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      float temperature = random (100);
      if (temperature > probabilityOfAliveAtStart) { 
        temperature = 0;
      }
      else {
        temperature = 255;
      }
      cells[x][y] = int(temperature); // Save temperature of each cell
    }
  }
  
  // Fill in black in case cells don't cover all the windows
  background(0); 
  // img = loadImage("waves.png");
}


void draw() {
  // if (bgInited == false) {
  //   image(img, 0, 0, 900, 750); // 6:5
  //   bgInited = true;
  //   blendMode(SCREEN);
  // }
  
  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      int temperature = cells[x][y];
      fill(color(temperature, temperature, temperature)); 
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
   // Map and avoid out of bound errors
   int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
   xCellOver = constrain(xCellOver, 0, width/cellSize-1);
   int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
   yCellOver = constrain(yCellOver, 0, height/cellSize-1);

   // Check against cells in buffer
   if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
     cells[xCellOver][yCellOver]=0; // Kill
     fill(color(0, 0, 0)); // Fill with kill color
   }
   else { // Cell is dead
     cells[xCellOver][yCellOver]=255; // Make alive
     fill(color(255, 255, 255)); // Fill alive color
   }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
   // Save cells to buffer (so we opeate with one array keeping the other intact)
   for (int x=0; x<width/cellSize; x++) {
     for (int y=0; y<height/cellSize; y++) {
       cellsBuffer[x][y] = cells[x][y];
     }
   }
  }
  
}

void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  
  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      for (int xx=x-1; xx<=x+1;xx++) {
        for (int yy=y-1; yy<=y+1;yy++) {  
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]==255){
                neighbours ++; // Check alive neighbours and count them
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]==255) { // The cell is alive: kill it if necessary
        if (neighbours < 2 || neighbours > 3) {
          cells[x][y] = cellsBuffer[x][y] - 50; // Die unless it has 2 or 3 neighbours
        }
      } 
      else { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          cells[x][y] = 255; // Only if it has 3 neighbours
        }
      } // End of if
      
      // dead cell fades away
      if (cells[x][y] < 255) {
        if (cells[x][y] - decreaseAmount < 0) {
          cells[x][y] = 0;
        }
        else {
          cells[x][y] -= decreaseAmount;
        }     
      }
      
    } // End of y loop
  } // End of x loop
} // End of function

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float temperature = random (100);
        if (temperature > probabilityOfAliveAtStart) {
          temperature = 0;
        }
        else {
          temperature = 255;
        }
        cells[x][y] = int(temperature); // Save temperature of each cell
      }
    }
  }
  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}
