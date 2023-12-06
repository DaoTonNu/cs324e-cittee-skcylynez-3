class Shop {
  //Shop variables:
  //Building nums, name, width, height, cost
  ArrayList<Integer> numTypes;
  ArrayList<String> names;
  ArrayList<PVector> sizes;
  ArrayList<Float> costs;
  ArrayList<Character> hotkeys;

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

    for (TableRow r : buildingInfo.rows()) {
      numTypes.add(r.getInt("Number"));
      names.add(r.getString("Name"));
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

  int chooseBuilding(char k) {
    println(hotkeys); //Debugging Statement

    if (hotkeys.contains(k)) {
      println(k); //Debugging Statement
      curARind = hotkeys.indexOf(k);
      curType = numTypes.get(curARind);
      curName = names.get(curARind);
      curSize = sizes.get(curARind);
      curCost = costs.get(curARind);
    }

    return curType;
  }

  //Function will return the money left
  float makePurchase(float userMoney) {
    return 0.0; //TODO Fix
  }

  void display() {
  }
}
