//Dao, David
class UserBuilding extends Building {
  //Fields:
  //Contains all Building fields
  //Other Fields:
  //
  int type; 
  //TODO: choose types - if simple enough we can keep in this one class,
  //mostly appearance and cell limit
  int numCellLimit; //Dictated by type
  float cost; //Again determined by type


  //Constructor
  //TODO: add args
  UserBuilding() {
  }

  //Displays the building on the cityGrid
  void display() {
  }

  //Inherited Building Possible functions:
  //void placeBuilding(){}
  //void removeBuilding(){}
}
