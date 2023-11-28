//Dao, David
class Building {
  //Fields:
  PVector position; PVector size; int type;
  PVector[] building_sizes;
  PImage[] building_images;

  //Constructor
  //TODO: add args
  Building(int cellX, int cellY, int buildingType, PImage[] building_images, PVector[] building_sizes) {
    position = new PVector();
    size = new PVector();
    position.x = cellX;
    position.y = cellY;
    this.building_images = building_images;
    this.building_sizes = building_sizes;
    type = buildingType;
  }
  Building(int buildingType){
    position.x = 0;
    position.y = 0;
    type = buildingType;
  }
  Building(){
    position.x = 0;
    position.y = 0;
    type = 0;
  }

  //Displays the building
  void display() {
    image(building_images[type], position.x, position.y);
  }
  
}
