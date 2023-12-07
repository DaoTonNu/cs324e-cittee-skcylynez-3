// Cittee Skcylynez 3
// Adam, Anjali, Dao, David, Saurelle

import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//BACKUP TODO consideration: maybe implement a PrettyCursor with animation hierarchy if we can't get people and cars working

//BACKUP TODO consideration: maybe implement a PrettyCursor with animation hierarchy if we can't get people and cars working

interface MenuCallback {
  void onGameStart();
}

// Game state constants
final int MENU = 0, GAME = 1; // Add more states as needed
int gameState;

// Menu
MainMenu mainMenu;

// Minim library
Minim minim;
AudioPlayer gameMusic;

// Global variables for timer
int startTime;
int elapsedTime; // in milliseconds

//Volume slider variables
float volume = 0.5; //Initial volume is at 50%
float sliderX = 50;
float sliderWidth = 200;
boolean draggingVolume = false; // Checks to see whether the volume slider is being dragged

int cellSizeX;
int cellSizeY;

PVector mouseCell;
PVector mousePos;

int tempType;
int buildingSelected;
boolean canPlaceBuildingHere;

float tempCost;
float userMoney;

Table buildingInfo;
PImage[] building_images; //Uses the same building ID's as the City class
PVector[] building_sizes;

City theCity;
Shop theShop;
boolean shopOpen = false;
// We also need to keep track of tentative type while in shop?
//int buildingType = 0;
Button shopButton;

boolean isPaused = false;
boolean isHelpVisible;
boolean isMuted = false;

void startGame() {
  println("The game is starting!"); //Debugging statement
  gameState = GAME;
  gameMusic.loop();
}

void setup() {
  size(1000, 600);

  gameState = MENU; //Starts with the main menu
  mainMenu = new MainMenu(this);
  buildingInfo = loadTable("BuildingTypes.csv", "header");

  //Sets the callback for the main menu
  mainMenu.setMenuCallback(new MenuCallback() {
    public void onGameStart() {
      startGame();
    }
  }
  );
  
  // Initialize timer
    startTime = millis();

  // Music
  minim = new Minim(this);

  // Loads the "firststeps.mp3" song
  gameMusic = minim.loadFile("firststeps.mp3", 2048);

  background(color(51, 63, 72 )); //The color.

  stroke(255);
  fill(255);
  strokeWeight(1);

  cellSizeX = 25;
  cellSizeY = 25;

  mouseCell = new PVector();
  mousePos  = new PVector();

  buildingSelected = 2;
  userMoney = 500000; //TODO: choose a good default amount?
  println("Start Money: $" + userMoney);

  theShop = new Shop(buildingInfo); //TODO implement
  shopButton = new Button(50, 90, 60, 30, "Shop (S)");
  initializeAssets(); //Calls to initialize game asset
  theCity = new City(cellSizeX, cellSizeY, building_images, building_sizes);
}

void draw() {
  switch (gameState) {
  case MENU:
    //println("In Menu"); // Debugging statement
    mainMenu.display();
    break;
  case GAME:
    //println("In Game!"); // Debugging statement
    if (!isPaused) {
      background(color(51, 63, 72 )); //The color.

      fill(255); // Resetting colors at the beginning of draw
      stroke(255);
      strokeWeight(1);

      theCity.displayGridLines();
      theCity.displayBuildings();

      updateMouse();

      elapsedTime = millis() - startTime;
      displayTimer();

      //Tax generation: just mult by household? and there has to be at least 1 office per n-ppl
      if (shopOpen) { //and nominal not yet initialized for this build
        theShop.display();

        //TODO: mod for buildings in shop
        canPlaceBuildingHere = theCity.checkForRoom(int(mouseCell.x), int(mouseCell.y), buildingSelected);
        if (!canPlaceBuildingHere) {
          tint(200, 100, 100, 100);
          image(building_images[buildingSelected], mousePos.x, mousePos.y);
          noTint();
        } else {
          tint(100, 200, 100, 100);
          image(building_images[buildingSelected], mousePos.x, mousePos.y);
          noTint();
        }


        if (!theShop.choosing) {

          //TODO: Place into shop stuff
          if (theShop.makePurchase(userMoney)<0) {

            if (theShop.curType>1) {
              push();
              fill(255);
              rect(width/2, 0, 100, 20);
              fill(255, 0, 0);
              textAlign(LEFT, TOP);
              text("Insufficent Funds", width/2, 10);
              pop();
            }
          } else {

            if (!isMouseOverPauseButton() && !isMouseOverHelpButton() && !isMouseOverExitButton() &&!isMouseOverSaveButton()) {
              if (mousePressed && canPlaceBuildingHere) {
                theCity.placeUserBuilding(int(mouseCell.x), int(mouseCell.y), buildingSelected);
                userMoney = theShop.makePurchase(userMoney);
                println("after purchase: " + userMoney); //Debugging statement
              }
            }
          }
        } else {
          push();
          fill(255);
          rect(30, height-200, 80, 50);
          fill(0);
          textAlign(LEFT, TOP);
          text("Press B to \n open/close \n choice buttons", 30, height-190);
          pop();
        }
        //FIXME: nominal overlap not allowed, but non-nominal still is
        //FIXME: comb thru implementation, seems to not all work

        //MAY MOVE TO SHOP
        //0 is unoccupied
        //1 is cells that are occupied by a building but not the "nominal" coordinates of that building
        //2 is a road
        //3 is the "nominal" coordinates of a house
        //4 is the "nominal" coordinates of a post office
        //5 is the "nominal" coordinates of an office building
        //6 is the "nominal" coordinates of a stadium
        //7 is -----(continue as we add in more buildings)----------
        //-add ability to rotate image within shop!
        // ability to sell/delete? or demolition also costs >:)
        //FIXME: debug the start game also clicking on the screen and adding a road
      }
      shopButton.display();


      drawVolumeSlider(); //Draws the volume slider
    } else {
      fill(0, 0, 0, 70);
      rect(0, 0, width, height);
      fill(255);
      textSize(25);
      text("Paused.", width/2, height/2);
    }

    displayMoney();

    //Draws GUI components
    drawPauseButton();
    drawHelpButton();
    drawExitButton();
    drawSaveButton();

    if (isHelpVisible) {
      drawHelpContent();
    }

    break;
  }
}

void drawVolumeSlider() {
  stroke(255);
  fill(200);
  rect(sliderX, 10, sliderWidth, 20);

  float handleX = sliderX + volume * sliderWidth;
  fill(255);
  rect(handleX, 5, 10, 30);

  if (draggingVolume) {
    volume = constrain((mouseX - sliderX) / sliderWidth, 0, 1);
    gameMusic.setGain(20 * log10(volume));
  }

  //Displays the volume percentage
  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER);
  text(int(volume * 100) + "%", handleX, 35);
}

void mousePressed() {
  //Checks to see if the mouse click is within the volume slider area
  if (mouseX >= sliderX && mouseX <= sliderX + sliderWidth && mouseY >= 5 && mouseY <= 35) {
    draggingVolume = true;
    volume = constrain((mouseX - sliderX) / sliderWidth, 0, 1);
    gameMusic.setGain(20 * log10(volume));
  } else {
    if (isMouseOverPauseButton()) {
      isPaused = !isPaused;
    } else if (isMouseOverHelpButton()) {
      isHelpVisible = !isHelpVisible;
    } else if (isMouseOverExitButton()) {
      gameState = MENU;
      gameMusic.pause(); //Stops the in-game music
      gameMusic.rewind(); //Rewinds the in-game music to the start
      mainMenu.restartMusic();  //Restarts the main menu music
    } else if (isMouseOverSaveButton()){
      print("Game has been saved");
      saveGame();
    } else {
      mainMenu.mousePressed();
    }

    //Checks for game interactions only if it's not interacting with the UI
    if (!isMouseOverPauseButton() && !isMouseOverHelpButton() && !isMouseOverExitButton() && !isMouseOverSaveButton()) {
    }
  }
}

void mouseClicked() {
  if (shopButton.isMouseOver()) {
    shopOpen = true;
    theShop.choosing=true;
  } else if (shopOpen) {
    for (Button b : theShop.choiceButtons) {
      if (b.isMouseOver()) {
        theShop.chooseBuilding(theShop.hotkeys.get(theShop.choiceButtons.indexOf(b)+2));
        buildingSelected = theShop.returnBuildingType(theShop.curHotkey);
      }
    }
  }
}

void mouseClicked() {
  if (shopButton.isMouseOver()) {
    shopOpen = true;
    theShop.choosing=true;
  } else if (shopOpen) {
    for (Button b : theShop.choiceButtons) {
      if (b.isMouseOver()) {
        theShop.chooseBuilding(theShop.hotkeys.get(theShop.choiceButtons.indexOf(b)+2));
        buildingSelected = theShop.returnBuildingType(theShop.curHotkey);
      }
    }
  }
}

void mouseReleased() {
  draggingVolume = false;
}

float log10(float x) {
  return log(x) / log(10);
}

void keyPressed() {
  // Check if the "P" key is pressed
  if (key == 'p' || key == 'P') {
    isPaused = !isPaused;  // Toggle the isPaused variable
  } else if (key == 'm' || key == 'M') {
    isMuted = !isMuted;  // Toggle the isPaused variable
    if (isMuted) {
      gameMusic.setGain(20 * log10(0));
    } else {
      gameMusic.setGain(20 * log10(volume));
    }
  } else if (key == 'b' || key == 'B') {
    theShop.choosing = !theShop.choosing;
  }

  //Within Build mode / inside shop
  // May need a check for if in build mode vs not first
  if (key == 's' || key == 'S') {
    shopOpen = !shopOpen;
    if (shopOpen) {
      theShop.choosing=true;
    }
  }
  if (shopOpen) {
    theShop.display();
    tempType = theShop.returnBuildingType(key);
    if (tempType>1) { //&& tempType<5) { //FIXME: currently breaks for type >=5, we also need to ensure sheet and city match up
      theShop.chooseBuilding(key);
      buildingSelected = tempType;
    }
    println(buildingSelected);// DEBUGGING statement
  }
}

void drawSaveButton() {
  // Draw the pause button at the top right corner
  fill(200);
  rect(width - 240, 10, 44, 20);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("Save", width - 220, 20);
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

boolean isMouseOverSaveButton() {
  // Check if the mouse is over the help button
  return mouseX > width - 240 && mouseX < width - 200 && mouseY > 10 && mouseY < 30;
}

void drawHelpContent() {
  // Draw your help content here
  fill(255);
  rect(200, 100, width - 400, height - 200);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Choose a building type from Shop and place it on the grid. \n Add more and more buildings to rack up points, make money, \n and grow your cittee! \n \n Click \"Pause\" or Press \"P\" to pause the game, \n \"M\" to mute, \n and \"Help\" for instructions on how to play the game.", width / 2, height / 2);
}

void displayMoney() {
  push();
  fill(0, 180, 180);
  stroke(255);
  rect(50, 60, 200, 20);
  fill(0);
  textAlign(LEFT, TOP);
  text("Current Money: $" + str(userMoney), 55, 65);
  pop();
}

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
  int numChoices = theShop.names.size();

  building_sizes = new PVector[numChoices];
  for (int i = 2; i < numChoices; i++) {
    building_sizes[i] = theShop.sizes.get(i);
  }

  building_images = new PImage[numChoices];
  for (int i = 2; i < numChoices; i++) {
    building_images[i] = loadImage(theShop.names.get(i) + ".png");
    building_images[i].resize(int(building_sizes[i].x*cellSizeX), int(building_sizes[i].y*cellSizeY));
  }
}

void updateMouse() {
  mouseCell.x = round(mouseX / cellSizeX);
  mouseCell.y = round(mouseY / cellSizeY);
  mouseCell.x = constrain(mouseCell.x, 0, (width / cellSizeX)-1);
  mouseCell.y = constrain(mouseCell.y, 0, (height / cellSizeY)-1);
  mousePos.x = mouseCell.x  * cellSizeX;
  mousePos.y = mouseCell.y * cellSizeY;
}

void saveGame() {
  JSONObject saveData = new JSONObject();

  saveData.setInt("elapsedTime", elapsedTime);
  saveData.setInt("gameState", gameState);
  saveData.setFloat("volume", volume);
  saveData.setFloat("sliderX", sliderX);
  saveData.setFloat("sliderWidth", sliderWidth);
  saveData.setBoolean("draggingVolume", draggingVolume);
  saveData.setInt("cellSizeX", cellSizeX);
  saveData.setInt("cellSizeY", cellSizeY);
  saveData.setInt("tempType", tempType);
  saveData.setInt("buildingSelected", buildingSelected);
  saveData.setBoolean("canPlaceBuildingHere", canPlaceBuildingHere);
  saveData.setFloat("tempCost", tempCost);
  saveData.setFloat("userMoney", userMoney);
  saveData.setBoolean("shopOpen", shopOpen);
  saveData.setBoolean("isPaused", isPaused);
  saveData.setBoolean("isHelpVisible", isHelpVisible);
  saveData.setBoolean("isMuted", isMuted);

  JSONObject cityData = theCity.toJSON();
  saveData.setJSONObject("city", cityData);

  JSONObject shopData = theShop.toJSON();
  saveData.setJSONObject("shop", shopData);

  saveJSONObject(saveData, "savedgame.json");
}

void loadGame() {
  JSONObject loadData = loadJSONObject("savedgame.json");

  gameState = loadData.getInt("gameState");
  volume = loadData.getFloat("volume");
  sliderX = loadData.getFloat("sliderX");
  sliderWidth = loadData.getFloat("sliderWidth");
  draggingVolume = loadData.getBoolean("draggingVolume");
  cellSizeX = loadData.getInt("cellSizeX");
  cellSizeY = loadData.getInt("cellSizeY");
  tempType = loadData.getInt("tempType");
  buildingSelected = loadData.getInt("buildingSelected");
  canPlaceBuildingHere = loadData.getBoolean("canPlaceBuildingHere");
  tempCost = loadData.getFloat("tempCost");
  userMoney = loadData.getFloat("userMoney");
  shopOpen = loadData.getBoolean("shopOpen");
  isPaused = loadData.getBoolean("isPaused");
  isHelpVisible = loadData.getBoolean("isHelpVisible");
  isMuted = loadData.getBoolean("isMuted");
  elapsedTime = loadData.getInt("elapsedTime");

  // Makes sure the current elapsedTime is correct
  startTime = millis() - elapsedTime;

  theCity.saveCity();

  JSONObject shopData = loadData.getJSONObject("shop");
  theShop = new Shop(shopData);

}

void displayTimer() {
    int seconds = elapsedTime / 1000;
    int minutes = seconds / 60;
    seconds %= 60; // Remaining seconds after minutes

    String timerText = nf(minutes, 2) + ":" + nf(seconds, 2); // Formats time as mm:ss
    fill(255);
    textSize(20);
    text(timerText, 25, 20); // Display the timer at the top-left corner
}
