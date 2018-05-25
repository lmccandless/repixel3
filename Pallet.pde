void forcePallet() {
  //ArrayList<Integer> newc = new ArrayList<Integer>();
  //float ratio = pool.colors.size()/imgPool.colors.size();
  for (int i = 0; i < imgPool.colors.size(); i++) {
    //  newc.add(r.colors.get(floor(i*ratio)));
    color old = imgPool.colors.get(i);
    // color newc = pool.colors.get(floor(map(i, 0, imgPool.colors.size(), 0, pool.colors.size())));
    color newc = findClosest(old, pool.colors);//
    replaceColor(old, newc);
  }
  imgPool.colors = new ArrayList<Integer>();
  imgPool.setColors(img);
  updatePixels();
}

void palletMap() {
  //ArrayList<Integer> newc = new ArrayList<Integer>();
  //float ratio = pool.colors.size()/imgPool.colors.size();
  for (int i = 0; i < imgPool.colors.size(); i++) {
    //  newc.add(r.colors.get(floor(i*ratio)));
    color old = imgPool.colors.get(i);
    color newc = pool.colors.get(floor(map(i, 0, imgPool.colors.size(), 0, pool.colors.size())));
    //color newc = findClosest(old, pool.colors);//
    replaceColor(old, newc);
  }
  imgPool.colors = new ArrayList<Integer>();
  imgPool.setColors(img);
  updatePixels();
}

int hsvSort = 0;
void sortType(float in) {
  hsvSort = int(in);
  imgPool = new Pallet();
  imgPool.setColors(img);

  // pool = new Pallet();
  //pool.setColors(imgPallet);
}


color findClosest(color c, ArrayList<Integer> colors) {
  float lowestDif = 100000000;
  color newc = c;
  for (int i = 0; i < colors.size(); i++) {
    color n = colors.get(i);
    /* float dif = abs(red(c)-red(n)) + 
     abs(green(c)-green(n)) +
     abs(blue(c)-blue(n));*/

    float dif = pow(red(c)-red(n), 4) + 
      pow(green(c)-green(n), 4) +
      pow(blue(c)-blue(n), 4);



    if (lowestDif > dif) {
      lowestDif = dif;
      newc = n;
    }
  }
  return newc;
}

class CColor implements Comparable<CColor> {
  color c;
  float sum;
  CColor(color n) {
    c = n;
    sum = red(c)+green(c)+blue(c);
  }
  public int compareTo(CColor oc) {
    color n = oc.c;
    float nsum = red(n)+green(n)+blue(n);
    /*(red(c)-red(n)) + 
     (green(c)-green(n)) +
     (blue(c)-blue(n));*/
    if (sum<nsum) return 1;
    if (sum>nsum) return -1;
    return 0;
  }
}

class Pallet {
  ArrayList<Integer> colors;
  ArrayList<Integer> histogram;
  int totPx=0;
  int cols = 4;
  int cellSize = 14;
  Pallet() {
    colors = new ArrayList<Integer>();
    histogram = new ArrayList<Integer>();
  }

  void addColor(color c) {
    totPx++;
    if (!colors.contains(c)) {
      colors.add(c);
      Integer z = 1;
      histogram.add(z);
    } else {
      Integer k = histogram.get(colors.indexOf(c));
      k++;
      histogram.set(colors.indexOf(c), k);
    }
  }
  
  
  
  void addColors(PImage src) {
    src.loadPixels();
    for (int i = 0; i < src.width; i++) {
      for (int q = 0; q < src.height; q++) {
        addColor(src.pixels[i+q*src.width]);
      }
    }
  }

  float colHue(color c) {
    float[] hsb = Color.RGBtoHSB((int)red(c), (int)green(c), (int)blue(c), null);
    return hsb[hsvSort];
  }

  void sortColors() {
    if (hsvSort==3) return;
    //println("sorting by " + hsvSort);
    int n = colors.size();
    int temp = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 1; j < (n - i); j++) {
        color jc = colors.get(j-1);
        if (colHue(jc) > colHue(colors.get(j))) {
          temp = jc;
          colors.set(j-1, colors.get(j));
          colors.set(j, temp);
        }
      }
    }
    redoHistogram();
  }

  void redoHistogram(){
    
  }

  boolean colorFromMouse(PVector loc) {
    int h = ceil(colors.size()/cols);
    if ((loc.x >0) && (loc.y > 0) && ( loc.x < cols*cellSize) && ( loc.y < h*cellSize)) {
      int cell = -1;
      int x = floor(loc.x/cellSize);//(int)(loc.x % (cellSize*w));
      int y = floor(loc.y /cellSize);
      cell = x+y*cols;
      selectedColor = colors.get(cell);
      return true;
    } else return false;
  }

  void setColors(PImage src) {
    colors = new ArrayList<Integer>();
    histogram  = new ArrayList<Integer>();
    totPx = 0;
    addColors(src);
    sortColors();
  }

  void drawPallet() {
    int h = ceil(colors.size()/cols);
    int i = 0;
    //stroke(75);
    noStroke();
    int bx=-1, by=-1;
    // for (Integer c : colors) {
    for (int q = 0; q < colors.size(); q++) {
      color c = colors.get(q);
      int x = i%cols;
      int y = ceil((float)i)/cols;
      fill(c);
      rect(x*cellSize, y*cellSize, cellSize, cellSize);
      if (selectedColor == c) {
        bx = x; 
        by = y;

        //stroke();
      }
      i++;
    }
    if (bx != -1) {
      stroke(((frameCount/20)%2)*255);
      noFill();
      rect(bx*14, by*14, 14, 14);
      noStroke();
    }
  }
}