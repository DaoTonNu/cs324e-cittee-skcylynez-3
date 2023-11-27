//Cittee Skcylynez 3
//Adam, Anjali, Dao, David, Saurelle

//ArrayList<Building> allBuildings; //Might be unnecessary
ArrayList<SpawnedBuilding> spawnedBuilds;
ArrayList<UserBuilding> userBuilds;

//Figure out the best structure to hold the grid in? But for now:
int[][] cityGrid;
//consider an arraylist?
//maybe we can hold a lot more info in the grid itself for save purposes?

float userMoney;
//float timePlayed;
//float daysCounter;
//int population;

void setup() {
  size(1100, 800);//Feel free to change this as needed, LET'S TRY TO KEEP EVERYTHING IN TERMS OF WIDTH AND HEIGHT pls :)
  background(color(51, 63, 72 )); //The color.
  
  stroke(255);
  strokeWeight(1);
  
  int widthDivisions = 25;
  int heightDivisions = 25;
  cityGrid = new int[width/widthDivisions][height/heightDivisions];
  for(int i = 0; i < cityGrid.length; i++){
    for(int j = 0; j < cityGrid[0].length; j++){
      cityGrid[i][j] = 0;
      println(cityGrid[i][j], i, j);
    }
  }
  for(int i = 0; i < cityGrid.length; i++){
    line(i * widthDivisions, 0, i * widthDivisions, height);
  }
  for(int j = 0; j < cityGrid[0].length; j++){
    line(0, j * heightDivisions, width, j * heightDivisions);
  }
  
}

void draw() {
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
}
