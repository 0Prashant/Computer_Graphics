import peasy.*;
float zoom = 10;
float scl = 1.0;
float[][] terrain;
int window = 2;
PeasyCam camera;
PImage img; 
int rows = 1024;
int cols = 512;
float zz;
boolean poptrue;

void setup()
{
  fullScreen(P3D);
  img = loadImage("../moon_1low.jpg");
  img.loadPixels();
  terrain = new float[rows][cols];
 
  for (int i=0; i<rows; i++)
  {
    for (int j=0; j< cols; j++)
    {
      color rgb = img.pixels[i*cols+j];
      
      int r = (rgb >> 16) & 0xFF;
      int g = (rgb >> 8) & 0xFF;
      int b = (rgb) & 0xFF;

      terrain[i][j] = (r+g+b)/(3);
      print(terrain[i][j], " ");
    }
  }
  
  camera = new PeasyCam(this, rows*zoom/2, cols*zoom/2, 100, 100);
  camera.setMaximumDistance(100000);
  camera.setMinimumDistance(0);
  camera.setSuppressRollRotationMode();
  terrain = convolute(rows, cols, terrain); 
  noStroke();
  ambientLight(172, 136, 111);
  directionalLight(50, 50, 50, 0, 0, -10);
  
  frameRate(5);
}


void draw()
{
   background(0);
   //if(poptrue)
   //{
   //  popMatrix();
   //  poptrue = false;
   //}
  translate(rows*zoom/2, cols*zoom/2,0);
  //translate(0,0,-1000);
  rotateX(PI/2);
  rotateZ(-PI/2);
  translate(-rows*zoom/2, -cols*zoom/2,0);
  translate(rows*zoom/2,-cols*zoom/2,-zoom*100);
  //translate(0,0,-zoom*100);
  translate(zz,0,0);
  zz = zz-40;
  
  for (int y=0; y< (cols - 1); y++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<rows; x++)
    {
      fill(terrain[x][y]/2);
      vertex(x*zoom, y*zoom*2, map(terrain[x][y], 0, 255, 0, 50)*zoom/2);
      vertex(x*zoom, (y+1)*zoom*2, map(terrain[x][y+1], 0, 255, 0, 50)*zoom/2);
    }
    endShape();
  }
  
}

float[][] convolute(int rows, int cols, float[][] array)
{
  float[][] new_matrix = new float[rows][cols];
  
  for(int i = (0); i < (rows-window); i++)
  {
    for (int j = (0); j < (cols-window); j++)
    {
      new_matrix[i][j] = (array[i][j]+array[i+1][j]+array[i][j+1]+array[i+1][j+1])/(2);
    }
  }
  return new_matrix;
}
