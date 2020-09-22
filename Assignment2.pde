Flock flock;
Table xy;
int index = 1;
int floor = 1;
int rectX, rectY, rectLength, rectHeight;
int rectX2, rectY2;
boolean overFloor0, overFloor1;
color currentColor;
color rectHighlight;


void setup() {
  size(1024, 720);
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T15:16:30.254&rToDate=2020-09-22T15:16:30.254&rFamily=people&rSensor=+PC00.05+%28In%29", "csv");
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < xy.getInt(0, 1); i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  
  rectMode(CENTER);
  rectX = 100;
  rectY = height - 100;
  rectX2 = rectX;
  rectY2 = rectY - 100;
  rectLength = 150;
  rectHeight = rectLength/2;
  
  rectHighlight = color(50);
  currentColor = color(0);
}

void draw() {
  update(mouseX, mouseY);
  
  if (floor == 0) {
    background(50);
  }
  else if (floor == 1) {
    background(0);
  }
  
  
  if (overFloor0) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX, rectY, rectLength, rectHeight);
  rect(rectX2, rectY2, rectLength, rectHeight);
  
  fill(255);
  text("Floor 0", rectX - 50, rectY + 10);
  text("Floor 1", rectX2 - 50, rectY2 + 10);
  //text("Floor 1");
  
  flock.run();
  textSize(32);
  text(getPeople(), 10, 30);
  
  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.

  String s = String.valueOf(d);
  text(s, 200, 28);
  s = String.valueOf(m);
  text(s, 200, 56); 
  s = String.valueOf(y);
  text(s, 200, 84);
}

void update(int x, int y) {
  if (overFloor(rectX, rectY, rectLength, rectHeight)){
    overFloor0 = true;
  }
  else 
  {
    overFloor0 = false;
  }
}

void mousePressed() {
  //flock.addBoid(new Boid(mouseX, mouseY));
  if (overFloor0) {
    floor = 0;
  }
  else if (overFloor1) {
    floor = 1;
  }
}

int getPeople() {
  int people = 0;
  for (int r = 0; r < xy.getRowCount(); r++) {
    for (int c = 0; c < xy.getColumnCount(); c++) {
      people += xy.getInt(r, c);
    }
  }
  return people;
}

boolean overFloor (int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height) {
    return true;
  }
  else {
    return false;
  }
}
