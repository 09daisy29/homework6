import controlP5.*;

ControlP5 cp5;

int myColor = color(255);

int c1,c2;

float n,n1;


  
String[] imgNames = {"daisy.jpg","daisy2.jpg","daisy3.jpg"};
color backgroundColor = color(255);
float spacing = 3;
float goldenAngle = 137.5;
float minThickness = 1.0;
float maxThickness = 7.0;

int imgIndex = -1;
PImage img;
int num = 0;
int drawStyle = 0;
String tooltip;


// Returns -1 if it's outside the image's dimensions.
int getimage(PVector worldPos) {
  int startX = width/2-img.width/2;
  int valX = (int)worldPos.x-startX;
  if (valX < 0 || valX > img.width-1) {
    return -1;
  }
  
  int startY = height/2-img.height/2;
  int valY = (int)worldPos.y-startY;
  if (valY < 0 || valY > img.height-1) {
    return -1;
  }
  
  return valX + (valY*img.width);
}


void reset() {
  num = 0;
  background(backgroundColor);
}


void nextImage() {
  imgIndex += 1;
  
  if (imgIndex > imgNames.length-1) {
    imgIndex = 0;
  }
  
  reset();
  
  img = loadImage(imgNames[imgIndex]);
  img.loadPixels();
}


void draw_diamond(float centerX, float centerY, float radius, float angleStep) {
  beginShape();
  for (float angle = 0; angle < 360; angle += angleStep) {
    float x = centerX + cos(radians(angle)) * radius;
    float y = centerY + sin(radians(angle)) * radius;
    vertex(x, y);
  }
  endShape();
}


void setup() {
  size(800, 800);
cp5 = new ControlP5(this);
  
  // create a new button with name 'buttonA'
  cp5.addButton("circles")
     .setValue(0)
     .setPosition(0,0)
     .setSize(200,19)
     ;
  
  // and add another 2 buttons
  cp5.addButton("triangles")
     .setValue(100)
     .setPosition(0,20)
     .setSize(200,19)
     ;
     
  cp5.addButton("squares")
     .setPosition(0,40)
     .setSize(200,19)
     .setValue(0);
     
      cp5.addButton("diamonds")
     .setPosition(0,60)
     .setSize(200,19)
     .setValue(0);
  rectMode(CENTER);
  imageMode(CENTER);
  
  frameRate(400);
  
  tooltip = "Press space to  to change image.Right-click to save image\n";
  tooltip += "Use the top left button to select the base shape to construct the image (circles, triangles, squares, diamonds)\n";
  
  nextImage();
}


void draw() {
  float angle = num * goldenAngle;
  float r = spacing * sqrt(num);
  float x = r * cos(radians(angle)) + width/2;
  float y = r * sin(radians(angle)) + height/2;
  
  num += 1;
  
  int pixelIndex = getimage(new PVector(x, y));
  
  if (pixelIndex > -1) {
    color pixelColor = img.pixels[pixelIndex];
    
  
    float pixelBrightness = brightness(pixelColor);
    float thickness = map(pixelBrightness, 0, 255, maxThickness+r*0.01, minThickness);
    
    switch(drawStyle) {
      case 0:
        stroke(pixelColor);
        strokeWeight(thickness);
        point(x, y);
        break;
      case 1:
        noStroke();
        fill(pixelColor);
        triangle(x, y, x+thickness*0.5, y-thickness, x+thickness, y);
        break;
      case 2:
      noStroke();
        fill(pixelColor);
        rect(x, y, thickness, thickness);
        break;
      case 3:
         noStroke();
        fill(pixelColor);
        draw_diamond(x, y, thickness*0.5, 90);
        break;
      
    }
  }
  
  noStroke();
  fill(backgroundColor);
  rect(0, height*2-50, width*2, height*2);
  
  fill(0);
  textAlign(CENTER);
  textSize(10);
  text(tooltip, width/2, height-30);
}


void mousePressed() {
 
   if (mouseButton == RIGHT) {
    saveFrame("Dci-###.png");
  
  }
}
public void circles(int theValue) {
  reset();
  drawStyle = 0;
 
}

// function colorB will receive changes from 
// controller with name colorB
public void triangles(int theValue) {
  reset();
  drawStyle = 1;
}

// function colorC will receive changes from 
// controller with name colorC
public void squares(int theValue) {
   reset();
  drawStyle = 2;
}
public void diamonds(int theValue) {
   reset();
  drawStyle = 3;
}
void keyPressed() {
  if(key==' '){
    
     nextImage();
  
  }
}
