//Anjali
class Button {
  //Note from Dao, who is using your button class for the shop button: 
  //I do advise against using width and height alone since Processing reserves that as the canvas width and height; 
  //try w and h instead?
  float x, y, w, h;
  String label;
  PImage image;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  Button(float x, float y, PImage image) {
    this.x = x;
    this.y = y;
    this.w = image.width;
    this.h = image.height;
    this.image = image;
  }

  /*void display() {
    fill(200);
    rect(x, y, width, height);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x + width / 2, y + height / 2);
  }*/
  
  void display() {
    if (image != null) {
      image(image, x, y, w, h);
    } else {
      fill(200);
      rect(x, y, w, h);
      fill(0);
      textAlign(CENTER, CENTER);
      text(label, x + w / 2, y + h / 2);
    }
  }
  

  boolean isMouseOver() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
