import peasy.*;
int zoom = 8;
float[][] terrain;
float [][] noise;
PShader nebula;
PeasyCam camera;
PImage img;
PImage tex;
PShader shader;
int rows = 1024;
int cols = 512;
float zz,xx,yy;
boolean start = false;
boolean gofront, goback, goright, goleft; 
boolean animate;
float camera_direction=0;
int camera_angle = 100;
int fardistance = 200;
int speed = 2;
float depth= zoom/8;
float tempx = 0, tempy = 0;
int side_side_view = 44;
int next = 40;
int y_offset = 256;
float initial_boundary[][][] = {
                        { {0,-10}, {0,+10}, {next,-side_side_view-10}, {next,+side_side_view+10} }, 
                        { {next,-side_side_view}, {next,+side_side_view}, {2*next,-2*side_side_view-10}, {2*next,+2*side_side_view+10} },
                        { {2*next,-2*side_side_view}, {2*next,+2*side_side_view}, {3*next,-3*side_side_view}, {3*next,+3*side_side_view} },
                        { {3*next,-3*side_side_view}, {3*next,+3*side_side_view}, {4*next,-4*side_side_view}, {4*next,+4*side_side_view} },
                        { {4*next,-4*side_side_view}, {4*next,+4*side_side_view}, {5*next,-5*side_side_view}, {5*next,+5*side_side_view} },
                        { {5*next,-5*side_side_view}, {5*next,+5*side_side_view}, {6*next,-6*side_side_view}, {6*next,+6*side_side_view} },
                       };
float boundary[][][] = {
                        { {0,-10}, {0,+10}, {next,-side_side_view-10}, {next,+side_side_view+10} }, 
                        { {next,-side_side_view}, {next,+side_side_view}, {2*next,-2*side_side_view-10}, {2*next,+2*side_side_view+10} },
                        { {2*next,-2*side_side_view}, {2*next,+2*side_side_view}, {3*next,-3*side_side_view}, {3*next,+3*side_side_view} },
                        { {3*next,-3*side_side_view}, {3*next,+3*side_side_view}, {4*next,-4*side_side_view}, {4*next,+4*side_side_view} },
                        { {4*next,-4*side_side_view}, {4*next,+4*side_side_view}, {5*next,-5*side_side_view}, {5*next,+5*side_side_view} },
                        { {5*next,-5*side_side_view}, {5*next,+5*side_side_view}, {6*next,-6*side_side_view}, {6*next,+6*side_side_view} },
                       };


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
  //  nebula = loadShader("../nebula.glsl");
  //nebula.set("resolution", float(width), float(height));
  frameRate(60);
}

void draw()
{
  background(0);
  
  //nebula.set("time", millis() / 500.0);  
  //shader(nebula); 
  lightening();
  //perspective(30, 1, 1, 5000);
  initialize_orientation();
  sphere();
  procedural_generation();
}

void import_image()
{
  img = loadImage("../moon_1low.jpg");
  tex = loadImage("../8k_moon.jpg");
  wrap = loadImage("../earth.jpg");
  shader = loadShader("../noisy.glsl");
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
  directionalLight(155,155,155, 0, 100, 0);
  directionalLight(155,155,155,0,500,0);
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
  rotateX(PI/2.7);
  rotateZ(-PI/2);
  rotateZ(-camera_direction);
  translate(-rows*zoom/2, -cols*zoom/2,0);
  translate(rows*zoom/2+22*zoom,-cols*zoom/2,-zoom*30);
  translate(-200,0,0);
  //if(terrain[(int)xx][(int)yy+216]<22*zoom)
  //{}
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

void display_level3 (float row1, float col1, float row2, float col2)
{
  float u = 0, v = 0;
  for (float y=col1; y< (col2 - zoom); y+=depth)
  {
    if((y>511*zoom)||y<0)
      continue;
    else
    {
      beginShape(TRIANGLE_STRIP);
      texture(tex);
      shader(shader);
      for (float x=row1; x<row2; x+=depth)
      {
        if((x>1023*zoom)||x<0)
          continue;
        else
        {
          fill(terrain[(int)x][(int)y]);
          u = tex.width*x / (rows*zoom) ;
          v = tex.height*(y+1)/((cols+1)*zoom);
          //vertex(x, y*2, (map(terrain[(int)x][(int)y], 0, 255, 0, 50)+noise)*zoom);
          //vertex(x, (y+depth)*2, (map(terrain[(int)x][(int)(y+depth)], 0, 255, 0, 50)+noise)*zoom);
          //float noise = map(noise(x,y,terrain[(int)x][(int)y]),0,1,-1,1);
          vertex(x, y*2, (terrain[(int)x][(int)y])*zoom/6,u,v);
          vertex(x, (y+depth)*2, (terrain[(int)x][(int)(y+depth)])*zoom/6,u,v+depth);
        }      
      }
      endShape();
    }
  }
}
void display_level2 (float row1, float col1, float row2, float col2)
{
  float level2_depth = depth*2;
  float u = 0, v = 0;
  for (float y=col1; y< (col2 - zoom); y+=level2_depth)
  {
    if((y>511*zoom)||y<0)
      continue;
    else
    {
      beginShape(TRIANGLE_STRIP);
      texture(tex);
      //shader(shader);
      for (float x=row1; x<row2; x+=level2_depth)
      {
        if((x>1023*zoom)||x<0)
          continue;
        else
        {
          fill(terrain[(int)x][(int)y]);
          u = tex.width*x / (rows*zoom) ;
          v = tex.height*(y+1)/((cols+1)*zoom);
          //vertex(x, y*2, (map(terrain[(int)x][(int)y], 0, 255, 0, 50)+noise)*zoom);
          //vertex(x, (y+depth)*2, (map(terrain[(int)x][(int)(y+depth)], 0, 255, 0, 50)+noise)*zoom);
          //float noise = map(noise(x,y,terrain[(int)x][(int)y]),0,1,-1,1);
          vertex(x, y*2, (terrain[(int)x][(int)y])*zoom/6,u,v);
          vertex(x, (y+level2_depth)*2, (terrain[(int)x][(int)(y+level2_depth)])*zoom/6,u,v+level2_depth);
        }      
      }
      endShape();
    }
  }
}

void display_level1 (float row1, float col1, float row2, float col2)
{
  float level1_depth = depth*4;
  float u = 0, v = 0;
  for (float y=col1; y< (col2 - zoom); y+=level1_depth)
  {
    if((y>511*zoom)||y<0)
      continue;
    else
    {
      beginShape(TRIANGLE_STRIP);
      texture(tex);
      //shader(shader);
      for (float x=row1; x<row2; x+=level1_depth)
      {
        if((x>1023*zoom)||x<0)
          continue;
        else
        {
          fill(terrain[(int)x][(int)y]);
          u = tex.width*x / (rows*zoom) ;
          v = tex.height*(y+1)/((cols+1)*zoom);
          //vertex(x, y*2, (map(terrain[(int)x][(int)y], 0, 255, 0, 50)+noise)*zoom);
          //vertex(x, (y+depth)*2, (map(terrain[(int)x][(int)(y+depth)], 0, 255, 0, 50)+noise)*zoom);
          //float noise = map(noise(x,y,terrain[(int)x][(int)y]),0,1,-1,1);
          vertex(x, y*2, (terrain[(int)x][(int)y])*zoom/6,u,v);
          vertex(x, (y+level1_depth)*2, (terrain[(int)x][(int)(y+level1_depth)])*zoom/6,u,v+level1_depth);
        }      
      }
      endShape();
    }
  }
}

void procedural_generation()
{
  move();
  rotate_boundaries();
  for(int i=0; i<2; i++)
  {
    display_level3((xx+leftmost(i))*zoom, (yy/2+y_offset+topmost(i)/2)*zoom, (xx+rightmost(i)+1)*zoom, (yy/2+y_offset+bottommost(i)/2+1)*zoom);
  }
  for(int i=2; i<4; i++)
  {
    display_level2((xx+leftmost(i))*zoom, (yy/2+y_offset+topmost(i)/2)*zoom, (xx+rightmost(i)+1)*zoom, (yy/2+y_offset+bottommost(i)/2+1)*zoom);
  }
  for(int i=4; i<6; i++)
  {
    display_level1((xx+leftmost(i))*zoom, (yy/2+y_offset+topmost(i)/2)*zoom, (xx+rightmost(i)+1)*zoom, (yy/2+y_offset+bottommost(i)/2+1)*zoom);
    //rect((xx+boundary[i][0][0])*zoom, (yy/2+y_offset+boundary[i][0][1])*zoom*2, 20*zoom,20*zoom);
    //rect((xx+boundary[i][1][0])*zoom, (yy/2+y_offset+boundary[i][1][1])*zoom*2, 20*zoom,20*zoom);
    //rect((xx+boundary[i][2][0])*zoom, (yy/2+y_offset+boundary[i][2][1])*zoom*2, 20*zoom,20*zoom);
    //rect((xx+boundary[i][3][0])*zoom, (yy/2+y_offset+boundary[i][3][1])*zoom*2, 20*zoom,20*zoom);
    //rect ((xx+rightmost(i)+1)*zoom, (yy/2+y_offset+bottommost(i)+1)*zoom*2, 20*zoom,20*zoom);
  }
  print((xx+leftmost(5)), "\t", (yy/2+y_offset+topmost(5)), "\t",(xx+rightmost(5)+1), "\t", (yy/2+y_offset+bottommost(5)+1), "\n" );
  //display(0,(256-side_side_view)*zoom,(next)*zoom,(256+side_side_view)*zoom);
  //display(xx*zoom,cols*zoom*0.25,(xx+fardistance)*zoom,cols*zoom*0.75);
}

void rotate_boundaries()
{
  int tx =0, ty =0;
  for(int n=0; n<6; n++)
  {
    for(int i=0; i<4; i++)
    {
      boundary[n][i][0] = cos(camera_direction)*(initial_boundary[n][i][0]-tx) - sin(camera_direction)*(initial_boundary[n][i][1]-ty) +tx ;
      boundary[n][i][1] = sin(camera_direction)*(initial_boundary[n][i][0]-tx) + cos(camera_direction)*(initial_boundary[n][i][1]-ty) +ty ;
      //boundary[n][i][1] = initial_boundary[n][i][0] + (-initial_boundary[n][i][0]+boundary[n][i][1])/2;
      //rect(boundary[n][i][0]*zoom, (boundary[n][i][0]+y_offset)*zoom*2, 100,100);
      //print("\n boundry",n, i, "0 = ",  boundary[n][i][0]);
      //print("\n boundry",n, i, "1 = ",  boundary[n][i][1]);
    }    
  }
  
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
  
  else if (key == '1' || key == '!')
    speed = 1;
  else if (key == '2' || key == '@')
    speed = 2;
  else if (key == '3' || key == '#')
    speed = 3;
  else if (key == '4' || key == '$')
    speed = 4;
  else if (key == '5' || key == '%')
    speed = 5;
  else if (key == '7' || key == '&')
    depth = zoom/4;
  else if (key == '8' || key == '*')
    depth = zoom/8;    
  else if (key == '9' || key == '(')
    depth = zoom/1;
  else if (key == '0' || key == ')')
    animate = true;
  if (key == 'P' || key == 'p')
  { 
    depth = zoom/8;
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

float leftmost(int n)
{
  float val = 100000;
  for(int i=0; i<4; i++)
    {
      if(boundary[n][i][0]<val)   
        val = boundary[n][i][0];
    }
    //print (" \n leftmost = ", val);
  return val;
}

float rightmost(int n)
{
  float val = 0;
  for(int i=0; i<4; i++)
    {
      if(boundary[n][i][0]>val)   
        val = boundary[n][i][0];
    }
    //print (" \n rightmost = ", val);
  return val;
}

float topmost(int n)
{
  float val = 100000;
  for(int i=0; i<4; i++)
    {
      if(boundary[n][i][1]<val)   
        val = boundary[n][i][1];
    }
    //print (" \n topmost = ", val);
  return val;
}

float bottommost(int n)
{
  float val = 0;
  for(int i=0; i<4; i++)
    {
      if(boundary[n][i][1]>val)   
        val = boundary[n][i][1];
    }
    //print (" \n bottommost = ", val);
  return val;
}
