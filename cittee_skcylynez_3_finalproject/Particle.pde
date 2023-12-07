//Dao (taken from the hands on)
class Particle {

  PVector pos;
  PVector vel;
  float r;

  Particle(float x, float y,
    float vx, float vy, float r) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    this.r = r;
  }

  void applyForces(float fx,
    float fy, boolean bounceOn) {
    vel.x += fx;
    vel.y += fy;
    pos.x += vel.x;
    pos.y += vel.y;

    if (bounceOn) {
      bounce();
    } else {
      respawn();
    }
  }

  void display() {
    ellipse(pos.x, pos.y, r, r);
  }

  void bounce() {
    if (pos.x > width) {
      pos.x = width;
      vel.x = -vel.x;
    } else if (pos.x < 0) {
      pos.x = 0;
      vel.x = -vel.x;
    }

    if (pos.y > height) {
      pos.y = height;
      vel.y = -vel.y;
    } else if (pos.y < 0) {
      pos.y = 0;
      vel.y = -vel.y;
    }
  }

  void respawn() {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0 ) {
      pos.x = mouseX;
      pos.y = mouseY;
      vel.x = 0;
      vel.y = 0;
    }
  }
}
