import processing.net.*;
import java.util.*;
import java.time.LocalDate;

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
  
  TreeMap<String, Integer> fetchCounts(LocalDate from, LocalDate to) {
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
  
  void updateCounts() {
    countsPerDay = fetchCounts(from, to);
    days = countsPerDay.keySet().toArray(new String[7]);
  }
  
  void resetTime() {
    from = LocalDate.now();
    from = from.minusDays(from.getDayOfWeek().getValue());
    to = from.plusDays(7); 
  }
  
  void setup() {
    resetTime();
    updateCounts();
  
    for (int i = 0; i < days.length; i++) {
      interpolatedBarHeights[i] = BASE_BAR_HEIGHT;
    }
  }
  
  void draw() {
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
      stroke((interpolatedTotal * 0.0005 *(40.0 * i / (height + 0.0))), 0, 10);
      line(0, i, width, i);
      interpolatedTotal += (total - interpolatedTotal) * 0.000055;
    }
  
    float yScale = 1.0;
    if (maxCount > 480) {
      yScale = 480 / (maxCount + 0.0);
    }
  
    for (int i = 0; i < days.length; i++) {
      fill(255);
      String day = days[i];
      int count = (int) countsPerDay.get(day);
  
      int baseY = BASE_BAR_HEIGHT;
      int baseX = i * (WIDTH / (days.length - 1) - 35) + 70;
      int targetBarHeight =  (int) Math.floor(baseY - (count * yScale));
      interpolatedBarHeights[i] += (targetBarHeight - interpolatedBarHeights[i]) * 0.2;  
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
  
  void keyReleased() {
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
