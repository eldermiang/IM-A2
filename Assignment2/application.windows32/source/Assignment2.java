import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import beads.*; 
import org.jaudiolibs.beads.*; 
import processing.net.*; 
import java.util.*; 
import java.time.LocalDate; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Assignment2 extends PApplet {




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

int currentColor;
int rectHighlight;

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

public void setup() {
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
  groundBG = loadImage("data/Images/Dirt_Background.jpg");
  fishBG = loadImage("data/Images/Fish_Background.png");
  
  groundKey = loadImage("data/Images/Ground_Key.png");
  fishKey = loadImage("data/Images/Fish_Key.png");
  airKey = loadImage("data/Images/Air_Key.png");
  
  speakerX = 10;
  speakerY = 60;
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

public void draw() {
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

public void update(int x, int y) {
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

public void mousePressed() {
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
    line(35,63, 35,75);
    line(40,58, 40,80);
    line(45,53, 45,85);
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

public boolean overButton (int x, int y, int width, int height) {
  if (mouseX >= (x - width/2) && mouseX <= (x + width/2) && mouseY >= (y - height / 2) && mouseY <= (y + height/2)) {
    return true;
  }
  else {
    return false;
  }
}

public int getPeople(Table table) {
  int people = 0;
  for (int r = 0; r < table.getRowCount(); r++) {
    for (int c = 0; c < table.getColumnCount(); c++) {
      people += table.getInt(r, c);
    }
  }
  return people;
}

public String getDate(String period, Table table) {
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

public void generateUIText() {
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


public void generateUIButtons() {
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

public void generateGraphBackButton() {
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

public void addBoids(){
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

public void playBGM() {
    ac.out.clearInputConnections();
    String audioFileName = "placeholder";
    float volume = 0.5f;
    if (floor == 1){
      audioFileName = "./data/Sounds/BGM/Level Music.mp3";
    }
    else if (floor == 0){
      audioFileName = "./data/Sounds/BGM/BGM_Menu.mp3";
    }
    else if (floor == 2){
      audioFileName = "./data/Sounds/BGM/Floor 2.mp3"; //Placeholder
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

public void playSFX() {
    String audioFileName = "./data/Sounds/SFX/Button_Click.wav";
    float volume = 0.5f;
    
    SamplePlayer player = new SamplePlayer(ac2, SampleManager.sample(sketchPath(audioFileName)));
    
    Gain g = new Gain(ac2, 2, volume);
    g.addInput(player);
    
    Envelope rate = new Envelope(ac2, 1);
    player.setRate(rate);
    
    ac2.out.addInput(g);
    ac2.start();
}

public void generateClouds() {
  ellipseMode(CENTER);
  //clouds
  int ra = PApplet.parseInt(random(1100, 2000)); //end point reset
  int ra1 = PApplet.parseInt(random(1, 1.6f)); //speed 1
  int ra2 = PApplet.parseInt(random(1.7f, 2.3f)); //speed 2
  int ra3 = PApplet.parseInt(random(1.4f, 2.1f)); //speed 3
  
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

public void legend() {
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

public void drawSpeaker() {
  fill(0);
  stroke(0);
  rect(15,68,13,18); 
  triangle(13,67,30,85,30,53);
}

public void keyPressed() {
  if (key == TAB) {
    boringGraph.enabled = !boringGraph.enabled;
    playSFX();
  } 
}

public void keyReleased() {
  if (!boringGraph.enabled) {
    return;
  }
  
  boringGraph.keyReleased(); 
}
class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 2.0f;
    maxspeed = 2;
    maxforce = 0.03f;
  }

  public void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  public void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  public void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5f);
    ali.mult(1.0f);
    coh.mult(1.0f);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  public void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  public PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  public void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
   
    if (floor == 0) {
      generateAnt();
    }
    else if (floor == 1) {
      generateFish();
    }
    else if (floor == 2) {
      generateBird();
    }
    //else if (floor == 3) {
    
    //}
   
    //beginShape(TRIANGLES);
    //vertex(0, -r*2);
    //vertex(-r, r*2);
    //vertex(r, r*2);
    //endShape();
    
    popMatrix();
  }

  // Wraparound
  public void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  public PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  public PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  public PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  public void generateFish(){
  fill(150);
  stroke(0);
   triangle(0, -r*2, -r, r*2, r, r*2); //Tail Fin
   
   stroke(0);
   ellipse (0, -10, 10, 20);//Body
   ellipse (0, -10, 1, 8);//Dorsal Fin
   stroke(0);
   
   fill(0);
   ellipse (5, -15, 3, 3);//Eyes
   ellipse (-5, -15, 3, 3);
   stroke(255);
  }
  
  public void generateAnt(){
    fill(0);
    stroke(210, 105, 30);
    
    ellipse(0, 0, 15, 20); //Lower Body
    ellipse(-0, -10, 10, 20); //Upper Body
    ellipse(0, -20, 10, 15); //Head
    
    stroke(210, 105, 30);
    
    line(5, -25, 10, -30);  //Antenna Right
    line(-5, -25, -10, -30); //Antenna Left
    line(5, -15, 20, -20); //Upper Leg Right
    line(-5, -15, -20, -20); //Upper Leg Left
    line(5, -5, 20, -5); //Middle Leg Right
    line(-5, -5, -20, -5); //Middle Leg Left
    line(8, 5, 20, 10); //Lower Leg Right
    line(-8, 5, -20, 10); //Lower Leg Left
    
    stroke(255);
    fill(50);
  }
  
  public void generateBird() {
    r = 0.4f;
    fill(100);
    noStroke();
    beginShape();
    
    vertex(50*r, 10*r);
    
    vertex(45*r, 20*r);
    vertex(20*r, 15*r);
    vertex(10*r, 20*r);
    vertex(35*r, 35*r);
    vertex(45*r, 30*r);
    vertex(40*r, 45*r);
    
    vertex(50*r, 50*r);
    
    vertex(60*r, 45*r);
    vertex(55*r, 30*r);
    vertex(65*r, 35*r);
    vertex(90*r, 20*r);
    vertex(80*r, 15*r);
    vertex(55*r, 20*r);
  
    endShape(CLOSE);
    stroke(255);
    fill(50);
    r = 2.0f;
  }
}




class BoringGraph {
  boolean enabled = false;
  
  int WIDTH;
  int HEIGHT;
  
  int BASE_BAR_HEIGHT = 540;
  
  LocalDate from, to;
  TreeMap <String, Integer> countsPerDay;
  String[] days = new String[7];
  float[] interpolatedBarHeights = new float[7];
  float interpolatedTotal = 0;
  
  String[] floorSensors = {"+PC00.05+%28In%29", "+PC01.11+%28In%29", "+PC02.14+%28In%29"};
  int currentFloor = 0;
  
  String error = "";
  
  BoringGraph(int WIDTH, int HEIGHT, int currentFloor) {
    this.WIDTH = WIDTH;
    this.HEIGHT = HEIGHT;
    this.currentFloor = currentFloor;
    setup();
    println("Created graph");
  }
  
  public TreeMap<String, Integer> fetchCounts(LocalDate from, LocalDate to) {
    TreeMap<String, Integer> output = new TreeMap<String, Integer>();
    error = "";
    for (int i = 0; i < 7; i++) {
      output.put(from.plusDays(i).toString(), 0);
    }
    String url = "http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=" + from + "&rToDate=" + to + "&rFamily=people&rSensor=" + floorSensors[currentFloor];
    try {
      Table table = loadTable(url, "csv");
      for (int i = 0; i < table.getRowCount(); i++) {
        String dateStr = table.getString(i, 0).split(" ")[0];
        if (!output.containsKey(dateStr)) continue;
        int count = table.getInt(i, 1);
        count += output.get(dateStr);
  
        output.put(dateStr, count);
      }
    }
    catch (Exception e) {
      error = "Failed to fetch data for the provided range.";
      println(e); 
    }
    return output;
  }
  
  public void updateCounts() {
    countsPerDay = fetchCounts(from, to);
    days = countsPerDay.keySet().toArray(new String[7]);
  }
  
  public void resetTime() {
    from = LocalDate.now();
    from = from.minusDays(from.getDayOfWeek().getValue());
    to = from.plusDays(7); 
  }
  
  public void setup() {
    resetTime();
    updateCounts();
  
    for (int i = 0; i < days.length; i++) {
      interpolatedBarHeights[i] = BASE_BAR_HEIGHT;
    }
  }
  
  public void setFloor(int floor) {
    this.currentFloor = floor;
    updateCounts();
  }
  
  public void draw() {
    background(0);
  
    int total = 0;
    int maxCount = 0;
    for (int i = 0; i < days.length; i++) {
      String day = days[i];
      int count = (int) countsPerDay.get(day);
      total += count;
      if (count > maxCount) {
        maxCount = count;
      }
    }
  
    for (int i = 0; i < height; i++) {
      stroke((interpolatedTotal * 0.0005f *(40.0f * i / (height + 0.0f))), 0, 10);
      line(0, i, width, i);
      interpolatedTotal += (total - interpolatedTotal) * 0.000055f;
    }
  
    float yScale = 1.0f;
    if (maxCount > 480) {
      yScale = 480 / (maxCount + 0.0f);
    }
  
    for (int i = 0; i < days.length; i++) {
      fill(255);
      String day = days[i];
      int count = (int) countsPerDay.get(day);
  
      int baseY = BASE_BAR_HEIGHT;
      int baseX = i * (WIDTH / (days.length - 1) - 35) + 70;
      int targetBarHeight =  (int) Math.floor(baseY - (count * yScale));
      interpolatedBarHeights[i] += (targetBarHeight - interpolatedBarHeights[i]) * 0.2f;  
      int barHeight = (int) Math.floor(interpolatedBarHeights[i]);
      int barWidth = 40;
      rectMode(CORNERS);
      rect(baseX, barHeight, baseX + barWidth, baseY);
  
      textAlign(CENTER, CENTER);
      textSize(16);
      String dayOfWeek = LocalDate.parse(day).getDayOfWeek().toString();
      text(dayOfWeek + "\n" + day, baseX + barWidth / 2, 580); 
  
      fill(0);
      textSize(count < 1000 ? 12 : 10);
      text(count, baseX + barWidth / 2, barHeight + 10);
    }
  
    fill(255);
    textSize(32);
    textAlign(LEFT, TOP);
  
    String headerStr = "Floor " + currentFloor + ": " + from + " - " + from.plusDays(6);
    text(headerStr, 10, 10);
    
    if (!error.isEmpty()) {
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      text(error, WIDTH / 2, HEIGHT / 2);
    }
    
    fill(255);
    textSize(16);
    textAlign(LEFT, BOTTOM);
    text("Total people counted this week: " + total, 10, HEIGHT - 10);
    textAlign(RIGHT, BOTTOM);
    text("LEFT/RIGHT: Shift by 1 week\nUP/DOWN: Shift by 4 weeks\nSPACE: Reset", WIDTH - 10, HEIGHT - 10);
    rectMode(CENTER);
  }
  
  public void keyReleased() {
    if (key == ' ') {
      resetTime();
      updateCounts();
      return;
    }
    
    if (key != CODED) return;
  
    switch (keyCode) {
      case LEFT:
        from = from.minusDays(7);
        to = to.minusDays(7);
        break;
      case RIGHT:
        from = from.plusDays(7);
        to = to.plusDays(7);
        break;
      case UP:
        from = from.plusDays(7 * 4);
        to = to.plusDays(7 * 4);
        break;
      case DOWN:
        from = from.minusDays(7 * 4);
        to = to.minusDays(7 * 4);
        break;
      default:
        return;
    }
    updateCounts();
  }
}
class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  public void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  public void addBoid(Boid b) {
    boids.add(b);
  }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Assignment2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
