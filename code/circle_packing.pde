import gifAnimation.*;

int MARGIN = -5;

class Circle {
  float x;
  float y;
  float r;
  
  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  boolean collides(Circle c) {
    float dist = sq(c.x - x) + sq(c.y - y);
    if (dist <= sq(r + c.r + MARGIN))
      return true;
    return false;
  }
  
  void draw() {
    noStroke();
    colorMode(HSB, 360, 100, 100);
    fill(280 + random(-10, 10), 100 + random(0, -10), 100 + random(0, -10));
    ellipse(x, y, 2*r, 2*r);
  }
};

ArrayList<Circle> circles;
GifMaker gifExport;

void setup() {
  size(500, 500);
  circles = new ArrayList<Circle>();
  current_radius = RADIUS_MAX;
  background(255);
  
  gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0);        // make it an "endless" animation
  //gifExport.setTransparent(255, 255, 255);  // black is transparent
}

boolean isValidCircle(Circle nc) {
  if (dist(nc.x, nc.y, width/2, height/2) > 200)
    return false;
  
  for (Circle c : circles)
    if (nc.collides(c))
      return false;

  return true;
}

float RADIUS_MAX = 16;
float RADIUS_MIN = 2;
float current_radius;
int failed_tries = 0;

void draw() {
  Circle nc = new Circle(random(50, width-50), random(50, height-50), current_radius);
  if (isValidCircle(nc)) {
    nc.draw();
    circles.add(nc);
    gifExport.setDelay(30);
    gifExport.addFrame();
  } else {
    failed_tries++;
    if (failed_tries % 1000 == 0)
      println(failed_tries + " failures so far");
    if (failed_tries > 32 * 1024 / current_radius) {
      current_radius /= 2;
      println("Failed " + failed_tries + " times. New radius: " + current_radius);
      failed_tries = 0;
      if (current_radius < RADIUS_MIN) {
        println("Done!");
        gifExport.setDelay(5000);
        gifExport.addFrame();
        gifExport.finish();  
        noLoop();
      }
    }
  }
}

void keyPressed() { if (key == 's') saveFrame(); }