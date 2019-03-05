import peasy.*;
float zoom = 10;
float[][] terrain;
PeasyCam camera;
PImage img;
PImage tex;
int rows = 1024;
int cols = 512;
float zz,xx,yy;
boolean start = true;
boolean stop = false;
float direction=0;
int fardistance = 250;

void setup()
{
  fullScreen(P3D);
  import_image();
  camera_setup();
  terrain = convolute(rows, cols, terrain); 
  lightening();
  frameRate(60);
  textureMode(IMAGE);
}

void draw()
{
  initialize_orientation();
  background(0);
  translate(-200,0,0);
  procedural_generation();
}

void import_image()
{
  img = loadImage("../moon_1low.jpg");
  tex = loadImage("red.jpg");
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
  //lights();
  ambientLight(172, 136, 111);
  directionalLight(50, 50, 50, 0, 0, -10);
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
  rotateX(PI/2.5);
  rotateZ(-PI/2);
  rotateZ(map(mouseX, 0, width, -PI, PI));
  translate(-rows*zoom/2, -cols*zoom/2,0);
  translate(rows*zoom/2,-cols*zoom/2,-zoom*30);
}

void movex(int direction)
{
  if(!((xx > ((1024-fardistance-3)*zoom)) || (xx < (0))))
  {
    xx = xx + direction;
    translate(-xx,0,0);
  }
}
void movey(int direction)
{
  if(!((yy > ((512-fardistance-3)*zoom)) || (yy < (0))))
  {
    yy = yy + direction;
    translate(0,yy,0);
  }
}
void movez(int direction)
{
  if(!((zz > (500)) || (zz < (-50))))
  {
    zz = zz + (direction);
    translate(0,0,zz);
  }
  print(direction);
}

void display (float row1, float col1, float row2, float col2)
{
 // textureWrap(CLAMP);
  texture(tex);
  for (int y=(int)col1; y< (col2 - 1); y++)
  {
    beginShape(QUAD_STRIP);
    for (int x=(int)row1; x<row2; x++)
    {    
      //fill(terrain[x][y]);
      vertex(x*zoom, y*zoom*2, map(terrain[x][y], 0, 255, 0, 50)*zoom,50,50);
      vertex(x*zoom, (y+1)*zoom*2, map(terrain[x][y+1], 0, 255, 0, 50)*zoom,60,60);
    }
    endShape();
  }
}

void procedural_generation()
{
  if(start)
    movex(5);
  else
    movex(-5);
  display(xx/zoom,0,xx/zoom+fardistance,cols);

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
