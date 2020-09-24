Flock flock;
Boid boid;
Table xy, xy2, xy3, xy4;
int index = 1;
int floor = 1;
int month = 9;
int rectX, rectY, rectLength, rectHeight;
int rectX2, rectY2;
boolean overFloor0, overFloor1;
boolean september, august;
color currentColor;
color rectHighlight;
PImage bg;
PImage fishBG;


void setup() {
  size(1024, 720);
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T15:16:30.254&rToDate=2020-09-22T15:16:30.254&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F1, September
  xy2 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T18:59:33.300&rToDate=2020-09-22T18:59:33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F0, September
  
  xy3 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T18%3A59%3A33.300&rToDate=2020-08-22T18%3A59%3A33.300&rFamily=people&rSensor=+PC00.05+%28In%29", "csv"); //F1, August
  xy4 = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T18%3A59%3A33.300&rToDate=2020-08-22T18%3A59%3A33.300&rFamily=people&rSensor=+PC01.11+%28In%29", "csv"); //F0, August
  
  flock = new Flock();
  // Add an initial set of boids into the system
  if (floor == 1 && month == 9){
    for (int i = 0; i < xy.getInt(0, 1); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 0 && month == 9) {
    for (int i = 0; i < xy2.getInt(0, 1); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 1 && month == 8) {
    for (int i = 0; i < xy3.getInt(0, 1); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  else if (floor == 0 && month == 8) {
    for (int i = 0; i < xy4.getInt(0, 1); i++) {
      flock.addBoid(new Boid(width/2,height/2));
    }
  }
  rectMode(CENTER);
  rectX = 100;
  rectY = height - 100;
  rectX2 = rectX + 200;
  rectY2 = rectY - 100;
  rectLength = 175;
  rectHeight = rectLength/2;
  
  rectHighlight = color(50);
  currentColor = color(0);
  
  
  
}

void draw() {
  update(mouseX, mouseY);
  
  if (floor == 0) {
    bg = loadImage("Images/Dirt_Background.jpg");
    background(bg);
    
  }
  else if (floor == 1) {
    fishBG = loadImage("Images/Fish_Background.png");
    background(fishBG);
  }
  
  
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
  
  flock.run();
  textAlign(BASELINE);
  textSize(32);
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
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders(); 
    render();
    
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
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
  PVector seek(PVector target) {
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

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
     
    if (floor == 1) {
    generateFish();
    }
    
     if (floor == 0) {
    generateAnt();
    }
   
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
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
  PVector align (ArrayList<Boid> boids) {
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
  PVector cohesion (ArrayList<Boid> boids) {
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
  
  void generateFish(){
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
   stroke(0);
  }
  
   void generateAnt(){
    fill(0);
    stroke(255);
    ellipse(0, 0, 15, 20); //Lower Body
    ellipse(-0, -10, 10, 20); //Upper Body
    ellipse(0, -20, 10, 15); //Head
    stroke(255);
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
}

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}
