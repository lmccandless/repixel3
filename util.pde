
boolean pointInBox(int locx, int locy, int boxx, int boxy, int w, int h) {
  if ((locx > boxx) &&
    (locy > boxy) &&
    (locx < boxx+w) &&
    (locy < boxy+h)) return true;
  return false;
}

boolean mouseInBox(int boxx, int boxy, int w, int h) {
  return pointInBox(mouseX, mouseY, boxx, boxy, w, h);
}

boolean pointInBox(PVector loc, PVector boxLoc, PVector boxSize) {
  if ((loc.x > boxLoc.x) &&
    (loc.y > boxLoc.y) &&
    (loc.x < boxLoc.x+boxSize.x) &&
    (loc.y < boxLoc.y+boxSize.y)) return true;
  return false;
}

PGraphics q; 
int posterLevel = 2;
void posterize() {
  q.beginDraw();
  q.clear();
  q.image(img, 0, 0);
  q.filter(POSTERIZE, posterLevel);
  q.endDraw();
  img = q.get();
  imgPool = new Pallet();
  imgPool.setColors(img);
}