class MapLayer{
  int now=1;
  PImage editmap;
  PImage copy=createImage(16,16, 255);
  PImage[] layerImage;
  PImage saveLayer;
  PImage fragw;
  PImage fragww;
  int mousex=554;
  int mousey=0;
  int paint=0 ;
  int edgeX=0;
  int edgeY=0;
  MapLayer(){
    editmap = loadImage("base.png");
    layerImage =new PImage[3];
    for(int i=0;i<3;i++)layerImage[i]=createImage(layerSize.X*16,layerSize.Y*16,255);
    saveLayer= createImage(layerSize.X*16,layerSize.Y*16,255);
    fragw= createImage(layerSize.X*16,layerSize.Y*16,255);
    fragww= createImage(layerSize.X*16,layerSize.Y*16,255);
    fragww.loadPixels();
    for(int i=0;i<fragww.pixels.length;i++)fragww.pixels[i]=color(255);
    fragww.updatePixels();
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
    rect(mousex-mousex%16,mousey-mousey%16+b*16,16,16);
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
      if((mouseX<350)&&(mouseX>320)&&(mouseY>50)&&(mouseY<70)){
        layerImage[layerNow].loadPixels();
        copy.loadPixels();
        for(int i=0;i<layerSize.X;i++)for(int j=0;j<layerSize.Y;j++){
          for(int k=0;k<16;k++)for(int l=0;l<16;l++){
            paint(i*16+k,j*16+l,layerImage[layerNow],copy.pixels[l*copy.width+k]);
          }
        }
        layerImage[layerNow].updatePixels();
      }
    }
  }
  void maskEdit(){
    fill(255);
    rect(0,79,546,402);
    for(int i=0;i<now;i++){
      image(layerImage[i+1].get(edgeX,edgeY,544,400),0,80);
    }
    image(fragw.get(edgeX,edgeY,544,400),0,80);
    fill(255);
    image(editmap,width-160,a*16);
    fill(0,204,255,100);
    rect(mousex-mousex%16,mousey-mousey%16+b*16,16,16);
       
    if(input.mouseDrag==1){
      fragw.loadPixels();
      copy.loadPixels();
      if(mouseX<width-160){
        int x=mouseX/16*16;
        int y=mouseY/16*16;
        for(int i=0;i<16;i++)for(int j=0;j<16;j++){
          if((layerSize.X*16>y+j-80+edgeY)
          &&(layerSize.Y*16>x+i+edgeX)
          &&(0<x+i+edgeX)&&(0<y+j-80+edgeY)){
            paint(x+i+edgeX,y+j-80+edgeY,fragw,copy.pixels[j*copy.width+i]);
            if(paint<=8)paint(x+i+edgeX,y+j-80+edgeY,fragww,color(0));
            if(paint>8)paint(x+i+edgeX,y+j-80+edgeY,fragww,color(255));
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
    fragw.loadPixels();
    for(int i=0;i<layerSize.X*16;i++)for(int j=0;j<layerSize.Y*16;j++){
      color clf=fragw.pixels[j*fragw.width+i];
      for(int k=0;k<3;k++){
        cl[k]=layerImage[k].pixels[j*layerImage[k].width+i];
        if(alpha(cl[k])==255)saveLayer.pixels[j*saveLayer.width+i]=layerImage[k].pixels[j*layerImage[k].width+i];
      }
    }
    saveLayer.save("layer.png");
    fragww.save("mask.png");
  }
}
