//Cittee Skcylynez 3
//Adam, Anjali, Dao, David, Saurelle

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

void setup() {
  size(1100, 800);//Feel free to change this as needed, LET'S TRY TO KEEP EVERYTHING IN TERMS OF WIDTH AND HEIGHT pls :)
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
}

void draw() {
  background(color(51, 63, 72 )); //The color.
  
  fill(255); //God it's annoying to keep track of this stuff, I'm just resetting everything at the beginning of draw for now
  stroke(255); //Feel free to remove this if needed.
  strokeWeight(1);
  
  theCity.displayGridLines();
  theCity.displayBuildings();
  
  updateMouse();
  
  canPlaceBuildingHere = theCity.checkForRoom(int(mouseCell.x), int(mouseCell.y), buildingSelected);
  if(!canPlaceBuildingHere){
    tint(200, 100, 100, 100);
    image(building_images[2], mousePos.x, mousePos.y);
    noTint();
    println("Here3");
  }
  else{
    tint(100, 200, 100, 100);
    image(building_images[2], mousePos.x, mousePos.y);
    noTint();
    println("Here2");
  }
  
  if(mousePressed && canPlaceBuildingHere){
    theCity.placeUserBuilding(int(mouseCell.x), int(mouseCell.y), buildingSelected);
    println("Here");
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
  for(int i = 1; i<building_sizes.length; i++){
    building_sizes[i] = new PVector();
  }
  building_sizes[2].x = 1;
  building_sizes[2].y = 1;
  building_sizes[3].x = 2;
  building_sizes[3].y = 2;
  building_sizes[4].x = 3;
  building_sizes[4].y = 2;
}

void updateMouse(){
    mouseCell.x = round(mouseX / cellSizeX);
    mouseCell.y = round(mouseY / cellSizeY);
    mouseCell.x = constrain(mouseCell.x, 0, (width / cellSizeX)-1);
    mouseCell.y = constrain(mouseCell.y, 0, (height / cellSizeY)-1);
    mousePos.x = mouseCell.x  * cellSizeX;
    mousePos.y = mouseCell.y * cellSizeY;
    
}
