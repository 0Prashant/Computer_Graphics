import peasy.*;
float zoom = 10;
float scl = 1.0;
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


  camera = new PeasyCam(this, rows*zoom/2, cols*zoom/2, 100, 100);
  camera.setMaximumDistance(100000);
  camera.setMinimumDistance(0);
  camera.setSuppressRollRotationMode();
  terrain = convolute(rows, cols, terrain);
  scale(20);
   
  noStroke();
  //System.arrayCopy(img.pixels, terrain);
}


void draw()
{
 background(0);
  camera.pan(2,2);
  ambientLight(172, 136, 111);
  directionalLight(50, 50, 50, 0, 0, -10);
  for (int y=0; y< (cols - 1); y++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<rows; x++)
    {
      fill(terrain[x][y]);
      vertex(x*zoom, y*zoom, map(terrain[x][y], 0, 255, 0, 50)*zoom/2);
      vertex(x*zoom, (y+1)*zoom, map(terrain[x][y+1], 0, 255, 0, 50)*zoom/2);
      for(int k=0; k<10; k++)
      {
        //vertex(x*zoom+k, y*zoom+k, (map(terrain[x][y], 0, 255, 0, 50)*zoom/2));
       // vertex(x*zoom+k, (y+1)*zoom+k, (map(terrain[x][y+1], 0, 255, 0, 50)*zoom/2));
        //vertex();
      }
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
      new_matrix[i][j] = (array[i][j]+array[i+1][j]+array[i][j+1]+array[i+1][j+1])/(4);
    }
  }
  return new_matrix;
}
