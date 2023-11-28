//Anjali
class Button {
  float x, y, width, height;
  String label;
  PImage image;

  Button(float x, float y, float width, float height, String label) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.label = label;
  }
  
  Button(float x, float y, PImage image) {
    this.x = x;
    this.y = y;
    this.width = image.width;
    this.height = image.height;
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
      image(image, x, y, width, height);
    } else {
      fill(200);
      rect(x, y, width, height);
      fill(0);
      textAlign(CENTER, CENTER);
      text(label, x + width / 2, y + height / 2);
    }
  }
  

  boolean isMouseOver() {
    return mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height;
  }
}
