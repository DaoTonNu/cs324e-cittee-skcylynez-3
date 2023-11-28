//Adam

import ddf.minim.*;
import processing.core.PApplet;
import java.util.ArrayList;

class Cloud {
    float x, y, speed;
    PApplet parent; //Reference to the main PApplet

    Cloud(PApplet parent, float x, float y, float speed) {
        this.parent = parent;
        this.x = x;
        this.y = y;
        this.speed = speed;
    }

    void update() {
        x += speed;
        if (x > parent.width + 100) {
            x = -100;
            y = parent.random(50, 150); //Reset position with new random height
            speed = parent.random(0.5, 2.0); //Reset speed
        }
    }

    void draw() {
        parent.fill(255);
        parent.ellipse(x, y, 60, 40);
        parent.ellipse(x + 30, y + 10, 40, 30);
    }
}

class MainMenu {
    MenuCallback callback;
    Minim minim;
    AudioPlayer menuMusic;
    PApplet parent;
    ArrayList<Cloud> clouds;
    boolean mouseWasPressed = false; //Tracks mouse button state

    MainMenu(PApplet parent) {
        this.parent = parent;
        this.minim = new Minim(parent);
        this.menuMusic = this.minim.loadFile("firststeps.mp3", 2048);
        this.menuMusic.loop();

        //Clouds
        clouds = new ArrayList<Cloud>();
        int numClouds = (int) parent.random(10, 21); //Random number of clouds between 10 and 20
        for (int i = 0; i < numClouds; i++) {
            float x = parent.random(-100, parent.width + 100);
            float y = parent.random(50, 150);
            float speed = parent.random(0.5, 2.0);
            clouds.add(new Cloud(parent, x, y, speed));
        }
    }

    void setMenuCallback(MenuCallback callback) {
        this.callback = callback;
    }

    void display() {
        parent.background(135, 206, 235); //Blue sky background

        //Draw and update clouds
        for (Cloud cloud : clouds) {
            cloud.update();
            cloud.draw();
        }

        //Draw skyscrapers
        int[] buildingHeights = {220, 300, 200, 350, 270, 310}; //Skyscraper heights
        for (int i = 0; i < buildingHeights.length; i++) {
            int x = 120 * i + 60;
            parent.fill(60); //Buildings' color
            parent.rect(x, parent.height - buildingHeights[i], 60, buildingHeights[i]);
            drawWindows(x, parent.height - buildingHeights[i], 60, buildingHeights[i]);
        }

        //Menu text
        parent.textAlign(parent.CENTER, parent.CENTER);
        parent.textSize(32);
        parent.fill(255);
        int textHeight = parent.height - 390;
        parent.text("Start Game", parent.width / 2 , textHeight);

        //Checks the mouse clicks
        if (parent.mouseX > parent.width / 2 - 100 && parent.mouseX < parent.width / 2 + 100 && parent.mouseY > textHeight - 16 && parent.mouseY < textHeight + 16) {
            if (mouseWasPressed) {
                callback.onGameStart();
                stopMusic();
            }
        }

        mouseWasPressed = parent.mousePressed; //Updates the mouse button state
    }

    void stopMusic() {
        if (menuMusic.isPlaying()) {
            menuMusic.pause();
            menuMusic.rewind();
        }
    }

    void close() {
        menuMusic.close();
        minim.stop();
    }

    //Windows
    void drawWindows(int x, int y, int w, int h) {
        int windowWidth = 10;
        int windowHeight = 6;
        for (int i = 5; i < w - windowWidth; i += windowWidth + 5) {
            for (int j = 10; j < h - windowHeight; j += windowHeight + 10) {
                parent.fill(255, 255, 0);
                parent.rect(x + i, y + j, windowWidth, windowHeight);
            }
        }
    }

    void mousePressed() {
    }
}
