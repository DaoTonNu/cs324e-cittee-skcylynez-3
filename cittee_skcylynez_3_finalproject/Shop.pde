class Shop {
  //Shop variables:
  //Building nums, name, width, height, cost
  ArrayList<Integer> numTypes;
  ArrayList<String> names;
  ArrayList<PVector> sizes;
  ArrayList<Float> costs;
  
  String[] tester;

  Shop(Table buildingInfo) {
    numTypes = new ArrayList<Integer>();
    names = new ArrayList<String>();
    sizes = new ArrayList<PVector>();
    costs = new ArrayList<Float>();

    for (TableRow r : buildingInfo.rows()) {
      numTypes.add(r.getInt("Number"));
      names.add(r.getString("Name"));
      sizes.add(new PVector(r.getInt("Width"), r.getInt("Height")));
      costs.add(r.getFloat("Cost"));
    }
  }

  //Function will return the money left
  float makePurchase(float userMoney) {
    return 0.0; //TODO Fix
  }

  void display() {
  }
}
