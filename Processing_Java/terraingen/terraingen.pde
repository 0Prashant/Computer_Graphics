import peasy.*;
int zoom = 8;
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
int speed = 3;
float depth= zoom/4;
float tempx = 0, tempy = 0;


PVector[][] globe;
int total = 100;
PImage wrap;

void setup()
{
  fullScreen(P3D);
  import_image();
  camera_setup();
  terrain = convolute4(rows*zoom, cols*zoom, terrain); 
  terrain = expand_terrain(terrain);
  terrain = noise_setup(terrain);
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain);
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain);
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain);
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain); 
  terrain = convolute9(rows*zoom, cols*zoom, terrain);
  //terrain = final_noise(terrain);
  smooth(4);
  frameRate(60);
}

void draw()
{
  background(0);
  lightening();
  initialize_orientation();
  sphere();
  translate(-200,0,0);
  procedural_generation();
}

void import_image()
{
  img = loadImage("../moon_1low.jpg");
  tex = loadImage("../8k_moon.jpg");
  wrap = loadImage("../earth.jpg");
  img.loadPixels();
  globe = new PVector[total+1][total+1];
  terrain = new float[rows*zoom][cols*zoom];
  for (int i=0; i<rows; i++)
  {
    for (int j=0; j< cols; j++)
    {
      color rgb = img.pixels[i*cols+j];
      
      int r = (rgb >> 16) & 0xFF;
      int g = (rgb >> 8) & 0xFF;
      int b = (rgb) & 0xFF;

      terrain[i][j] = (r+g+b)/(3);
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
  directionalLight(255,255,255, 0, 100, 0);
  directionalLight(255,255,255,0,500,0);
  ////pointLight(50, 50, 50, 0, 0, -10);
  //noStroke();
  ////lights();
  //ambientLight(172, 136, 111);
  //directionalLight(50, 50, 50, 0, 0, -10);
}


float[][] convolute4(int rows, int cols, float[][] array)
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
float[][] convolute9(int rows, int cols, float[][] array)
{
  float[][] new_matrix = new float[rows][cols];
  
  for(int i = (1); i < (rows-2); i++)
  {
    for (int j = (1); j < (cols-2); j++)
    {
      new_matrix[i][j] = (array[i][j]+array[i+1][j]+array[i][j+1]+array[i+1][j+1]+array[i-1][j]+array[i][j-1]+array[i-1][j-1]+array[i-1][j+1]+array[i+1][j-1])/(9);
    }
  }
  return new_matrix;
}
float[][] expand_terrain(float[][] array)
{
  float[][] new_matrix = new float[rows*zoom][cols*zoom];
  for (int j = (0); j < (cols); j++)
  {
    for(int i = (0); i < (rows); i++)
    {
      new_matrix[i*zoom][j*zoom] = array[i][j];
    }
  }  
  return new_matrix;
}

float[][] noise_setup(float[][] array)
{
  float[][] new_matrix = new float[rows*zoom][cols*zoom];
  for (int j = (0); j < (cols*zoom); j++)
  {
    for(int i = (0); i < (rows*zoom); i++)
    {
      new_matrix[i][j] = array[((int)(i/zoom))*zoom][((int)(j/zoom))*zoom];
    }
  } 
  for (int j = (0); j < (cols*zoom); j++)
  {
    for(int i = (0); i < (rows*zoom); i++)
    {
      new_matrix[i][j] += map(noise(i,j,new_matrix[i][j]),0,1,-40,40);
    }
  }
  return new_matrix;
}
float[][] final_noise(float[][] array)
{
  float[][] new_matrix = new float[rows*zoom][cols*zoom];
  for (int j = (0); j < (cols*zoom); j++)
  {
    for(int i = (0); i < (rows*zoom); i++)
    {
      new_matrix[i][j] = array[((int)(i/zoom))*zoom][((int)(j/zoom))*zoom];
    }
  } 
  for (int j = (0); j < (cols*zoom); j++)
  {
    for(int i = (0); i < (rows*zoom); i++)
    {
      new_matrix[i][j] += map(noise(i,j,new_matrix[i][j]),0,1,-1,1);
    }
  }
  return new_matrix;
}
void initialize_orientation()
{  
  translate(rows*zoom/2, cols*zoom/2,0);
  rotateX(PI/2.5);
  rotateZ(-PI/2);
  rotateZ(-camera_direction);
  translate(-rows*zoom/2, -cols*zoom/2,0);
  translate(rows*zoom/2,-cols*zoom/2,-zoom*30);
}

void movex(float direction)
{
  xx = xx + direction;
  if(!((xx > ((1024-3)*zoom)) || (xx < (0))))
  {
    translate((int)-xx*zoom,0,0);
  }
  else
    xx = xx - direction;
}
void movey(float direction)
{
  yy = yy + direction;
  if(!((yy > ((512-3)*zoom)) || (yy < -((512-3)*zoom))))
  { 
    translate(0,(int)-yy*zoom,0);
  }
  else
    yy = yy - direction;
}
void movez(float direction)
{
  if(!((zz > (500)) || (zz < (-50))))
  {
    zz = zz + (direction);
    translate(0,0,(int)zz*zoom);
  }
}

void display (float row1, float col1, float row2, float col2)
{
  float u = 0, v = 0;
  for (float y=col1; y< (col2 - zoom); y+=depth)
  {
    beginShape(TRIANGLE_STRIP);
    texture(tex);
    for (float x=row1; x<row2; x+=depth)
    { 
      fill(terrain[(int)x][(int)y]);
      u = tex.width*x / (row2*4) ;
      v = tex.height*(y+1)/(col2+1);
      //vertex(x, y*2, (map(terrain[(int)x][(int)y], 0, 255, 0, 50)+noise)*zoom);
      //vertex(x, (y+depth)*2, (map(terrain[(int)x][(int)(y+depth)], 0, 255, 0, 50)+noise)*zoom);
      //float noise = map(noise(x,y,terrain[(int)x][(int)y]),0,1,-1,1);
      vertex(x, y*2, (terrain[(int)x][(int)y])*zoom/6,u,v);
      vertex(x, (y+depth)*2, (terrain[(int)x][(int)(y+depth)])*zoom/6,u,v+depth);
    }
    endShape();
  }
  //   float u = 0, v = 0;
  //for (float y=col1; y< (col2 - zoom); y+=depth)
  //{
  //  beginShape(TRIANGLE_STRIP);
  //  texture(tex);
  //  for (float x=row1; x<row2; x+=depth)
  //  { 
  //    //fill(terrain[(int)x][(int)y]);
  //    u = tex.width*x / row2 ;
  //    v = tex.height*(y+1)/(col2+1);
      
  //    vertex(x*2, y, (terrain[(int)x][(int)y])*zoom/6, u, v);
  //    vertex(x, (y+depth)*2, (terrain[(int)x][(int)(y+depth)])*zoom/6, u, v+depth);
  //  }
  //  endShape();
  //}
}


void procedural_generation()
{
  move();
  display(xx*zoom,cols*zoom*0.25,(xx+fardistance)*zoom,cols*zoom*0.75);
}

void move()
{
  camera_direction = -(map(mouseX, 0, width, -PI, PI));
  if(start)
  {
    tempx = 0;
    tempy = 0;
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
    movex((int)tempx);
    movey((int)tempy);
}

void keyPressed()
{
  start = true;
  if (key == 'W' || key == 'w')
  {
    gofront = true;
    goback = false;
    goright = false;
    goleft = false;
  }
  else if (key == 'S' || key == 's')
  {
    goback = true;
    gofront = false;
    goright = false;
    goleft = false;
  }
  if (key == 'A' || key == 'a')
  {
    goleft = true;
    gofront = false;
    goback = false;
    goright = false;
  }
  else if (key == 'D' || key == 'd')
  {
    goright = true;
    gofront = false;
    goback = false;
    goleft = false;
  }
  else if (key == '7' || key == '&')
    depth = zoom/1;
  else if (key == '8' || key == '*')
    depth = zoom/2;
  else if (key == '9' || key == '(')
    depth = zoom/4;
  if (key == 'P' || key == 'p')
  { 
    gofront = false;
    goback = false;
    goright = false;
    goleft = false;
    start = false;
    tempx = 0;
    tempy = 0;
  }
}

void sphere() {
  float del_u = wrap.width/total;
  float del_v = wrap.height/total;
  float u = 0;
  float v = 0;
  background(0);
  noStroke();
  float r = 200;
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, 0, PI);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, 0, TWO_PI);
      float x = r * sin(lat) * cos(lon);
      float y = r * sin(lat) * sin(lon);
      float z = r * cos(lat);
      globe[i][j] = new PVector(x+(fardistance+100)*zoom, y+(cols)*zoom, z+50*zoom);
    }
  }
  for (int i = 0; i < total; i++) {
    beginShape(TRIANGLE_STRIP);
    texture(wrap);
    for (int j = 0; j < total+1; j++) {
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z,u,v);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z,u,v+del_v);
      u += del_u;
    }
   v+= del_v;
   u = 0;
   endShape();
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


/*
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
      vertex(x, y*2, (map(terrain[(int)x/zoom][(int)y/zoom], 0, 255, 0, 50)+noise(-10,10))*zoom);
      //vertex(x*zoom, (y+0.5)*zoom*2, map((terrain[(int)x][(int)y]+terrain[(int)x][(int)y+1])/2, 0, 255, 0, 50)*zoom);
      vertex(x, (y+depth)*2, (map(terrain[(int)x/zoom][(int)(y+depth)/zoom], 0, 255, 0, 50)+noise(-10,10))*zoom);
      
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
}*/


//void display (float row1, float col1, float row2, float col2)
//{
//  for (float y=col1; y< (col2 - zoom); y+=depth)
//  {
//    beginShape(TRIANGLE_STRIP);
//    for (float x=row1; x<row2; x+=depth)
//    {  
//      fill(terrain[(int)x][(int)y]);
//      vertex(x, y*2, map(terrain[(int)x][(int)y], 0, 255, 0, 50)*zoom);
//      vertex(x, (y+depth)*2, map(terrain[(int)x][(int)(y+depth)], 0, 255, 0, 50)*zoom);
//    }
//    endShape();
//  }
//}
