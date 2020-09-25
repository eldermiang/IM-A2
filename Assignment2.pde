import beads.*;
import org.jaudiolibs.beads.*;

int WIDTH = 1024;
int HEIGHT = 720;
  
Flock flock;
Table xy, xy2, xy3, xy4, xy5, xy6, xy7, xy8, xy9, xy10, xy11, xy12;

int index = 1;
int floor = 0;
int month = 4;
int rectX, rectY, rectLength, rectHeight;
int rectX2, rectY2;
int rectY3, rectX3;
int rectX4 = WIDTH - 66;
int rectX5;
int rectX6;

int backX = rectX4 - 10;
int backY = 42;

boolean overFloor0, overFloor1, overFloor2, overFloor3;
boolean september, august, may, april;
boolean switchTrack;
boolean boringGraphHovered, graphBackHovered;

color currentColor;
color rectHighlight;

PImage groundBG, fishBG;
PImage groundKey, fishKey, airKey;

boolean overSpeaker, muted;
int speakerX, speakerY, speakerLength,speakerHeight;



AudioContext ac = new AudioContext();
AudioContext ac2 = new AudioContext();

int Cloud1 = (int)random(-100, 1300);
int Cloud2 = (int)random(-100, 1300);
int Cloud3 = (int)random(-100, 1300);

BoringGraph boringGraph = null;

void setup() {
  surface.setSize(WIDTH, HEIGHT);
  
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-01T15:16:30.254&rToDate=2020-09-22T15:16:30.254&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F1, September
  xy2 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-01T18:59:33.300&rToDate=2020-09-22T18:59:33.300&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F0, September
  
  xy3 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-01T18%3A59%3A33.300&rToDate=2020-08-31T18%3A59%3A33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F1, August
  xy4 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-01T18%3A59%3A33.300&rToDate=2020-08-31T18%3A59%3A33.300&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F0, August
  
  xy5 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-01T17%3A13%3A46&rToDate=2020-09-22T17%3A13%3A46&rFamily=people&rSensor=+PC02.14+%28In%29", "csv"); //F2, September
  xy6 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-01T17%3A13%3A46&rToDate=2020-08-31T17%3A13%3A46&rFamily=people&rSensor=+PC02.14+%28In%29", "csv"); //F2, August
  
  xy7 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-05-01T17%3A13%3A46&rToDate=2020-05-31T17%3A13%3A46&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F0, May
  xy8 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-05-01T17%3A13%3A46&rToDate=2020-05-31T17%3A13%3A46&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F1, May
  xy9 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-05-01T17%3A13%3A46&rToDate=2020-05-31T17%3A13%3A46&rFamily=people&rSensor=+PC02.14+%28In%29", "csv"); //F2, May
  
  xy10 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-04-01T17%3A13%3A46&rToDate=2020-04-30T17%3A13%3A46&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F0, April
  xy11 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-04-01T17%3A13%3A46&rToDate=2020-04-30T17%3A13%3A46&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F1, April
  xy12 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-04-01T17%3A13%3A46&rToDate=2020-04-30T17%3A13%3A46&rFamily=people&rSensor=+PC02.14+%28In%29", "csv"); //F2, April
  
  flock = new Flock();
  // Add an initial set of boids into the system
  addBoids();
  
  rectX = 65;
  rectY = height - 35;
  
  //rectX2 = rectX + 135;
  rectY2 = rectY - 70;
  
  //rectX3 = rectX2 + 135;
  rectY3 = rectY2 - 70;
  
  //rectX5 = rectX + 135;
  //rectX2 = rectX5 + 135;
  //rectX3 = rectX2 + 135;
  
  rectX6 = rectX + 135;
  rectX5 = rectX6 + 135;
  rectX2 = rectX5 + 135;
  rectX3 = rectX2 + 135;
  
  rectLength = 120;
  rectHeight = rectLength/2;
  
  rectHighlight = color(50);
  currentColor = color(0);
  groundBG = loadImage("Images/Dirt_Background.jpg");
  fishBG = loadImage("Images/Fish_Background.png");
  
  groundKey = loadImage("Images/Ground_Key.png");
  fishKey = loadImage("Images/Fish_Key.png");
  airKey = loadImage("Images/Air_Key.png");
  
  speakerX = 10;
  speakerY = 10;
  speakerLength = 50;
  speakerHeight = 50;

  
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
  else if(overButton(rectX, rectY3, rectLength, rectHeight)){ //Floor 2
    overFloor0 = false;
    overFloor1 = false;
    overFloor2 = true;
  }
  else {
    overFloor0 = overFloor1 = overFloor2 = false;
  }
  
  if (overButton(rectX2, rectY, rectLength, rectHeight)){ //August
    april = false;
    may = false;
    august = true;
    september = false;
  }
  else if (overButton(rectX3, rectY, rectLength, rectHeight)){ //September
    april = false;
    may = false;
    august = false;
    september = true;
  }
  else if (overButton(rectX5, rectY, rectLength, rectHeight)){ //May
    april = false;
    may = true;
    august = false;
    september = false;
  }
  else if (overButton(rectX6, rectY, rectLength, rectHeight)){ //April
    april = true;
    may = false;
    august = false;
    september = false;
  }
  else {
    august = september = may = april = false;
  }
  
  boringGraphHovered = overButton(rectX4, rectY, rectLength, rectHeight);
  graphBackHovered = false;
}

void mousePressed() {
  //flock.addBoid(new Boid(mouseX, mouseY));
  if (overFloor0) {
    floor = 0;
    frameCount = -1; // Resets the sketch
    playSFX();
  }
  else if (overFloor1) {
    floor = 1;
    frameCount = -1; // Resets the sketch
    playSFX();
  }
  else if (overFloor2) {
    floor = 2;
    frameCount = -1;
    playSFX();
  }
  
  if (august) {
    month = 8;
    frameCount = -1;
    playSFX();
  }
  else if (september) {
    month = 9;
    frameCount = -1;
    playSFX();
  }
  else if (may) {
    month = 5;
    frameCount = -1;
    playSFX();
  }
  else if (april) {
    month = 4;
    frameCount = -1;
    playSFX();
  }
  
  if (overButton(speakerX, speakerY, speakerLength, speakerHeight)){
    overSpeaker = !overSpeaker;
  }
  
  if(overSpeaker) {
    ac.stop();
    line(35,13, 35,25);
    line(40,8, 40,30);
    line(45,3, 45,35);
  }
  else {
    ac.start();
  }
  
  if (boringGraphHovered) {
    boringGraph.enabled = true; 
    playSFX();
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
  else if (floor == 2 && month == 8){
    text("People: " + getPeople(xy6), 10, 30);
    text("From: " + getDate("START", xy6), 250, 28);
    text("To: " + getDate("END", xy6), 250, 56); 
  }
  else if (floor == 0 && month == 5){
    text("People: " + getPeople(xy7), 10, 30);
    text("From: " + getDate("START", xy7), 250, 28);
    text("To: " + getDate("END", xy7), 250, 56); 
  }
  else if (floor == 1 && month == 5){
    text("People: " + getPeople(xy8), 10, 30);
    text("From: " + getDate("START", xy8), 250, 28);
    text("To: " + getDate("END", xy8), 250, 56); 
  }
  else if (floor == 2 && month == 5){
    text("People: " + getPeople(xy9), 10, 30);
    text("From: " + getDate("START", xy9), 250, 28);
    text("To: " + getDate("END", xy9), 250, 56); 
  }
  else if (floor == 0 && month == 4){
    text("People: " + getPeople(xy10), 10, 30);
    text("From: " + getDate("START", xy10), 250, 28);
    text("To: " + getDate("END", xy10), 250, 56); 
  }
  else if (floor == 1 && month == 4){
    text("People: " + getPeople(xy11), 10, 30);
    text("From: " + getDate("START", xy11), 250, 28);
    text("To: " + getDate("END", xy11), 250, 56); 
  }
  else if (floor == 2 && month == 4){
    text("People: " + getPeople(xy12), 10, 30);
    text("From: " + getDate("START", xy12), 250, 28);
    text("To: " + getDate("END", xy12), 250, 56); 
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
  
  if (may) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX5, rectY, rectLength, rectHeight); //May
  
  if (april) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX6, rectY, rectLength, rectHeight); //May
  
  if (boringGraphHovered) {
    fill(rectHighlight);
  }
  else {
    fill(currentColor);
  }
  rect(rectX4, rectY, rectLength, rectHeight); //X
  
  drawSpeaker();
  
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Floor 0", rectX, rectY);
  text("Floor 1", rectX, rectY2);
  text("Floor 2", rectX, rectY3);
  
  text("April", rectX6, rectY);
  text("May", rectX5, rectY);
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
  else if (floor == 2 && month == 8) {
    people = getPeople(xy6);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
  else if (floor == 0 && month == 5) {
    people = getPeople(xy7);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
  else if (floor == 1 && month == 5) {
    people = getPeople(xy8);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
  else if (floor == 2 && month == 5) {
    people = getPeople(xy9);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
  else if (floor == 0 && month == 4) {
    people = getPeople(xy10);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
  else if (floor == 1 && month == 4) {
    people = getPeople(xy11);
    for (int i = 0; i < (people/50); i++) {
      flock.addBoid(new Boid(width/2, height/2));
    }
  }
  else if (floor == 2 && month == 4) {
    people = getPeople(xy12);
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
      audioFileName = "./Sounds/BGM/Floor 2.mp3"; //Placeholder
    }
    
    SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(sketchPath(audioFileName)));
    
    player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
    
    Gain g = new Gain(ac, 2, volume);
    g.addInput(player);
    
    Envelope rate = new Envelope(ac, 1);
    player.setRate(rate);
    
    ac.out.addInput(g);
    ac.start();
}

void playSFX() {
    String audioFileName = "./Sounds/SFX/Button_Click.wav";
    float volume = 0.5;
    
    SamplePlayer player = new SamplePlayer(ac2, SampleManager.sample(sketchPath(audioFileName)));
    
    Gain g = new Gain(ac2, 2, volume);
    g.addInput(player);
    
    Envelope rate = new Envelope(ac2, 1);
    player.setRate(rate);
    
    ac2.out.addInput(g);
    ac2.start();
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

void drawSpeaker() {
  fill(0);
  stroke(0);
  rect(15,18,13,15); //Speaker
  triangle(13,17,30,35,30,3);
}

void keyPressed() {
  if (key == TAB) {
    boringGraph.enabled = !boringGraph.enabled;
    playSFX();
  } 
}

void keyReleased() {
  if (!boringGraph.enabled) {
    return;
  }
  
  boringGraph.keyReleased(); 
}
