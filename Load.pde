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
        shopOpen = loadData.getBoolean("shopOpen");
        isPaused = loadData.getBoolean("isPaused");
        isHelpVisible = loadData.getBoolean("isHelpVisible");
        isMuted = loadData.getBoolean("isMuted");
        elapsedTime = loadData.getInt("elapsedTime");

        // Adjusting the start time based on the loaded elapsed time
        startTime = millis() - elapsedTime;

        // Loading city and shop data
        JSONObject shopData = loadData.getJSONObject("shop");
        theShop = new Shop(shopData);

        // Additional steps might be needed to fully restore the city state
    }

    void loadSavedGame() {
        loadGame(); // Call loadGame to load the saved state
    }
}
