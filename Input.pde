
class Input {
  MEditor e;
  
  boolean kw, ka, ks, kd, kz;
  boolean kup, kdown, kleft, kright, kshift, kbs;
  boolean md, mbr, mbl;
  
  Input(MEditor e) {
    this.e = e;
    
    kw = false;
    ka = false;
    ks = false;
    kd = false;
    kz = false;
    
    kup = false;
    kdown = false;
    kleft = false;
    kright = false;
    kshift = false;
    kbs = false;
    
    md = false;
    
  }
  
  boolean pk(char k) { // pressed_key
    boolean r = false;
    switch(k) {
      case 'w':r=kw;break;
      case 'a':r=ka;break;
      case 's':r=ks;break;
      case 'd':r=kd;break;
      case 'z':r=kz;break;
      default:break;
    }
    return r;
  }
  
  boolean pkc(int k) { // pressed_keyCode
    boolean r = false;
    switch(k) {
      case UP:r=kup;break;
      case DOWN:r=kdown;break;
      case LEFT:r=kleft;break;
      case RIGHT:r=kright;break;
      case SHIFT:r=kshift;break;
      case BACKSPACE:r=kbs;break;
      default:break;
    }
    return r;
  }
  
  void sk(char k, boolean t) { // set_key
    switch(k) {
      case 'w':kw=t;break;
      case 'a':ka=t;break;
      case 's':ks=t;break;
      case 'd':kd=t;break;
      case 'z':kz=t;break;
      default:break;
    }
  }
  
  void skc(int k, boolean t) { // set_keyCode
    switch(k) {
      case UP:kup=t;break;
      case DOWN:kdown=t;break;
      case LEFT:kleft=t;break;
      case RIGHT:kright=t;break;
      case SHIFT:kshift=t;break;
      case BACKSPACE:kbs=t;break;
      default:break;
    }
  }
  
  void keyPressed() {
    if(key==CODED) {
      skc(keyCode, true);
    }else {
      sk(key, true);
    }
    
  }
  
  void keyReleased() {
    if(key==CODED) {
      skc(keyCode, false);
    }else {
      sk(key, false);
    }
    
  }
  
  void mousePressed() {
    if(!md)md = true;
  }
  
  void mouseReleased() {
    if(md)md = false;
    
  }
  
  boolean mb(int v) {
    return (mouseButton==v);
  }
  
  //void mouseWheel(int delta) {}
  
}