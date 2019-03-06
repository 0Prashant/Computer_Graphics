import peasy.*;
int zoom = 9;
float[][] terrain;
float [][] noise;
PeasyCam camera;
PImage img;
PImage tex;
int rows = 1024;
int cols = 512;
float zz,xx,yy;
boolean start = false;
boolean gofront, goback, goright, goleft; 
float camera_direction=0;
int camera_angle = 100;
int fardistance = 200;
int speed = 7;
float depth= 3;

void setup()
{
  fullScreen(P3D);
  import_image();
  camera_setup();
  terrain = convolute(rows, cols, terrain); 
  noise_setup();
  lightening();
  frameRate(30);
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
  tex = loadImage("../texture.jpg");
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

void noise_setup()
{
  noise = new float[zoom][zoom];
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

void movex(float direction)
{
  xx = xx + direction;
  if(!((xx > ((1024-3)*zoom)) || (xx < (0))))
  {
    translate((int)-xx,0,0);
  }
  else
    xx = xx - direction;
}
void movey(float direction)
{
  yy = yy + direction;
  if(!((yy > ((512-3)*zoom)) || (yy < -((512-3)*zoom))))
  { 
    translate(0,(int)-yy,0);
  }
  else
    yy = yy - direction;
}
void movez(float direction)
{
  if(!((zz > (500)) || (zz < (-50))))
  {
    zz = zz + (direction);
    translate(0,0,(int)zz);
  }
  print(direction);
}

void display (float row1, float col1, float row2, float col2)
{
 // textureWrap(CLAMP);
  for (float y=col1*zoom; y< (col2 - 1)*zoom; )
  {
    beginShape(TRIANGLE_STRIP);
    //texture(tex);
    for (float x=abs(row1*zoom); x<row2*zoom;)
    {   
      fill(terrain[(int)x/zoom][(int)y/zoom]);
     // noise(x,y);
      vertex(x, y*2, (map(terrain[(int)x/zoom][(int)y/zoom], 0, 255, 0, 50)+random(-0.1,0.1))*zoom);
      //vertex(x*zoom, (y+0.5)*zoom*2, map((terrain[(int)x][(int)y]+terrain[(int)x][(int)y+1])/2, 0, 255, 0, 50)*zoom);
      vertex(x, (y+depth)*2, (map(terrain[(int)x/zoom][(int)(y+depth)/zoom], 0, 255, 0, 50)+random(-0.1,0.1))*zoom);
      
      //fill(terrain[x][y]);
      //vertex((x+0.5)*zoom, y*zoom*2, map((terrain[x][y]+terrain[x+1][y])/2, 0, 255, 0, 50)*zoom);
      //vertex((x+0.5)*zoom, (y+0.5)*zoom*2, map((terrain[x][y]+terrain[x][y+1]+terrain[x+1][y]+terrain[x+1][y+1])/4, 0, 255, 0, 50)*zoom);
      //vertex((x+0.5)*zoom, (y+1)*zoom*2, map((terrain[x][y+1]+terrain[x+1][y+1])/2, 0, 255, 0, 50)*zoom);
      
      //for (int b=(int)(y*zoom*2); b<((y+1)*zoom*2);)
      //{
      //  b+=5;
      //  for (int a=(int)(x*zoom); a<((x+1)*zoom);)
      //  {
      //    a+=5;
      //    vertex(a, b, map(terrain[x][y], 0, 255, 0, 50)*zoom);
      //    vertex(a, b, map(terrain[x][y+1], 0, 255, 0, 50)*zoom);
      //  }
      //}  
      x+=depth;
    }
    endShape();
    y+=depth;
  }
}

void noise_(float x, float y)
{
  
}

void procedural_generation()
{
  move();
  display(xx/zoom,0,xx/zoom+fardistance,cols);
}

void move()
{
  camera_direction = -(map(mouseX, 0, width, -PI, PI));
  float tempx = 0, tempy = 0;
  if(start)
  {
    if(gofront)
    {
      tempx += cos(camera_direction)*speed;
      tempy += sin(camera_direction)*speed;
    }
    else if(goback)
    {
      tempx -= cos(camera_direction)*speed;
      tempy -= sin(camera_direction)*speed;
    }
    if(goright)
    {
      tempx -= sin(camera_direction)*speed;
      tempy += cos(camera_direction)*speed;
    }
    else if(goleft)
    {
      tempx += sin(camera_direction)*speed;
      tempy -= cos(camera_direction)*speed;
    }
  }
    movex(tempx);
    movey(tempy);
}

void keyPressed()
{
  start = true;
  if (key == 'W' || key == 'w')
  {
    gofront = true;
  }
  else if (key == 'S' || key == 's')
  {
    goback = true;
  }
  if (key == 'A' || key == 'a')
  {
    goleft = true;
  }
  else if (key == 'D' || key == 'd')
  {
    goright = true;
  }
  if (key == 'P' || key == 'p')
  { 
    gofront = false;
    goback = false;
    goright = false;
    goleft = false;
    start = false;
  }
  
}




//void display (float row1, float col1, float row2, float col2)
//{
// // textureWrap(CLAMP);
//  for (int y=(int)col1*zoom; y< (col2 - 1)*zoom; y++)
//  {
//    beginShape(QUAD_STRIP);
//    //texture(tex);
//    for (int x=(int)row1*zoom; x<row2*zoom; x++)
//    {  
//      fill(terrain[x/zoom][y/zoom]);
//      float u = tex.width / row2 * x;
//      vertex(x, y*2, map(terrain[x/zoom][y/zoom], 0, 255, 0, 50)*zoom);
//      vertex(x, (y+1)*2, map(terrain[x/zoom][(y+1)/zoom], 0, 255, 0, 50)*zoom);
      
//      //for (int a=(int)(y*zoom); a<((y+1)*zoom*2); a++)
//      //{
//      //  for (int b=(int)(x*zoom); b<((x+1)*zoom); b++)
//      //  {
//      //    float u = tex.width / row2 * x;
//      //    vertex(a, b, map(terrain[x][y], 0, 255, 0, 50)*zoom, u, (tex.height*(y+1)/(col2+1)));
//      //    vertex(a, b, map(terrain[x][y+1], 0, 255, 0, 50)*zoom, u, (tex.height*(y+1)/(col2+1)+1));
//      //  }
//      //}
//    }
//    endShape();
//  }
//}
