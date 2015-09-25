import java.awt.*;
import javax.swing.*;
import javax.swing.filechooser.*;

MEditor meditor;

void setup(){
  size(720, 500);
  
  meditor = new MEditor();
}

void draw(){
  background(0);
  meditor.update();
  meditor.draw();
}

void mousePressed(){
  meditor.mousePressed();
}

void mouseReleased(){
  meditor.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  meditor.mouseWheel(event.getCount());
}

void keyPressed(){
  meditor.keyPressed();
}

void keyReleased(){
  meditor.keyReleased();
}