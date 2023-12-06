class Shop {
  //Shop variables:
  //Building nums, name, width, height, cost
  ArrayList<Integer> numTypes;
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
  //char curHotkey;

  String[] tester;

  Shop(Table buildingInfo) {
    numTypes = new ArrayList<Integer>();
    names = new ArrayList<String>();
    sizes = new ArrayList<PVector>();
    costs = new ArrayList<Float>();
    hotkeys = new ArrayList<Character>();
    choiceButtons = new ArrayList<Button>();

    choosing = true;

    int n = 0;

    for (TableRow r : buildingInfo.rows()) {
      numTypes.add(r.getInt("Number"));

      names.add(r.getString("Name"));

      if (n>1) {
        choiceButtons.add(new Button(40, 40+n*40, 100, 20, r.getString("Name") + " (" + r.getString("Hotkey") + ")" ));
      }
      n++;

      sizes.add(new PVector(r.getInt("Width"), r.getInt("Height")));
      costs.add(r.getFloat("Cost"));
      hotkeys.add(r.getString("Hotkey").charAt(0));
    }
    println(numTypes);
    println(names);
    println(sizes);
    println(costs);
    println(hotkeys);

    curARind = 2; //default
    curType = numTypes.get(curARind);
    curName = names.get(curARind);
    curSize = sizes.get(curARind);
    curCost = costs.get(curARind);
  }

  int returnBuildingType(char k) {
    if (hotkeys.contains(k)) {
      return numTypes.get(hotkeys.indexOf(k));
    }
    return -1;
  }

  void chooseBuilding(char k) {
    println(hotkeys); //Debugging Statement

    if (hotkeys.contains(k)) {
      println(k); //Debugging Statement
      curARind = hotkeys.indexOf(k);
      curType = numTypes.get(curARind);
      curName = names.get(curARind);
      curSize = sizes.get(curARind);
      curCost = costs.get(curARind);
    }
  }

  //Function will return the money left
  float makePurchase(float userMoney) {
    println("before purchase: " + userMoney);
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
}
