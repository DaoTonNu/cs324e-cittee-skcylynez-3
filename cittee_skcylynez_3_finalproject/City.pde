//David
class City {
  //ArrayList<Building> allBuildings; //Might be unnecessary//Moved over from main file
  ArrayList<Building> buildings;//Moved over from main file
  //Figure out the best structure to hold the grid in? But for now:
  int cellSizeX;
  int cellSizeY;
  int[][] cityGrid;
  //0 is unoccupied
  //1 is cells that are occupied by a building but not the "nominal" coordinates of that building
  //2 is a road
  //3 is the "nominal" coordinates of a house
  //4 is the "nominal" coordinates of a post office
  //5 is the "nominal" coordinates of an office building
  //6 is the "nominal" coordinates of a stadium
  //7 is -----(continue as we add in more buildings)----------
  int buildingSelected;//This will line up with the above as well
  PVector curSize;
  Shop shop; //so it can pull info from shop

  PImage[] building_images;
  PVector[] building_sizes;

  //What do I mean by "nominal coordinates?
  //Here's an example: A house takes up cells 22, 23, 32, and 33. We want to make it easy to have one primary coordinate location (22 here) per building object
  //which makes saving easier. But we also want to notate that we can't put a building in say cell 33 so we have an "occupied" code (1) stored there
  //This way we can use the same grid for saving as we do for checking building objects as we place them
  //  |------|------|------|------|
  //  |  11  |  12  |  13  |  14  |
  //  |------|------|------|------|
  //  |  21  |**22**| *23* |  24  |
  //  |------|------|------|------|
  //  |  31  | *32* | *33* |  34  |
  //  |------|------|------|------|
  //  |  41  |  42  |  43  |  44  |
  //  |------|------|------|------|

  City(int cellSizeX, int cellSizeY, PImage[] building_images, PVector[] building_sizes, Shop theShop) {
    this.cellSizeX = cellSizeX;
    this.cellSizeY = cellSizeY;
    this.building_images = building_images;
    this.building_sizes = building_sizes;
    cityGrid = new int[width/cellSizeX][height/cellSizeY];
    for (int i = 0; i < cityGrid.length; i++) {
      for (int j = 0; j < cityGrid[0].length; j++) {
        cityGrid[i][j] = 0;
      }
    }
    buildings = new ArrayList<Building>(1);
    curSize = building_sizes[2];
    shop = theShop;
  }
  City(int cellSizeX, int cellSizeY, PImage[] building_images, PVector[] building_sizes, int[][] Saved_City_Grid, Shop theShop) {
    this.cellSizeX = cellSizeX;
    this.cellSizeY = cellSizeY;
    this.building_images = building_images;
    this.building_sizes = building_sizes;
    cityGrid = Saved_City_Grid;
    buildings = new ArrayList<Building>(1);
    curSize = building_sizes[2];
    shop = theShop;
  }
  void displayBuildings() {
    for (Building A_building : buildings) {
      A_building.display();
    }
  }
  void displayGridLines() {
    for (int i = 0; i < cityGrid.length; i++) {
      line(i * cellSizeX, 0, i * cellSizeX, height);
    }
    for (int j = 0; j < cityGrid[0].length; j++) {
      line(0, j * cellSizeY, width, j * cellSizeY);
    }
  }

  boolean checkForRoom(int cellX, int cellY, int buildingType) {
    curSize = shop.sizes.get(shop.typeNums.indexOf(buildingType));
    //check each elem
    for (int i = cellX; i < cellX+curSize.x; i++) {
      for (int j = cellY; j < cellY+curSize.y; j++) {
        if (i>=cityGrid.length || j>=cityGrid[0].length || i<0 ) {
          return false;
        } else if (cityGrid[i][j] != 0) {
          return false;
        }
      }
    }
    return true;

    //if (cityGrid[cellX][cellY] == 0) {
    //  return true;
    //} else {

    //  return false;
    //}
  }
  void placeUserBuilding(int cellX, int cellY, int buildingType) {
    cityGrid[cellX][cellY] = buildingType;
    Building theNewBuilding = new Building(cellX * cellSizeX, cellY * cellSizeY, buildingType, building_images, building_sizes);
    buildings.add(theNewBuilding);

    curSize = shop.sizes.get(shop.typeNums.indexOf(buildingType));

    for (int i = cellX; i < cellX+curSize.x; i++) {
      for (int j = cellY; j < cellY+curSize.y; j++) {
        if (i>cityGrid.length || j>cityGrid[0].length || i<0 || (i==cellX && j==cellY)) {
          continue;
        } else {
          cityGrid[i][j] = 1;
          buildings.add(new Building(i * cellSizeX, j * cellSizeY, 1, building_images, building_sizes));
        }
      }
      //userBuilds.add(theNewBuilding);
    }
  }

  void placeSpawnedBuilding() {
  }

  void saveCity() {
    // Use the toJSON() method to get the JSON representation of the city
    JSONObject cityJson = this.toJSON();

    // Save the JSON object to a file
    saveJSONObject(cityJson, "city_save.json");
  }

  JSONObject toJSON() {
    JSONObject cityJson = new JSONObject();

    // Serialize cityGrid
    JSONArray cityGridArray = new JSONArray();
    for (int[] row : cityGrid) {
      JSONArray rowArray = new JSONArray();
      for (int cell : row) {
        rowArray.append(cell);
      }
      cityGridArray.append(rowArray);
    }
    cityJson.setJSONArray("cityGrid", cityGridArray);

    // Serialize buildings
    JSONArray buildingsArray = new JSONArray();
    for (Building building : buildings) {
      JSONObject buildingJson = building.toJSON(); // Ensure Building class has toJSON()
      buildingsArray.append(buildingJson);
    }
    cityJson.setJSONArray("buildings", buildingsArray);

    return cityJson;
  }
}
