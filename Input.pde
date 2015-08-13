class Input{
  int W;
  int A;
  int S;
  int D;
  int mouseDrag=0;
  void keyPressed(){
    if(key=='w')W=1;
    if(key=='a')A=1;
    if(key=='s')S=1;
    if(key=='d')D=1;    
  }
  void keyReleased(){
    if(key=='w')W=0;
    if(key=='a')A=0;
    if(key=='s')S=0;  
    if(key=='d')D=0;
  }
  void mousePressed(){
    b=0;
    mouseDrag=1;
    if(mouseX>width-160){
      mapLayer.PmouseX=mouseX;mapLayer.mousey=mouseY;
      mapLayer.paint = (mapLayer.PmouseX/16)+(8*(mapLayer.mousey/16-a)-35);
      mapLayer.copy = mapLayer.editmap.get((mapLayer.paint%8)*16,(mapLayer.paint/8)*16,16,16);
    }
    if((mouseX>0)&&(mouseX<60)&&(mouseY>30)&&(mouseY<50))mapLayer.now=1;
    if((mouseX>60)&&(mouseX<120)&&(mouseY>30)&&(mouseY<50))mapLayer.now=2;
    if((mouseX>120)&&(mouseX<180)&&(mouseY>30)&&(mouseY<50))mapLayer.now=3;
    if((mouseX>180)&&(mouseX<220)&&(mouseY>30)&&(mouseY<50))mapLayer.now=0;
    if((mouseX>220)&&(mouseX<260)&&(mouseY>30)&&(mouseY<50))mapLayer.save();
    if((mouseX>260)&&(mouseX<320)&&(mouseY>30)&&(mouseY<50)){
      mapLayer.saveLayer=loadImage("layer.png");
      mapLayer.mask=loadImage("mask.png");
    }
    println(mouseX+","+mouseY+","+mapLayer.maskTool);
    if((mouseX>290)&&(mouseX<320)&&(mouseY>30)&&(mouseY<50))mapLayer.maskTool=1;
    if((mouseX>320)&&(mouseX<650)&&(mouseY>30)&&(mouseY<50))mapLayer.maskTool=2;
  }
  void mouseWheel(int delta){
    if(mouseX>width-160){a-=delta*16;b-=delta*16;}
    if(a>0){a=0;b=0;}
    if(a<0-mapLayer.editmap.height){a=0;}    
  }
  void mouseReleased(){
    mouseDrag=0;
  }
}
