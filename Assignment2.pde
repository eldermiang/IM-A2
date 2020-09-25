import beads.*;
import org.jaudiolibs.beads.*;

int WIDTH = 1024;
int HEIGHT = 720;
  
Flock flock;
Table xy, xy2, xy3, xy4, xy5, xy6;

int index = 1;
int floor = 0;
int month = 9;
int rectX, rectY, rectLength, rectHeight;
int rectX2, rectY2;
int rectY3, rectX3;
int rectX4 = WIDTH - 66;

int backX = rectX4 - 10;
int backY = 42;

boolean overFloor0, overFloor1, overFloor2, overFloor3;
boolean september, august;
boolean switchTrack;
boolean boringGraphHovered, graphBackHovered;

color currentColor;
color rectHighlight;

PImage groundBG, fishBG;
PImage groundKey, fishKey, airKey;

AudioContext ac = new AudioContext();

int Cloud1 = (int)random(-100, 1300);
int Cloud2 = (int)random(-100, 1300);
int Cloud3 = (int)random(-100, 1300);

BoringGraph boringGraph = null;

void setup() {
  surface.setSize(WIDTH, HEIGHT);
  
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T15:16:30.254&rToDate=2020-09-22T15:16:30.254&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F1, September
  xy2 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T18:59:33.300&rToDate=2020-09-22T18:59:33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F0, September
  
  xy3 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T18%3A59%3A33.300&rToDate=2020-08-22T18%3A59%3A33.300&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F1, August
  xy4 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T18%3A59%3A33.300&rToDate=2020-08-22T18%3A59%3A33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F0, August
  
  xy5 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T17%3A13%3A46&rToDate=2020-09-22T17%3A13%3A46&rFamily=people&rSensor=+PC02.14+%28In%29", "csv"); //F2, September
  
  flock = new Flock();
  // Add an initial set of boids into the system
  addBoids();
  
  rectX = 65;
  rectY = height - 35;
  
  rectX2 = rectX + 135;
  rectY2 = rectY - 70;
  
  rectX3 = rectX2 + 135;
  rectY3 = rectY2 - 70;
  
  
  rectLength = 120;
  rectHeight = rectLength/2;
  
  rectHighlight = color(50);
  currentColor = color(0);
  groundBG = loadImage("Images/Dirt_Background.jpg");
  fishBG = loadImage("Images/Fish_Background.png");
  
  groundKey = loadImage("Images/Ground_Key.png");
  fishKey = loadImage("Images/Ground_Key.png");
  airKey = loadImage("Images/Ground_Key.png");
  
  playBGM();
  
  if (boringGraph == null) {
    boringGraph = new BoringGraph(WIDTH, HEIGHT, floor);
  }
  else if (boringGraph.currentFloor != floor) {
    boringGraph.setFloor(floor);
  }
}

void draw() {
  rectMode(CENTER);
  
  if (boringGraph.enabled) {
    boringGraph.draw();
    graphBackHovered = overButton(backX, backY, rectLength, rectHeight);
    generateGraphBackButton();
    return; 
  }
  
  update(mouseX, mouseY);
  
  if (floor == 0) {
    background(groundBG);
  }
  else if (floor == 1) {
    background(fishBG);
  }
  else if (floor == 2) {
    background(225, 245, 255);
    noStroke();
    generateClouds();
  }
  //else if (floor == 3) {
  //  background;
  //}
  
  
  flock.run();
  

  
  generateUIButtons();
  generateUIText();
  legend();
  
  //text(mouseX, 200, 84);
  //text(mouseY, 200, 112);  
}

void update(int x, int y) {
  if (overButton(rectX, rectY, rectLength, rectHeight)){ //Floor 0
    overFloor0 = true;
    overFloor1 = false;
    overFloor2 = false;
  }
  else if(overButton(rectX, rectY2, rectLength, rectHeight)) //Floor 1
  {
    overFloor0 = false;
    overFloor1 = true;
    overFloor2 = false;
  }
  else if(overButton(rectX, rectY3, rectLength, rectHeight)){
    overFloor0 = false;
    overFloor1 = false;
    overFloor2 = true;
  }
  else {
    overFloor0 = overFloor1 = overFloor2 = false;
  }
  
  if (overButton(rectX2, rectY, rectLength, rectHeight)){ //August
    august = true;
    september = false;
  }
  else if (overButton(rectX3, rectY, rectLength, rectHeight)){ //September
    august = false;
    september = true;
  }
  else {
    august = september = false;
  }
  
  boringGraphHovered = overButton(rectX4, rectY, rectLength, rectHeight);
  graphBackHovered = false;
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
  else if (overFloor2) {
    floor = 2;
    frameCount = -1;
  }
  
  if (august) {
    month = 8;
    frameCount = -1;
  }
  else if (september) {
    month = 9;
    frameCount = -1;
  }
  
  if (boringGraphHovered) {
    boringGraph.enabled = true; 
  }
  if (graphBackHovered) {
    boringGraph.enabled = false; 
  }
}

boolean overButton (int x, int y, int width, int height) {
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
    text("People: " + getPeople(xy), 10, 30);
    text("From: " + getDate("START", xy), 250, 28);
    text("To: " + getDate("END", xy), 250, 56);
  }
  else if (floor == 0 && month == 9){
    text("People: " + getPeople(xy2), 10, 30);
    text("From: " + getDate("START", xy2), 250, 28);
    text("To: " + getDate("END", xy2), 250, 56);
  }
  else if (floor == 1 && month == 8){
    text("People: " + getPeople(xy3), 10, 30);
    text("From: " + getDate("START", xy3), 250, 28);
    text("To: " + getDate("END", xy3), 250, 56);
  }
  else if (floor == 0 && month == 8){
    text("People: " + getPeople(xy4), 10, 30);
    text("From: " + getDate("START", xy4), 250, 28);
    text("To: " + getDate("END", xy4), 250, 56);
  }
  else if (floor == 2 && month == 9){
    text("People: " + getPeople(xy5), 10, 30);
    text("From: " + getDate("START", xy5), 250, 28);
    text("To: " + getDate("END", xy5), 250, 56); 
  }
  
  text("Floor: " + floor, 850, 28);
  text("Month: " + month, 850, 56);
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
  
  if (overFloor2) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  
  rect(rectX, rectY3, rectLength, rectHeight); //Floor 2
  
  
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
  rect(rectX3, rectY, rectLength, rectHeight); //September
  
  if (boringGraphHovered) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX4, rectY, rectLength, rectHeight); //X
  
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Floor 0", rectX, rectY);
  text("Floor 1", rectX, rectY2);
  text("Floor 2", rectX, rectY3);
  
  text("August", rectX2, rectY);
  text("September", rectX3, rectY);
  
  textSize(16);
  text("Boring Graph", rectX4, rectY);
}

void generateGraphBackButton() {
  if (graphBackHovered) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  stroke(255);
  rect(backX, backY, rectLength, rectHeight); 
  noStroke();
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("Back (TAB)", backX, backY);
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
  else if (floor == 2 && month == 9) {
    people = getPeople(xy5);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
}

void playBGM() {
    ac.out.clearInputConnections();
    String audioFileName = "placeholder";
    float volume = 0.5;
    if (floor == 1){
      audioFileName = "./Sounds/BGM/Level Music.mp3";
    }
    else if (floor == 0){
      audioFileName = "./Sounds/BGM/BGM_Menu.mp3";
    }
    else if (floor == 2){
      audioFileName = "./Sounds/BGM/BGM_Menu.mp3"; //Placeholder
      volume = 0;
    }
    
    SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(sketchPath(audioFileName)));
    
    Gain g = new Gain(ac, 2, volume);
    g.addInput(player);
    
    Envelope rate = new Envelope(ac, 1);
    player.setRate(rate);
    
    ac.out.addInput(g);
    ac.start();
}

void generateClouds() {
  ellipseMode(CENTER);
  //clouds
  int ra = int(random(1100, 2000)); //end point reset
  int ra1 = int(random(1, 1.6)); //speed 1
  int ra2 = int(random(1.7, 2.3)); //speed 2
  int ra3 = int(random(1.4, 2.1)); //speed 3
  
  fill(255, 255, 255, 90); //cloud colour
  ellipse(Cloud1, 140, 270, 150);
  Cloud1 = Cloud1 + ra1;
  if (Cloud1 > ra) {
   Cloud1 = 0; 
  }
  ellipse(Cloud1+40, 190, 160, 110);
  Cloud1 = Cloud1 + ra1;
  if (Cloud1 > ra) {
   Cloud1 = 0; 
  }
  ellipse(Cloud2, 310, 160, 100);
  Cloud2 = Cloud2 + ra2;
  if (Cloud3 > ra) {
   Cloud3 = 0; 
  }
  
  ellipse(Cloud2-30, 370, 300, 100);
  Cloud2 = Cloud2 + ra2;
  if (Cloud2 > ra) {
   Cloud2 = 0; 
  }
  ellipse(Cloud3, 560, 330, 120);
  Cloud3 = Cloud3 + ra3;
  if (Cloud3 > ra) {
   Cloud3 = 0; 
  }
  
  ellipse(Cloud3-20, 570, 170, 180);
  Cloud3 = Cloud3 + ra3;
  if (Cloud3 > ra) {
   Cloud3 = 0; 
  }
}

void legend() {
  if (floor == 0) {
  image(groundKey, 820,100);
  }
  
  if (floor == 1) {
  image(fishKey, 820,100);
  }
  
  if (floor == 2) {
  image(airKey, 820,100);
  }
  
}

void keyPressed() {
  if (key == TAB) {
    boringGraph.enabled = !boringGraph.enabled;
  } 
}

void keyReleased() {
  if (!boringGraph.enabled) {
    return;
  }
  
  boringGraph.keyReleased(); 
}
