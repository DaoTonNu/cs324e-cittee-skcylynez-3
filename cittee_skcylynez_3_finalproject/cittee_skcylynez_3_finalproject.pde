import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//Cittee Skcylynez 3
//Adam, Anjali, Dao, David, Saurelle

interface MenuCallback {
  void onGameStart();
}

// Game state constants
final int MENU = 0, GAME = 1; // Add more states as needed
int gameState;

//Menu
MainMenu mainMenu;

//Minim library (download from Sketch -> Manage Libraries -> Search Minim -> Download
Minim minim;
AudioPlayer gameMusic;

//Moved over a lot of old globals into the City Class in an attempt to keep everything more organized

int cellSizeX;
int cellSizeY;

PVector mouseCell;
PVector mousePos;

int buildingSelected;
boolean canPlaceBuildingHere;

float userMoney;

//float timePlayed;
//float daysCounter;
//int population;

PImage[] building_images;//Use the same building ID's as the City class
PVector[] building_sizes;

City theCity;
boolean shopOpen = false;
// We also need to keep track of tentative type while in shop?
int buildingType = 0;

boolean isPaused = false;
boolean isHelpVisible;
boolean isMuted = false;
PImage muteImage;


void startGame() {
  println("Starting game"); // Debugging statement
  gameState = GAME;

  //Starts playing the game music
  gameMusic.loop();
}

void setup() {
  size(800, 600);//Feel free to change this as needed, LET'S TRY TO KEEP EVERYTHING IN TERMS OF WIDTH AND HEIGHT pls :)

  gameState = MENU; // Start with the main menu
  mainMenu = new MainMenu(this); // Create an instance of your existing MainMenu class
  initializeAssets(); // Call to initialize game assets

  // Set the callback for the main menu
  mainMenu.setMenuCallback(new MenuCallback() {
    public void onGameStart() {
      startGame();
    }
  }
  );

  //Music
  minim = new Minim(this);

  //Loads the "lake.mp3" song
  gameMusic = minim.loadFile("lake.mp3", 2048);

  background(color(51, 63, 72 )); //The color.

  initializeAssets();

  stroke(255);
  fill(255);
  strokeWeight(1);

  cellSizeX = 25;
  cellSizeY = 25;

  mouseCell = new PVector();
  mousePos  = new PVector();

  buildingSelected = 2;

  theCity = new City(cellSizeX, cellSizeY, building_images, building_sizes);

  muteImage = loadImage("mute.png");
}

void draw() {
  switch (gameState) {
  case MENU:
    println("In Menu"); // Debugging statement
    mainMenu.display();
    break;
  case GAME:
    println("In Game"); // Debugging statement
    Button pauseButton = new Button(width - 50, 10, 40, 20, "Pause");
    Button helpButton = new Button(width - 50, 10, 40, 20, "Help");
    Button exitButton = new Button(width - 50, 10, 40, 20, "Exit");
    Button muteButton = new Button(width - 100, 10, muteImage);
    if (!isPaused) {
      background(color(51, 63, 72 )); //The color.

      fill(255); //God it's annoying to keep track of this stuff, I'm just resetting everything at the beginning of draw for now
      stroke(255); //Feel free to remove this if needed.
      strokeWeight(1);

      theCity.displayGridLines();
      theCity.displayBuildings();

      updateMouse();

      canPlaceBuildingHere = theCity.checkForRoom(int(mouseCell.x), int(mouseCell.y), buildingSelected);
      if (!canPlaceBuildingHere) {
        tint(200, 100, 100, 100);
        image(building_images[2], mousePos.x, mousePos.y);
        noTint();
        println("Here3");
      } else {
        tint(100, 200, 100, 100);
        image(building_images[2], mousePos.x, mousePos.y);
        noTint();
        println("Here2");
      }

      if (!isMouseOverPauseButton() && !isMouseOverHelpButton() && !isMouseOverExitButton() && !isMouseOverMuteButton())
        if (mousePressed && canPlaceBuildingHere) {
          theCity.placeUserBuilding(int(mouseCell.x), int(mouseCell.y), buildingSelected);
          println("Here");
        }

      if (!isMuted) {
        // Play sound or perform other sound-related actions
      }
    } else {
      fill(0, 0, 0, 70);
      rect(0, 0, width, height);
      fill(255);
      textSize(25);
      text("Paused.", width/2, height/2);
    }

    drawPauseButton();
    drawHelpButton();
    drawExitButton();
    drawMuteButton();

    if (isHelpVisible) {
      drawHelpContent();
    }
  }
}

//Dao, David
//Classes (filed), plus figure out shop?

//Adam, Anjali
//Consider moving the in depth funcs for these
//to different files, maybe under a GameSettings class or something?
//Refer to Project Plan for guidelines on what needs to be saved.
void saveGame() {
}

void loadGame() {
}

void mouseClicked() {
  mainMenu.mousePressed();
  // Check if the mouse click is on the pause button
  if (isMouseOverPauseButton()) {
    isPaused = !isPaused;
  } else if (isMouseOverHelpButton()) {
    isHelpVisible = !isHelpVisible;  // Toggle the isHelpVisible variable
  } else if (isMouseOverExitButton()) {
    gameState = MENU;
  } else if (isMouseOverMuteButton()) {
    isMuted = !isMuted;
  }
}
void keyPressed() {
  // Check if the "P" key is pressed
  if (key == 'p' || key == 'P') {
    isPaused = !isPaused;  // Toggle the isPaused variable
  }
  if (key == 'm' || key == 'M') {
    isMuted = !isMuted;
  }

  //Within Build mode / inside shop
  // May need a check for if in build mode vs not first
  if (key == 's' || key == 'S') {
    shopOpen = !shopOpen;
  }
  if (shopOpen) { //and nominal not yet initialized for this build
    //0 is unoccupied
    //1 is cells that are occupied by a building but not the "nominal" coordinates of that building
    //2 is a road
    //3 is the "nominal" coordinates of a house
    //4 is the "nominal" coordinates of a post office
    //5 is the "nominal" coordinates of an office building
    //6 is the "nominal" coordinates of a stadium
    //7 is -----(continue as we add in more buildings)----------
    switch(key) {
    case 'r':
      buildingType = 2;
      break;
    case 'h':
      buildingType = 3;
      break;
    case 'p':
      buildingType = 4;
      break;
    case 'o':
      buildingType = 5;
      break;
    case 't':
      buildingType = 6;
      break;
      //Other building types or is America just sports and justice? :D
      //case '':
      //buildingType = 7;
      //break;
    }   
  }
}

void drawPauseButton() {
  // Draw the pause button at the top right corner
  fill(200);
  rect(width - 120, 10, 44, 20);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(12);
  if (!isPaused) {
    text("Pause", width - 100, 20);
  } else {
    text("Play", width - 100, 20);
  }
}

void drawExitButton() {
  // Draw the help button at the top right corner
  fill(200);
  rect(width - 180, 10, 44, 20);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Exit", width - 160, 20);
}

void drawHelpButton() {
  // Draw the help button at the top right corner
  fill(200);
  rect(width - 60, 10, 50, 20);
  fill(0);
  textAlign(CENTER, CENTER);
  if (!isHelpVisible) {
    text("Help", width - 35, 20);
  } else {
    text("Hide Help", width - 33.5, 20);
  }
}

void drawMuteButton() {
  // Draw the mute button with an image
  image(muteImage, width - 220, 10, 30, 20);
}

boolean isMouseOverPauseButton() {
  // Check if the mouse is over the pause button
  return mouseX > width - 120 && mouseX < width - 80 && mouseY > 10 && mouseY < 30;
}

boolean isMouseOverHelpButton() {
  // Check if the mouse is over the help button
  return mouseX > width - 60 && mouseX < width - 10 && mouseY > 10 && mouseY < 30;
}

boolean isMouseOverExitButton() {
  // Check if the mouse is over the help button
  return mouseX > width - 180 && mouseX < width - 140 && mouseY > 10 && mouseY < 30;
}

boolean isMouseOverMuteButton() {
  return mouseX > width - 100 && mouseX < width - 60 && mouseY > 10 && mouseY < 30;
}

void drawHelpContent() {
  // Draw your help content here
  fill(255);
  rect(200, 100, width - 400, height - 200);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Choose a building type from Shop and place it on the grid. \n Add more and more buildings to rack up points, make money, \n and grow your cittee! \n \n Click \"Pause\" or Press \"P\" to pause the game \n and \"Help\" for instructions on how to play the game.", width / 2, height / 2);
}

//Funcs dealing with sound

//Saurelle
//Note that this may be moved around or split up amongst the other classes,
//depending on where we may need it.
//Initializes environment background, building images,
//people sprites, car sprites, possibly particles (if we use images), etc.
void initializeAssets() {
  //0 is unoccupied
  //1 is cells that are occupied by a building but not the "nominal" coordinates of that building
  //2 is a road
  //3 is the "nominal" coordinates of a house
  //4 is the "nominal" coordinates of a post office
  //5 is the "nominal" coordinates of an office building
  //6 is the "nominal" coordinates of a stadium
  building_images = new PImage[10];
  building_images[2] = loadImage("Road.png");
  building_images[3] = loadImage("House.png");
  building_images[4] = loadImage("PostOffice.png");

  building_sizes = new PVector[10];
  for (int i = 1; i<building_sizes.length; i++) {
    building_sizes[i] = new PVector();
  }
  building_sizes[2].x = 1;
  building_sizes[2].y = 1;
  building_sizes[3].x = 2;
  building_sizes[3].y = 2;
  building_sizes[4].x = 3;
  building_sizes[4].y = 2;
}

void updateMouse() {
  mouseCell.x = round(mouseX / cellSizeX);
  mouseCell.y = round(mouseY / cellSizeY);
  mouseCell.x = constrain(mouseCell.x, 0, (width / cellSizeX)-1);
  mouseCell.y = constrain(mouseCell.y, 0, (height / cellSizeY)-1);
  mousePos.x = mouseCell.x  * cellSizeX;
  mousePos.y = mouseCell.y * cellSizeY;
}
