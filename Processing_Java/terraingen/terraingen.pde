import peasy.*;
float zoom = 10;
float[][] terrain;
PeasyCam camera;
PImage img;
int rows = 1024;
int cols = 512;
float zz,xx,yy;
boolean start = false;
boolean stop = false;
float direction=0;

void setup()
{
  fullScreen(P3D);
  import_image();
  camera_setup();
  terrain = convolute(rows, cols, terrain); 
  lightening();
  frameRate(10);
}

void draw()
{
  initialize_orientation();
  background(0);
  if(start)
  {
    movex(-4);
  }
  else{
    movex(0);
  }
  display(xx/zoom,0,xx/zoom+100,cols);
}

void import_image()
{
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
}

void camera_setup()
{
  camera = new PeasyCam(this, rows*zoom/2, cols*zoom/2, 100, 100);
  camera.setMaximumDistance(100000);
  camera.setMinimumDistance(0);
  camera.setSuppressRollRotationMode();
}

void lightening()
{
  noStroke();
  lights();
  //ambientLight(172, 136, 111);
  //directionalLight(50, 50, 50, 0, 0, -10);
}


float[][] convolute(int rows, int cols, float[][] array)
{
  float[][] new_matrix = new float[rows][cols];
  
  for(int i = (0); i < (rows-2); i++)
  {
    for (int j = (0); j < (cols-2); j++)
    {
      new_matrix[i][j] = (array[i][j]+array[i+1][j]+array[i][j+1]+array[i+1][j+1])/(4);
    }
  }
  return new_matrix;
}

void initialize_orientation()
{  
  translate(rows*zoom/2, cols*zoom/2,0);
  //translate(0,0,-1000);
  rotateX(PI/3);
  rotateZ(-PI/2);
  translate(-rows*zoom/2, -cols*zoom/2,0);
  translate(rows*zoom/2,-cols*zoom/2,-zoom*50);
}

void movex(int direction)
{
  translate(xx+direction,0,0);
  if(!((xx > (10000)) || (xx < (-10000))))
  {
    xx = xx - direction;
  }
}
void movey(int direction)
{
  translate(0,yy+direction,0);
  if(!((yy > (10000)) || (yy < (-10000))))
  {
    yy = yy - direction;
  }
}
void movez(int direction)
{
  translate(0,0,zz+(direction));
  if(!((zz > (500)) || (zz < (-500))))
  {
    zz = zz - (direction);
  }
  print(direction);
}

void display (float row1, float col1, float row2, float col2)
{
  for (int y=(int)col1; y< (col2 - 1); y++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int x=(int)row1; x<row2; x++)
    {
      fill(terrain[x][y]);
      vertex(x*zoom, y*zoom*2, map(terrain[x][y], 0, 255, 0, 50)*zoom);
      vertex(x*zoom, (y+1)*zoom*2, map(terrain[x][y+1], 0, 255, 0, 50)*zoom);
    }
    endShape();
  }
}

void procedural_generation()
{
}

void keyPressed()
{
  if (key == '1' || key == '!')
  {
    start = true;
  }
  if (key == '2' || key == '@')
  {
    start = false;
  }
}
