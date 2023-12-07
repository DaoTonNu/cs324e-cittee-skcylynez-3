class Load {

  void loadGame() {
    JSONObject loadData = loadJSONObject("savedgame.json");

    // Loading game state variables
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
    println(userMoney);
    shopOpen = loadData.getBoolean("shopOpen");
    isPaused = loadData.getBoolean("isPaused");
    isHelpVisible = loadData.getBoolean("isHelpVisible");
    isMuted = loadData.getBoolean("isMuted");
    elapsedTime = loadData.getInt("elapsedTime");

    // Adjusting the start time based on the loaded elapsed time
    startTime = millis() - elapsedTime;

    // Loading city and shop data
    initializeAssets();

    //JSONObject shopData = loadData.getJSONObject("shop");
    theShop = new Shop(buildingInfo);

    JSONObject cityData = loadData.getJSONObject("city");
    JSONArray cityGridJ = cityData.getJSONArray("cityGrid");
    int[][] cityGrid = new int[cityGridJ.size()][cityGridJ.getJSONArray(0).size()];
    for (int i = 0; i<cityGridJ.size(); i++) {
      for (int j = 0; j<cityGridJ.getJSONArray(0).size(); j++) {
        cityGrid[i][j] = cityGridJ.getJSONArray(i).getInt(j);
      }
    }

    ArrayList<Building> save_bldgs = new ArrayList<Building>();
    JSONArray buildingsJson = cityData.getJSONArray("buildings");
    JSONObject curJBuild;
    for (int i = 0; i < buildingsJson.size(); i++) {
      curJBuild = buildingsJson.getJSONObject(i);
      save_bldgs.add(new Building(curJBuild.getInt("positionX"), curJBuild.getInt("positionY"), curJBuild.getInt("type"), building_images, building_sizes));
    }
    //Building(int cellX, int cellY, int buildingType, PImage[] building_images, PVector[] building_sizes)

    theCity = new City(cellSizeX, cellSizeY, building_images, building_sizes, cityGrid, theShop, save_bldgs);


    // Additional steps might be needed to fully restore the city state
  }

  void loadSavedGame() {
    loadGame(); // Call loadGame to load the saved state
  }
}
