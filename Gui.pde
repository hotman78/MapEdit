class Gui{
  PImage bottom;
  Gui(){
    bottom = loadImage("btn057_10.png");
  }
  void draw(){
     gui.bottom("import",40,0,false);
     gui.bottom("LAYER1",0,30,mapLayer.now==1);
     gui.bottom("LAYER2",60,30,mapLayer.now==2);
     gui.bottom("LAYER3",120,30,mapLayer.now==3);
     gui.bottom("save",180,30,false);
     gui.bottom("mask",220,30,false);
     gui.bottom("ALL",320,50,false);
     gui.bottom("import",260,30,false);
  }
  
  void bottom(String content,int x,int y,boolean selected){
    int b =content.length();
    fill(0);
    if(selected)tint(255,0,0);
    image(bottom,x,y,10*b,20);
    noTint();
    text(content,x+b,y+12);
  }
  void Scrollbar(int x,int y,int widthScrollbar,float part){
     fill(50,50,50);
     
     fill(0);
     triangle(x+4,y+2,x+12,y+2,x+8,y+(sqrt(3)*5)+2);
     triangle(x+4,y+widthScrollbar-2,x+12,y+widthScrollbar-2,x+8,y-(sqrt(3)*5)+widthScrollbar-2);
  } 
}
