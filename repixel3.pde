import java.awt.Color; //<>// //<>// //<>//
import java.util.Collections;
import controlP5.*;

PImage [] history;
int historyIndex = 0;

ControlP5 cp5;

ColorPicker cp;

PImage img;
PShader highlight, preview;

Pallet imgPool;
Pallet pool;

color background = color(30);

int scl = 2;

color highlightColor = color(255.0);
boolean drawUpdate = true;
boolean drawHighlight = false;
boolean drawPreview = false;

color selectedColor = 0;

void settings() {
  size(60, 60, P2D);
}

PImage imgPallet;

void resizeWindow() {
  surface.setSize(max(530, 198+2+img.width*scl), 55+max(365, img.height*scl));
  //highlight.set("tx", 1.0/(198+2+img.width*scl), 1.0/(55+max(365, img.height*scl)) );
}
void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);
  imgPool = new Pallet();
  pool = new Pallet();

  img = loadImage("sheet.png");
  q  = createGraphics(img.width, img.height, P2D);
  imgPallet = loadImage("pallet.png");

  history = new PImage[10];
  historyIndex = 0;


  pool.addColors(imgPallet);
  imgPool.addColors(img);
  highlight = loadShader("highlight.glsl");
  highlightSet(highlightColor);
  preview = loadShader("preview.glsl");
  // highlight.set("tx", 1.0/(198+2+img.width*scl), 1.0/(55+max(365, img.height*scl)) );
  resizeWindow();
  // noLoop();
  cp5 = new ControlP5(this);

  int i = 6;
  int d = 65;
  int w = 60;
  int y = 2;
  cp5.addButton("saveFileImg")
    .setPosition(i, y)
    .setSize(w, 19);

  cp5.addButton("openFileImg")
    .setPosition(i+=d, y)
    .setSize(w, 19);

  cp5.addButton("loadPallet")
    .setPosition(i+=d, y)
    .setSize(w, 19);

  cp5.addButton("zoomIn")
    .setPosition(i+=d+d, y)
    .setSize(w, 19);

  cp5.addButton("zoomOut")
    .setPosition(i+=d, y)
    .setSize(w, 19);

  cp5.addButton("forcePallet")
    .setPosition(i+=d, y)
    .setSize(w, 19);

  cp5.addButton("palletMap")
    .setPosition(i+=d, y)
    .setSize(w, 19);

  cp5.addSlider("sortType")
    .setPosition(10, y+24)
    .setSize(60, 19)
    .setRange(0, 3)
    .setNumberOfTickMarks(4)
    ;

  cp5.addSlider("posterLevel")
    .setPosition(i-=d*3, y+24)
    .setSize(60, 19)
    .setRange(2, 18)
    .setNumberOfTickMarks(16);
  ;

  cp5.addButton("posterize")
    .setPosition(i+=d, y+24)
    .setSize(w, 19);

  cp5.addToggle("highlight")
    .setPosition(10, y+70)
    .setSize(20, 10);
  ;

  cp5.addToggle("preview")
    .setPosition(60, y+70)
    .setSize(20, 10);
  ;

  cp5.addButton("histogram")
    .setPosition(i+=d, y+24)
    .setSize(w, 19);

  cp5.addButton("undo")
    .setPosition(i+=d, y+24)
    .setSize(w, 19);
}

void histogram() {
  if (win == null) win = new PWindow();

}

void highlight(boolean theFlag) {
  println(theFlag);
  drawHighlight = theFlag;
}

void preview(boolean theFlag) {
  drawPreview = theFlag;
}

public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController().getName());
}
void highlightSet(color c) {
  if ((!imgPool.colors.contains(c)) ) {
    highlightColor =color(255, 0);
  } else highlightColor = c;
  highlight.set("target", red(highlightColor)/255.0, green(highlightColor)/255.0, blue(highlightColor)/255.0, 1.0);
}

void previewSet() {
  preview.set("target", red(selectedColor)/255.0, green(selectedColor)/255.0, blue(selectedColor)/255.0, 1.0);
  loadPixels();
  color c =  pixels[mouseX+mouseY*width];
  preview.set("replacement", red(c)/255.0, green(c)/255.0, blue(c)/255.0, 1.0);
}


int palletsY = 110;

void drawFrame() {

  // println(red(g), green(g), blue(g));
  clear();
  background(background);

  pushMatrix();
  translate(13, palletsY);
  imgPool.drawPallet();
  popMatrix();


  pushMatrix();
  translate(91, palletsY);
  pool.drawPallet();
  popMatrix();

  image(img, 198, 55, img.width*scl, img.height*scl);

  //  if (drawHighlight) 


  /*fill(255);
   text("Tools", 63, 70);
   noFill();
   stroke(255);
   rect(5, 55, 160, 365);
   
   
   fill(255);
   text("Img colors", 10, 100);
   
   
   fill(255);
   text("Pallet colors", 88, 100);*/


  stroke(255);
  noFill();

  rect(196, 55, img.width*scl+2, img.height*scl+2);
}

void draw() {
  drawFrame();
  if (drawHighlight) filter(highlight);
  if (drawPreview) {
    previewSet();
    filter(preview);
  }
}

void selectMousePixel() {
  PVector m = new PVector(mouseX, mouseY);

  PVector imgPoolOffset = new PVector(13, palletsY);
  PVector poolOffset = new PVector(91, palletsY);
  //  if ((!(imgPool.colorFromMouse(m.copy().sub(imgPoolOffset)))) && (!(pool.colorFromMouse(m.copy().sub(poolOffset))))) {
  // }

  // println( imgPool.colorFromMouse(m.copy().sub(imgPoolOffset)) );

  if (!imgPool.colorFromMouse(m.copy().sub(imgPoolOffset))) {
    loadPixels();
    highlightSet( pixels[mouseX+mouseY*width]);
    color c =  pixels[mouseX+mouseY*width];
    if (imgPool.colors.contains(c)) selectedColor = c;
  }

  highlightSet(selectedColor);
}


void mouseDragged() {
  selectMousePixel();
}

void zoomIn() {
  scl++;
  zoom();
}

void zoomOut() {
  scl--;
  zoom();
}

void zoom() {
  scl = constrain(scl, 1, 4);
  resizeWindow();
  // highlight.set("tx", 1.0/(198+2+img.width*scl), 1.0/(55+max(365, img.height*scl)) );
}

void mousePressed() {
  if (mouseButton == LEFT) {

    selectMousePixel();
  }

  if (mouseButton==RIGHT) {
    loadPixels();
    color c =  pixels[mouseX+mouseY*width];
    if ((pool.colors.contains(c)) || (imgPool.colors.contains(c))) {
      replaceColor(selectedColor, c);
      imgPool.setColors(img);
      selectedColor = c;
    }
  }
}


void replaceColor(color o, color n) {
  img.loadPixels();
  for (int i = 0; i < img.width; i++) {
    for (int q = 0; q < img.height; q++) {
      int c = img.pixels[i+q*img.width];  
      if (c == o) img.pixels[i+q*img.width] = n;
    }
  }
  img.updatePixels();
}