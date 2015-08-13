import java.awt.event.*;
import java.awt.*;
import javax.swing.*;
int a=0;
int b=0;

Gui gui;
LayerSize layerSize;
MapLayer mapLayer;
Input input;

void setup(){
  size(720,500);
  background( 0 );

  gui= new Gui();
  layerSize = new LayerSize();
  mapLayer = new MapLayer();
  input=new Input();
  PFont font = loadFont("HGPMinchoB-20.vlw");
  addMouseWheelListener(new MouseWheelListener() { 
  public void mouseWheelMoved(MouseWheelEvent mwe){mouseWheel(mwe.getWheelRotation());}}); 
  


}

void draw(){
  background( 0 );
  if(mapLayer.edgeX>-160){if(input.A==1)mapLayer.edgeX-=16;}
  if(mapLayer.edgeY>-160){if(input.W==1)mapLayer.edgeY-=16;}
  if(mapLayer.edgeX<407){if(input.D==1)mapLayer.edgeX+=16;}
  if(mapLayer.edgeY<560){if(input.S==1)mapLayer.edgeY+=16;}
  mapLayer.edit(mapLayer.now);
  gui.draw();
  fill(255);
  if((mouseX<554)&&(mouseX>0)&&(mouseY>80)&&(mouseY<480)){
     text(((mouseX/16*16+mapLayer.edgeX)/16+1)+"X"+((mouseY/16*16-80+mapLayer.edgeY)/16+1),350,50);
  }
}

void mousePressed(){
  input.mousePressed();
}

void mouseReleased(){
  input.mouseReleased();
}
void mouseWheel(int delta){
  input.mouseWheel(delta);
}

void keyPressed(){
  input.keyPressed();
}
void keyReleased(){
  input.keyReleased();
}
