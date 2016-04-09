  //runaway!!
  import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context
int delay=16;
float nX=0;
float nY=0;
color c1=#00bfff;
color c2=#138b38;
color c3=#c61531;
int score=0;
runner greg,charlie;
jumper Stan;
treasure Tim;
void setup(){
  minim = new Minim(this);
  player = minim.loadFile("a.mp3", 2048);
  player.play();
  player.loop();
  strokeWeight( 2 );
  size( 800, 700 );
  background(250);
  frameRate( 30 ); 
  greg=new runner(c1,400,450,1,25);
  charlie=new runner(c2,400,600,-2,30);
  Stan=new jumper(c3,400,20,0,10);
  Tim = new treasure(color(random(255),random(255),random(255)),random(100,700),random(100,300),20.0);  
}

void draw(){
  background(250);
  fill(c1);
  line(0,450,800,450);
  line(0,600,800,600);
  greg.update();
  charlie.update();
  Stan.update(greg,charlie);
  Tim.update(Stan);
  fill(0, 102, 153);
  textSize(70);
  text((score), 385, 250);
}

class runner
{
  color Color;
  float size,speed,originalspeed;
  float xpos,ypos;
  runner(color c, float x, float y, float s,float s2)
      {
        Color = c;
        xpos= x;
        ypos=y;
        speed=s;
        originalspeed=s;
        size=s2;
      
      }
      int direction(float x){
      if (x<0){
        return(-1);
      }
      else{
        return(1);}
      }
      void update()
      {
      speed=((originalspeed*direction(originalspeed))+(score/3))*direction(speed);
      if (xpos<0 || xpos>800)
      {
      speed=speed*-1;  
      }
      xpos+=speed;
      fill(Color);
      ellipse(xpos,ypos,(size),(size));  
      }
}



class treasure
{
  color Color;
  float size;
  float xpos,ypos;
  treasure(color c, float x, float y, float s)
      {
        Color = c;
        xpos= x;
        ypos=y;
        size=s;
      
      }
  void update(jumper a)
  {
  if (a.dist(a.xpos,a.ypos,this.xpos,this.ypos)<this.size)
  {
    score+=1;
    this.Color=color(random(255),random(255),random(255));
    this.xpos=random(100,700);
    this.ypos=random(100,300);
  }
  fill(this.Color);
  ellipse(this.xpos,this.ypos,this.size,this.size);
}
}



class jumper
{
color Color;
boolean bounced;
int size;
float xpos,ypos,acceleration,vspeed,hspeed; 
jumper(color c,int x, int y, float s, int s2)
{
  Color = c;
  xpos= x;
  ypos=y;
  vspeed=s;
  hspeed=0;
  size=s2;
  acceleration=0.07;
}


float dist(float a,float b, float c, float d){
          //x^2 +y^2
        float first = pow((c-a),2)+pow((d-b),2);
      return(pow(first,0.5)); 
      }

void reset(runner a, runner b){
    this.xpos=400;
    this.ypos=20;
    this.vspeed=0;
    this.hspeed=0;
    score=0;
    a.speed=a.originalspeed;
    b.speed=b.originalspeed;
    a.xpos=400;
    b.xpos=400;
    }

void update(runner a, runner b)
{
  //case of Stan hitting Greg or Charlie
if ((this.dist(this.xpos,this.ypos,a.xpos,a.ypos)<(a.size)) ||  (this.dist(this.xpos,this.ypos,b.xpos,b.ypos)<(b.size)))
{
acceleration=-4;
a.Color=color(random(255),random(255),random(255));
b.Color=color(random(255),random(255),random(255));
//bounce effect
if (vspeed>0){
vspeed=-0.5*vspeed;}
}
/////
else{
acceleration=0.09;
}
//vertical speed limiter
if (pow(vspeed,2)<pow(12,2)){
vspeed+=acceleration;
}
ypos+=vspeed;
//bounce off walls
if (xpos>800){
  hspeed=-0.7*hspeed;
  xpos=800;}
if (xpos<0){
  hspeed=-0.7*hspeed;
  xpos=0;}
//bounce off top of screen
if (ypos<0){
  vspeed=-0.5*vspeed;
  ypos=0;}
if (ypos>height){
score=0;
this.reset(greg,charlie);
}

xpos+=hspeed;
fill(Color);
ellipse(xpos,ypos,size,size);
}
}
void mouseMoved(){
  nX = mouseX;
  nY = mouseY;  
}
void keyPressed(){
  if (key==('a')){
    if (Stan.hspeed>-30){
    Stan.hspeed+=-2;}}
  if (key==('d')){
    if (Stan.hspeed<30){
    Stan.hspeed+=2;}}
  if (key==('r')){
    Stan.reset(greg,charlie);}
}