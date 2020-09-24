import beads.*;
import org.jaudiolibs.beads.*;

Flock flock;
Table xy, xy2, xy3, xy4;

int index = 1;
int floor = 0;
int month = 9;
int rectX, rectY, rectLength, rectHeight;
int rectX2, rectY2;

boolean overFloor0, overFloor1;
boolean september, august;
boolean switchTrack;

color currentColor;
color rectHighlight;

PImage groundBG, fishBG;

AudioContext ac = new AudioContext();

void setup() {
  size(1024, 720);
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T15:16:30.254&rToDate=2020-09-22T15:16:30.254&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F1, September
  xy2 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T18:59:33.300&rToDate=2020-09-22T18:59:33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F0, September
  xy3 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T18%3A59%3A33.300&rToDate=2020-08-22T18%3A59%3A33.300&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F1, August
  xy4 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T18%3A59%3A33.300&rToDate=2020-08-22T18%3A59%3A33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F0, August
  
  //ac = new AudioContext();
  
  flock = new Flock();
  // Add an initial set of boids into the system
  addBoids();
  
  rectMode(CENTER);
  rectX = 100;
  rectY = height - 100;
  rectX2 = rectX + 200;
  rectY2 = rectY - 100;
  rectLength = 175;
  rectHeight = rectLength/2;
  
  rectHighlight = color(50);
  currentColor = color(0);
  groundBG = loadImage("Images/Dirt_Background.jpg");
  fishBG = loadImage("Images/Fish_Background.png");
  
  playBGM();
}

void draw() {
  update(mouseX, mouseY);
  
  if (floor == 0) {
    background(groundBG);
  }
  else if (floor == 1) {
    background(fishBG);
  }
  //else if (floor == 2) {
  //  background();
  //}
  //else if (floor == 3) {
  //  background;
  //}
  
  
  flock.run();
  generateUIButtons();
  generateUIText();
  
  //text(mouseX, 200, 84);
  //text(mouseY, 200, 112);
}

void update(int x, int y) {
  if (overFloor(rectX, rectY, rectLength, rectHeight)){
    overFloor0 = true;
    overFloor1 = false;
  }
  else if(overFloor(rectX, rectY2, rectLength, rectHeight))
  {
    overFloor0 = false;
    overFloor1 = true;
  }
  else {
    overFloor0 = overFloor1 = false;
  }
  
  if (overFloor(rectX2, rectY, rectLength, rectHeight)){
    august = true;
    september = false;
  }
  else if (overFloor(rectX2, rectY2, rectLength, rectHeight)){
    august = false;
    september = true;
  }
  else {
    august = september = false;
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
  
  if (august) {
    month = 8;
    frameCount = -1;
  }
  else if (september) {
    month = 9;
    frameCount = -1;
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

void generateUIText() {
  textAlign(BASELINE);
  textSize(32);
  fill(50);
  if (floor == 1 && month == 9){
    text(getPeople(xy), 10, 30);
    text(getDate("START", xy), 200, 28);
    text(getDate("END", xy), 200, 56);
  }
  else if (floor == 0 && month == 9){
    text(getPeople(xy2), 10, 30);
    text(getDate("START", xy2), 200, 28);
    text(getDate("END", xy2), 200, 56);
  }
  else if (floor == 1 && month == 8){
    text(getPeople(xy3), 10, 30);
    text(getDate("START", xy3), 200, 28);
    text(getDate("END", xy3), 200, 56);
  }
  else if (floor == 0 && month == 8){
    text(getPeople(xy4), 10, 30);
    text(getDate("START", xy4), 200, 28);
    text(getDate("END", xy4), 200, 56);
  }
  
  text("Floor: " + floor + " Month: " + month, 600, 28);
}

void generateUIButtons() {
  if (overFloor0) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  
  rect(rectX, rectY, rectLength, rectHeight); //Floor 0
  
  if (overFloor1) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  
  rect(rectX, rectY2, rectLength, rectHeight); //Floor 1
  
  if (august) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX2, rectY, rectLength, rectHeight); //August
  
  if (september) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX2, rectY2, rectLength, rectHeight); //September
  
  
  fill(255);
  textAlign(CENTER, CENTER);
  text("Floor 0", rectX, rectY);
  text("Floor 1", rectX, rectY2);
  
  text("August", rectX2, rectY);
  text("September", rectX2, rectY2);
}

void addBoids(){
  int people = 0;
  
  if (floor == 1 && month == 9){
    people = getPeople(xy);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 0 && month == 9) {
    people = getPeople(xy2);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 1 && month == 8) {
    people = getPeople(xy3);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 0 && month == 8) {
    people = getPeople(xy4);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
}

void playBGM() {
    //Note: Only the full file path seems to run with this method, please make sure to change the file path
    ac.out.clearInputConnections();
    String audioFileName = "placeholder";
    
    if (floor == 1){
      audioFileName = "/Users/jacks/OneDrive/Documents/Processing/Assignment2/Sounds/BGM/Level Music.mp3";
    }
    else if (floor == 0){
      audioFileName = "/Users/jacks/OneDrive/Documents/Processing/Assignment2/Sounds/BGM/BGM_Menu.mp3";
    }
    
    SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
    
    Envelope rate = new Envelope(ac, 1);
    player.setRate(rate);
    
    ac.out.addInput(player);
    ac.start();
}
