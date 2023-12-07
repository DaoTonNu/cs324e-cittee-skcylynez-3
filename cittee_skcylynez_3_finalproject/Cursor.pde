//Dao
class Cursor {
  PImage[] sprites;
  PImage curSprite;
  PImage particle;
  float posx;
  float posy;
  boolean clicked;
  int frame;
  int frameIncr;
  float posIncr;
  float relPos;
  color clr;

  Particle[] ptcls;
  Particle[] ptcls2;

  Cursor() {
    posx = mouseX;
    posy = mouseY;
    sprites = new PImage[4];
    for (int i = 0; i<4; i++) {
      curSprite = loadImage("hand_"+str(i+1)+".png");
      curSprite.resize(60, 40);
      sprites[i] = curSprite;
    }
    frame = 1;
    frameIncr = -1;
    posIncr = 1;
    clicked = false;
    clr = color(0, 255, 100);

    ptcls = new Particle[100];
    for (int i = 0; i < ptcls.length; i++) {
      float vx = random(-1, 1);
      float vy = random(-1, 1);
      ptcls[i] = new Particle(mouseX, mouseY, vx, vy, random(1, 10));
    }
    
    ptcls2 = new Particle[100];
    for (int i = 0; i < ptcls2.length; i++) {
      float vx = random(-1, 1);
      float vy = random(-1, 1);
      ptcls2[i] = new Particle(mouseX, mouseY, vx, vy, random(1, 10));
    }
  }

  void display() {
    pushMatrix();
    posx = mouseX;
    posy = mouseY;
    if (clicked) {
      curSprite = sprites[0];
    } else {
      if (frameCount % 15 == 0) {
        if (frame == 3 || frame == 1) {
          frameIncr = -frameIncr;
        }
        frame+= frameIncr;
      }

      if (abs(relPos)>20) {
        {
          posIncr = -posIncr;
          println(posIncr);
        }
      }

      //if (frameCount % 5 == 0){
      relPos += posIncr;
      //}
      translate(0, relPos);

      curSprite = sprites[frame];
    }
    image(curSprite, posx, posy);
    popMatrix();

    pushMatrix();
    push();
    fill(clr);
    translate(mouseX-100, mouseY-100);
    for (int i = 0; i < ptcls.length; i++) {
      ptcls[i].applyForces(random(-0.1, 0.1), random(-0.1, 0.1), false);
      ptcls[i].display();
    }
    pop();
    popMatrix();
      
    push();
    fill(0);
    for (int i = 0; i < ptcls2.length; i++) {
      ptcls2[i].applyForces(random(-0.1, 0.1), random(-0.1, 0.1), false);
      ptcls2[i].display();
    }
    pop();
  }

  void screenPressed(boolean pressed) {
    clicked = pressed;
    if (clicked) {
      clr = color(255);
    } else {
      clr = color(0, 255, 100);
    }
  }
}
