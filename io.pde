

public void openFileImg(int v){
selectInput("Select pixel art image", "openImg");
}

void openImg(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    img = loadImage( selection.getAbsolutePath());
     q  = createGraphics(img.width, img.height, P2D);
    imgPool.setColors(img);
    resizeWindow();
  }
}

void loadPallet(){
selectInput("Select image to load pallet from", "openPallet");
}

void openPallet(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    PImage pallet = loadImage( selection.getAbsolutePath());
    pool.setColors(pallet);
  }
}

  
void saveFileImg() {
  selectOutput("Save image ", "saveImg");
}

void saveImg(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    img.save(selection.getAbsolutePath());
  }
}