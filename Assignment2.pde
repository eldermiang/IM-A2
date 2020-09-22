Flock flock;
Table xy, xy2;
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
  xy2 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T18:59:33.300&rToDate=2020-09-22T18:59:33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv");
  flock = new Flock();
  // Add an initial set of boids into the system
  if (floor == 1){
    for (int i = 0; i < xy.getInt(0, 1); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 0) {
    for (int i = 0; i < xy2.getInt(0, 1); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
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
  
  if (overFloor1) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  
  rect(rectX2, rectY2, rectLength, rectHeight);
  
  fill(255);
  textAlign(CENTER, CENTER);
  text("Floor 0", rectX, rectY);
  text("Floor 1", rectX2, rectY2);
  
  flock.run();
  textAlign(BASELINE);
  textSize(32);
  if (floor == 1){
    text(getPeople(xy), 10, 30);
    text(getDate("START", xy), 200, 28);
    text(getDate("END", xy), 200, 56);
  }
  else if (floor == 0){
    text(getPeople(xy2), 10, 30);
    text(getDate("START", xy2), 200, 28);
    text(getDate("END", xy2), 200, 56);
  }
  
  //int d = day();    // Values from 1 - 31
  //int m = month();  // Values from 1 - 12
  //int y = year();   // 2003, 2004, 2005, etc.

  //String s = String.valueOf(d);
  //text(s, 200, 28);
  //s = String.valueOf(m);
  //text(s, 200, 56); 
  //s = String.valueOf(y);
  //text(s, 200, 84);
  
  //text(mouseX, 200, 84);
  //text(mouseY, 200, 112);
}

void update(int x, int y) {
  if (overFloor(rectX, rectY, rectLength, rectHeight)){
    overFloor0 = true;
    overFloor1 = false;
  }
  else if(overFloor(rectX2, rectY2, rectLength, rectHeight))
  {
    overFloor0 = false;
    overFloor1 = true;
  }
  else {
    overFloor0 = overFloor1 = false;
  }
}

void mousePressed() {
  //flock.addBoid(new Boid(mouseX, mouseY));
  if (overFloor0) {
    floor = 0;
    frameCount = -1; // Resets the sketch
  }
  else if (overFloor1) {
    floor = 1;
    frameCount = -1; // Resets the sketch
  }
}

boolean overFloor (int x, int y, int width, int height) {
  if (mouseX >= (x - width/2) && mouseX <= (x + width/2) && mouseY >= (y - height / 2) && mouseY <= (y + height/2)) {
    return true;
  }
  else {
    return false;
  }
}

int getPeople(Table table) {
  int people = 0;
  for (int r = 0; r < table.getRowCount(); r++) {
    for (int c = 0; c < table.getColumnCount(); c++) {
      people += table.getInt(r, c);
    }
  }
  return people;
}

String getDate(String period, Table table) {
  String date;
  
  if (period.toLowerCase().equals("start")){
    date = table.getString(0, 0);
  }
  else if (period.toLowerCase().equals("end")){
    date = table.getString(table.getRowCount() - 1, 0);
  }
  else {
    date = "Unknown";
  }
  return date;
}
