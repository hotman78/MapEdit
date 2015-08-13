class Gui{
  PImage button;
  Gui(){
    button = loadImage("btn057_10.png");
  }
  void draw(){
     button("import",40,0,false);
     button("LAYER1",0,30,mapLayer.now==1);
     button("LAYER2",60,30,mapLayer.now==2);
     button("LAYER3",120,30,mapLayer.now==3);
     button("mask",180,30,mapLayer.now==0);
     button("save",220,30,false);
     button("ALL",260,30,false);
     //button("import",260,30,false);
     button("pen",290,30,mapLayer.maskTool==1);
     button("eraser",320,30,mapLayer.maskTool==2);
  }
  
  void button(String content,int x,int y,boolean selected){
    int b =content.length();
    fill(0);
    if(selected)tint(255,0,0);
    image(button,x,y,10*b,20);
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
