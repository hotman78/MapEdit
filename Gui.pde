
class Gui extends Box {
  MEditor e;
  
  GButton[] bs;
  String[] ct = {"import", "save", "add_l", "fill", "pen", "eraser", "select", "mask"};
  
  boolean pr; // mouse_press
  
  Gui(MEditor e) {
    this.e = e;
    
    p = new IVector(0);
    s = new IVector(e.s.x-160, 33);
    
    bs = new GButton[ct.length];
    
    bs[0] = new GButton(this, 0, 8, 8);
    for(int i=1;i<bs.length;i++) {
      bs[i] = new GButton(this, i, bs[i-1].p.x+bs[i-1].s.x, bs[i-1].p.y);
    }
    pr = false;
    
  }
  
  int px(int px) {return e.px(px)-p.x;}
  int py(int py) {return e.py(py)-p.y;}
  
  int cx(int cx) {return e.cx(cx+p.x);}
  int cy(int cy) {return e.cy(cy+p.y);}
  
  void update() {
  }
  
  void draw(){
    for(int i=0;i<bs.length;i++) {
      bs[i].draw();
    }
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    pr = true;
    
    for(int i=0;i<bs.length;i++) {
      if(bs[i].press_event(mx, my))break;
    }
    return true;
  }
  
  boolean release_event(int mx, int my) {
    pr = false;
    if(!this.inside(mx, my))return false;
    return true;
  }
  
}

class GButton extends Box { // Gui_Button
  Gui g;
  int t; // type
  int cs; // content_size
  boolean pr; // pressed
  
  GButton(Gui g, int t, int px, int py) {
    this.g = g;
    
    this.t = t;
    p = new IVector(px, py);
    s = new IVector(0);
    set_cs(12);
    
    pr = false;
    
  }
  
  int px(int px) {return g.px(px)-p.x;}
  int py(int py) {return g.py(py)-p.y;}
  
  int cx(int cx) {return g.cx(cx+p.x);}
  int cy(int cy) {return g.cy(cy+p.y);}
  
  void draw() {
    if(pr) {
      tint(0, 255, 0);
      pr = false;
    }else if(this.selected())tint(255, 0, 0);
    image(g.e.bt_img, cx(0), cy(0), s.x, s.y);
    noTint();
    
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    text(g.ct[t], cx(0)+s.x*.5, cy(0)+s.y*.5);
    
    if(g.e.d)area();
  }
  
  void set_t(int t) {
    this.t = t;
    s.x = (this.cs/3*2+2)*g.ct[this.t].length();
  }
  
  void set_cs(int cs) {
    this.cs = cs;
    s.x = (this.cs/3*2+2)*g.ct[t].length();
    s.y = this.cs+5;
  }
  
  boolean selected() {
    boolean r = false;
    switch(t) {
      case 4:r=(g.e.ml.ls.tt==0);break; // pen
      case 5:r=(g.e.ml.ls.tt==1);break; // eraser
      case 6:r=(g.e.ml.ls.tt==2);break; // select
      case 7:r=!g.e.ml.ls.et;break; // mask
      default:/*r=inside(mouseX, mouseY);*/break; // other
    }
    return r;
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    pr = true;
    
    switch(t) {
      case 0:g.e.ml.ls.import_file();break; // import
      case 1:g.e.ml.ls.save();break; // save
      case 2:g.e.ml.add_layer();break; //add_l
      case 3:g.e.ml.ls.fill_layer();break; // fill
      case 4:g.e.ml.ls.tt=0;break; // pen
      case 5:g.e.ml.ls.tt=1;break; // eraser
      case 6:g.e.ml.ls.tt=2;break; // select
      case 7:g.e.ml.ls.et=!g.e.ml.ls.et;break; // mask
      default:break;
    }
    
    return true;
  }
  
}