
class SideBar extends Box {
  MEditor e;
  
  Chip cp;
  Material mat;
  
  SideBar(MEditor e) {
    this.e = e;
    
    p = new IVector(e.s.x-e.c*10, 0); // e.c*10);
    s = new IVector(e.c*10, e.s.y); // -e.c*10);
    
    mat = new Material(this);
    cp = new Chip(this);
    
  }
  
  void update() {
    cp.update();
    mat.update();
    
  }
  
  int px(int px) {return e.px(px)-p.x;}
  int py(int py) {return e.py(py)-p.y;}
  
  int cx(int cx) {return e.cx(cx+p.x);}
  int cy(int cy) {return e.cy(cy+p.y);}
  
  void draw() {
    cp.draw();
    mat.draw();
    
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(mat.press_event(mx, my)) {}
    
    return true;
  }
  
  boolean release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(mat.release_event(mx, my)) {}
    
    return true;
  }
  
  boolean wheel_event(int delta) {
    if(!inside(mouseX, mouseY))return false;
    
    if(cp.wheel_event(delta)) {}
    else if(mat.wheel_event(delta)) {}
    
    return true;
    
  }
  
}

class Chip extends ImgDisp {
  SideBar sb;
  
  Chip(SideBar sb) {
    this.sb = sb;
    
    p = new IVector(sb.e.c);
    s = new IVector(sb.e.c*8);
    
    ss = 4;
    a = new IVector(0);
    ms = new IVector(sb.e.c);
    
  }
  
  int px(int px) {return sb.px(px)-p.x;}
  int py(int py) {return sb.py(py)-p.y;}
  
  int cx(int cx) {return sb.cx(cx+p.x);}
  int cy(int cy) {return sb.cy(cy+p.y);}
  
  void update() {
    if(!inside(mouseX, mouseY))return ;
    this.scroll(sb.e.i);
    this.limit();
  }
  
  void draw() {
    img.draw((Box)this, a);
    noFill();
    stroke(255);
    ((Box)this).box();
    
    if(sb.e.d)area();
  }
  
}

class Material extends ImgDisp {
  SideBar sb;
  
  IVector pm; // mouse_position
  boolean pr; // mouse_press
  
  Material(SideBar sb) {
    this.sb = sb;
    
    p = new IVector(0, sb.s.x);
    s = new IVector(sb.s.x, sb.s.y-sb.s.x);
    
    pm = new IVector(0);
    
    ss = 18;
    a = new IVector(0);
    ms = new IVector(0, s.y/3);
    
    pr = false;
    
    img = new EImage();
    img.set_img(loadImage("base_img.png"));
    this.limit();
    
  }
  
  int px(int px) {return sb.px(px)-p.x;}
  int py(int py) {return sb.py(py)-p.y;}
  
  int cx(int cx) {return sb.cx(cx+p.x);}
  int cy(int cy) {return sb.cy(cy+p.y);}
  
  int mx(int px) {return (px(px+a.x)/sb.e.c)-(px(px+a.x)<0?1:0);}
  int my(int py) {return (py(py+a.y)/sb.e.c)-(py(py+a.y)<0?1:0);}
  
  IVector mp(int mx, int my) {return new IVector(mx(mx), my(my));}
  
  void update() {
    if(!inside(mouseX, mouseY))return ;
    this.scroll(sb.e.i);
    this.limit();
  }
  
  void draw() {
    img.draw((Box)this, a);
    
    stroke(255);
    fill(0, 204, 255, 100);
    if(pr) {
      if(sb.e.i.mb(LEFT)) {
        IVector xp = mp(mouseX, mouseY),ip = mp(mouseX, mouseY);
        xp.max(pm);
        ip.min(pm);
        cp(ip.mult(sb.e.c)).sub(a).box(xp.sub(ip).add(1).mult(sb.e.c));
      }
    }
    
    if(sb.e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    pr = true;
    
    pm.set(mx(mouseX), my(mouseY));
    sb.e.ml.ls.set_chip(img, pm, new IVector(1));
    
    return true;
  }
  
  boolean release_event(int mx, int my) {
    pr = false;
    if(!this.inside(mx, my))return false;
    
    if(sb.e.i.mb(LEFT)) {
      IVector mp = mp(mouseX, mouseY).max(pm);
      pm.min(mp(mouseX, mouseY));
      
      sb.e.ml.ls.set_chip(img, pm, mp.sub(pm).add(1));
    }
    
    return true;
  }
  
}