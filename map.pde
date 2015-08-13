class MapLayer{
  int now=1;
  PImage editmap;
  PImage copy=createImage(16,16, 255);
  PImage[] layerImage;
  PImage saveLayer;
  PImage mask;
  PImage oMask;
  int PmouseX=554;
  int mousey=0;
  int paint=0 ;
  int edgeX=0;
  int edgeY=0;
  int maskTool;
  /*変数紹介
  PmaouseX,PmouseY:最後にマウスが押された瞬間のマウスの座標が入っています
  
  */
  MapLayer(){
    editmap = loadImage("base.png");
    layerImage =new PImage[3];
    for(int i=0;i<3;i++)layerImage[i]=createImage(layerSize.X*16,layerSize.Y*16,ARGB);
    saveLayer= createImage(layerSize.X*16,layerSize.Y*16,ARGB);
    mask= createImage(layerSize.X*16,layerSize.Y*16,ARGB);
    oMask= createImage(layerSize.X,layerSize.Y,RGB);
    mask.loadPixels();
    for(int i=0;i<mask.pixels.length;i++)mask.pixels[i]=color(255,255,255,0);
    mask.updatePixels();
    oMask.loadPixels();
    for(int i=0;i<oMask.pixels.length;i++)oMask.pixels[i]=color(255,255,255,0);
    oMask.updatePixels();
  }
  void edit(int layerNow){
    if(layerNow==0){maskEdit();return;}
    fill(255);
    rect(0,79,546,402);
    for(int i=0;i<layerNow;i++){
      image(layerImage[i].get(edgeX,edgeY,544,400),0,80);
    }
    fill(255);
    image(editmap,width-160,a*16);
    fill(0,204,255,100);
    rect(PmouseX-PmouseX%16,mousey-mousey%16+b*16,16,16);
    if(input.mouseDrag==1){
      for(int i=0;i<layerNow;i++){
        layerImage[layerNow-1].loadPixels();
      }
      copy.loadPixels();
      if(mouseX<width-160){
        int x=mouseX/16*16;
        int y=mouseY/16*16;
        for(int i=0;i<16;i++)for(int j=0;j<16;j++){
          if((layerSize.Y*16>x+i+edgeX)
          &&(layerSize.X*16>y+j-80+edgeY)
          &&(0<x+i+edgeX)&&(0<y+j-80+edgeY)){
            paint(x+i+edgeX,y+j+edgeY-80,layerImage[layerNow-1],copy.pixels[j*copy.width+i]);
          }
        }
        layerImage[layerNow-1].updatePixels();
      }
      //ALLが押されたときの処理をしています
      if((mouseX<350)&&(mouseX>320)&&(mouseY>30)&&(mouseY<50)){
        layerImage[layerNow-1].loadPixels();
        copy.loadPixels();
        for(int i=0;i<layerSize.X;i++)for(int j=0;j<layerSize.Y;j++){
          for(int k=0;k<16;k++)for(int l=0;l<16;l++){
            paint(i*16+k,j*16+l,layerImage[layerNow-1],copy.pixels[l*copy.width+k]);
          }
        }
        layerImage[layerNow-1].updatePixels();
      }
    }
  }
  void maskEdit(){
    int selected=0;
    fill(255);
    rect(0,79,546,402);
    for(int i=0;i<3;i++){
      image(layerImage[i].get(edgeX,edgeY,544,400),0,80);
    }
    image(mask.get(edgeX,edgeY,544,400),0,80);
    //ぺんと消しゴムのボタンを作り、
    
    if(input.mouseDrag!=1)return;
    mask.loadPixels();
    copy.loadPixels();
    if(mouseX<width-160){
      //16で割ったあまりを除いています
      int x=mouseX/16*16;
      int y=mouseY/16*16;
      for(int i=0;i<16;i++)for(int j=0;j<16;j++){
        if((layerSize.X*16>y+j-80+edgeY)
        &&(layerSize.Y*16>x+i+edgeX)
        &&(0<x+i+edgeX)&&(0<y+j-80+edgeY)){
          if(maskTool==1){
            paint(x+i+edgeX,y+j-80+edgeY,mask,color(255,100));
            paint((mouseX+edgeX)/16,(mouseY+edgeY)/16-5,oMask,color(0,0));
          }
          if(maskTool==2){
            paint(x+i+edgeX,y+j-80+edgeY,mask,color(255,0));
            paint((mouseX+edgeX)/16,(mouseY+edgeY)/16-5,oMask,color(255,0));
          }
        }
      }
    }
  }
  //関数終了
  //X,Yのピクセルを書き出す
  void paint(int X,int Y,PImage object,color iro){
    object.pixels[Y*(object.width)+X] = iro;
  }
  color[] cl;
  void save(){
    cl=new color[3];
    saveLayer.loadPixels();
    for(int i=0;i<now;i++)layerImage[i].loadPixels();
    mask.loadPixels();
    for(int i=0;i<layerSize.X*16;i++)for(int j=0;j<layerSize.Y*16;j++){
      color clf=mask.pixels[j*mask.width+i];
      for(int k=0;k<3;k++){
        cl[k]=layerImage[k].pixels[j*layerImage[k].width+i];
        if(alpha(cl[k])==255)saveLayer.pixels[j*saveLayer.width+i]=layerImage[k].pixels[j*layerImage[k].width+i];
      }
    }
    saveLayer.save("layer.png");
    oMask.save("mask.png");
  }
}
