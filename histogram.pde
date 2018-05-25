PWindow win;



class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {"Histogram"}, this);
    surface.setTitle("Histogram");
  }

  void settings() {
    size(200, 400,P2D);
  }

  void setup() {
    background(50);
  }

  void draw() {
    //ellipse(random(width), random(height), random(50), random(50));
    clear();
    Pallet p = imgPool;
    float lastAng = 0;
    for (int i = 0; i< p.colors.size(); i++) {
      float ang = 2*PI*float(p.histogram.get(i))/p.totPx;
      //float ang = histogram.get(i);
      fill(p.colors.get(i));
      noStroke();
      // println(ang);
      arc(100, 100, 200, 200, lastAng, lastAng+ang, PIE);
      lastAng += ang;
    }


    float highest = 0;
    for (int i = 0; i < p.histogram.size();i++){
      if (p.histogram.get(i)>highest){
        highest = p.histogram.get(i);
      }
    }
    println(highest);
    float w = 200/p.colors.size();
    //println(w);
    for (int i = 0; i < p.colors.size(); i++) {
      noStroke();
      fill(p.colors.get(i));
      //stroke(255);
      float h = map(p.histogram.get(i),0, highest, 0, 200);
      rect(i*w, 400, w,-h);//w, p.histogram.get(i)*10);
    }
    
    if (drawHighlight)filter(highlight);
  }

  void mousePressed() {
    //println("mousePressed in secondary window");
  }

  void exit()
  {
    dispose();
    win = null;
  }
}