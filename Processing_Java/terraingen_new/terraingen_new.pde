import peasy.*;

float scl = 3.0;
float[][] terrain;
int window = 2;
PeasyCam camera;
PImage img; 
int rows = 512;
int cols = 256;

void setup()
{
  fullScreen(P3D);
  
  img = loadImage("../rsz_moon_low.jpg");
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

      terrain[i][j] = (r+g+b)/(3*scl);
      print(terrain[i][j], " ");
    }
  }


  camera = new PeasyCam(this, 64, 32, 100, 100);
  camera.setMaximumDistance(1000);
  camera.setSuppressRollRotationMode();
  terrain = convolute(rows, cols, terrain);
  //System.arrayCopy(img.pixels, terrain);
}


void draw()
{
  background(0);
  stroke(100);
  //image(img, 0, 0);  
  
  translate(64, 32);
  rotateX(PI/3);
  translate(-64, -32);
  
  for (int y=0; y< (cols - 1); y++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<rows; x++)
    {
      fill(terrain[x][y]*scl);
      vertex(x, y, map(terrain[x][y], 0, 255, 0, 50));
      vertex(x, y+1, map(terrain[x][y+1], 0, 255, 0, 50));
    }
    endShape();
  }
  
}

int[][] ones(int rows, int cols)
{
  int[][] new_matrix = new int[rows][cols];
  
  for(int i = 0; i < rows; i++)
  {
    for (int j = 0; j < cols; j++)
    {
      new_matrix[i][j] = 1;
    }
  }
  return new_matrix;
}

float[][] convolute(int rows, int cols, float[][] array)
{
  float[][] new_matrix = new float[rows][cols];
  
  for(int i = (0); i < (rows-window); i++)
  {
    for (int j = (0); j < (cols-window); j++)
    {
      new_matrix[i][j] = (array[i][j]+array[i+1][j]+array[i][j+1]+array[i+1][j+1])/(3);
    }
  }
  return new_matrix;
}
