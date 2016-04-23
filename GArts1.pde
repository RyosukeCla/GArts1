import processing.opengl.*;
GUI ui;

boolean isUI;
void setup() {
  size(1366, 568, OPENGL);
  blendMode(ADD);
  stroke(57, 255, 174, 80);
  strokeWeight(2);
  ui = new GUI();
  ui.addBar("R", "G", "B", "A");
  ui.getBar("R").setPosition(10, 50);
  ui.getBar("R").setRange(0, 255);
  ui.getBar("R").setInitialValue(100);
  ui.getBar("G").setPosition(10, 100);
  ui.getBar("G").setRange(0, 255);
  ui.getBar("G").setInitialValue(255);
  ui.getBar("B").setPosition(10, 150);
  ui.getBar("B").setRange(0, 255);
  ui.getBar("B").setInitialValue(150);
  ui.getBar("A").setPosition(10, 200);
  ui.getBar("A").setRange(0, 255);
  ui.getBar("A").setInitialValue(170);

  ui.addBar("theta");
  ui.getBar("theta").setPosition(10, 250);
  ui.getBar("theta").setRange(0, 4);
  ui.getBar("theta").setInitialValue(2);
  ui.getBar("theta").isInteger(true);
  isUI = true;
}

void draw() {
  background(0, 0, 40);
  strokeWeight(2);
  stroke(ui.getBar("R").getValue(), ui.getBar("G").getValue(), ui.getBar("B").getValue(), ui.getBar("A").getValue());
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(ui.getBar("theta").getValue()*90));
  ga(5, 10, 100, 2000.0*mouseY/height, 15*mouseX/width);
  popMatrix();
  if (isUI == true) {
    ui.update();
  } else {
    saveFrame("frame/#####.png");
    isUI = true;
  }
}


void mousePressed() {
  ui.mouseListener();
}

void keyReleased() {
  if (key == 's') {
    isUI = false;
  }
}

void ga(int a, int b, float st, float l1, int l2) {
  float x, y;
  for (int i = 1; i <= b; i++) {
    for (int j = 0; j < a * 360; j++) {
      x = (st + radians(i*l1)*sin(radians((float)j/a*l2))) * cos(radians((float)j/a));
      y = (st + radians(i*l1)*sin(radians((float)j/a*l2))) * sin(radians((float)j/a));
      point(x, y);
    }
  }
}

class GUI {
  ArrayList<Bar> bars;
  GUI() {
    bars = new ArrayList<Bar>();
  }
  void addBar(String... name) {
    for (int i = 0; i < name.length; i++) {
      bars.add(new Bar(0, 0));
      bars.get(bars.size() - 1).setTitle(name[i]);
    }
  }
  Bar getBar(String name) {
    for (int i = 0; i < bars.size(); i++) {
      if (bars.get(i).name.equals(name)) {
        return bars.get(i);
      }
    }
    return null;
  }
  void update() {
    for (int i = 0; i < bars.size(); i++) {
      bars.get(i).update();
    }
  }
  void mouseListener() {
    for (int i = 0; i < bars.size(); i++) {
      bars.get(i).mouseListener();
    }
  }
}

class Bar {
  float x, y;
  float ra, rb;
  boolean canChange;
  float mx;
  String name;
  boolean isInt;
  Bar(float x, float y) {
    this.x = x;
    this.y = y;
    ra = 0;
    rb = 1;
    canChange = false;
    mx = 60;
    name = "none";
    isInt = false;
  }
  void setPosition(float xp, float yp) {
    this.x = xp;
    this.y = yp;
  }
  void setRange(float a, float b) {
    ra = a;
    rb = b;
  }
  void setTitle(String str) {
    name = str;
  }
  void setInitialValue(float xx) {
    mx = 60.0 * (xx - ra) / (rb- ra);
  }
  void isInteger(boolean isI) {
    isInt = isI;
  }
  void update() {
    if (mouseX >= x - 5 && mouseX <= x + 65 && mouseY >= y && mouseY <= y + 16) {
      canChange = true;
    } else {
      canChange = false;
    }
    pushMatrix();
    stroke(255, 255, 255, 255);
    strokeWeight(1);
    fill(255, 255, 255, 100);
    translate(x, y);
    line(0, 0, 0, 16);
    line(0, 8, 60, 8);
    line(60, 0, 60, 16);
    text(name, 64, 8);
    text((int)ra, 0, -4);
    text((int)rb, 60, -4);
    text(getValue(), mx - 2.5, 26);
    rect(mx - 2.5, 0, 5, 16);
    popMatrix();
  }
  float getValue() {
    return ra + (rb - ra) * mx/60.0;
  }
  void mouseListener() {
    if (canChange == true) {
      mx = mouseX - x;
      if (isInt == true) {
        setInitialValue((int)getValue());
      }
      if (mx > 60) {
        mx = 60;
      }
      if (mx < 0) {
        mx = 0;
      }
    }
  }
}