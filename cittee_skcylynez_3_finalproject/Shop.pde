//Dao
class Shop {
  //Shop variables:
  //Building nums, name, width, height, cost
  ArrayList<Integer> typeNums;
  ArrayList<String> names;
  ArrayList<PVector> sizes;
  ArrayList<Float> costs;
  ArrayList<Character> hotkeys;

  ArrayList<Button> choiceButtons;
  //building or choosing mode
  boolean choosing;

  int curARind;
  int curType;
  String curName;
  PVector curSize;
  float curCost;
  char curHotkey;

  String[] tester;

  Shop(Table buildingInfo) {
    typeNums = new ArrayList<Integer>();
    names = new ArrayList<String>();
    sizes = new ArrayList<PVector>();
    costs = new ArrayList<Float>();
    hotkeys = new ArrayList<Character>();
    choiceButtons = new ArrayList<Button>();

    choosing = true;

    int n = 0;

    for (TableRow r : buildingInfo.rows()) {
      typeNums.add(r.getInt("Number"));

      names.add(r.getString("Name"));

      if (n>1) {
        choiceButtons.add(new Button(50, 60+n*40, 100, 20, r.getString("Name") + " (" + r.getString("Hotkey") + ")" ));
      }
      n++;

      sizes.add(new PVector(r.getInt("Width"), r.getInt("Height")));
      costs.add(r.getFloat("Cost"));
      hotkeys.add(r.getString("Hotkey").charAt(0));
    }

    //DEBUG STATEMENTS: Can be left for info tho
    println(typeNums);
    println(names);
    println(sizes);
    println(costs);
    println(hotkeys);

    curARind = 2; //default
    curType = typeNums.get(curARind);
    curName = names.get(curARind);
    curSize = sizes.get(curARind);
    curCost = costs.get(curARind);
    curHotkey = hotkeys.get(curARind);
  }

  int returnBuildingType(char k) {
    if (hotkeys.contains(k)) {
      return typeNums.get(hotkeys.indexOf(k));
    }
    return -1;
  }

  void chooseBuilding(char k) {
    println(hotkeys); //Debugging Statement

    if (hotkeys.contains(k)) {
      //println(k); //Debugging Statement
      curARind = hotkeys.indexOf(k);
      curType = typeNums.get(curARind);
      curName = names.get(curARind);
      curSize = sizes.get(curARind);
      curCost = costs.get(curARind);
      curHotkey = hotkeys.get(curARind);
    }
  }

  //Function will return the money left
  float makePurchase(float userMoney) {
    if (curType > 1 && userMoney > curCost) {
      return userMoney-curCost;
    } else { //Cannot purchase
      return -1; //TODO Fix
    }
  }

  void display() {
    if (choosing) {
      for (Button B : choiceButtons) {
        B.display();
      }
    }
  }

    Shop(JSONObject json) {
        // Initialize Shop properties from the json object
        this.curARind = json.getInt("curARind");
        this.curType = json.getInt("curType");
        this.curName = json.getString("curName");
        this.curCost = json.getFloat("curCost");

        // For curSize, assuming it's a PVector
        JSONObject sizeJson = json.getJSONObject("curSize");
        this.curSize = new PVector(sizeJson.getFloat("width"), sizeJson.getFloat("height"));

        // For curHotkey
        String hotkeyStr = json.getString("curHotkey");
        this.curHotkey = hotkeyStr != null && !hotkeyStr.isEmpty() ? hotkeyStr.charAt(0) : ' ';

        // Initialize other properties as needed
    }

    // Method to serialize the Shop object's state to JSON
    public JSONObject toJSON() {
        JSONObject shopJson = new JSONObject();

        // Serialize Shop properties to JSON
        shopJson.setInt("curARind", curARind);
        shopJson.setInt("curType", curType);
        shopJson.setString("curName", curName);
        shopJson.setFloat("curCost", curCost);

        // Serialize curSize
        JSONObject sizeJson = new JSONObject();
        sizeJson.setFloat("width", curSize.x);
        sizeJson.setFloat("height", curSize.y);
        shopJson.setJSONObject("curSize", sizeJson);

        // Serialize curHotkey
        shopJson.setString("curHotkey", String.valueOf(curHotkey));

        // Return the JSON object
        return shopJson;
    }
}
