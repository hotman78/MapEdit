
class ImgDisp extends Box {
  EImage img;
  
  int ss; // scroll_speed
  IVector a, ms; // (a.x, a.y) = (0, 0); ms: margin_size
  
  void scroll(Input i) {
    if(i.pk('w') || i.pkc(UP))a.y-=ss;
    if(i.pk('a') || i.pkc(LEFT))a.x-=ss;
    if(i.pk('s') || i.pkc(DOWN))a.y+=ss;
    if(i.pk('d') || i.pkc(RIGHT))a.x+=ss;
    
    this.limit();
    
  }
  
  void limit() {
    if(img.wid()+2*ms.x<s.x)a.x=(img.wid()-s.x)/2;
    else if(a.x<-ms.x)a.x=-ms.x;
    else if(a.x>img.wid()+ms.x-s.x)a.x=img.wid()+ms.x-s.x;
    
    if(img.hei()+2*ms.y<s.y)a.y=(img.hei()-s.y)/2;
    else if(a.y<-ms.y)a.y=-ms.y;
    else if(a.y>img.hei()+ms.y-s.y)a.y=img.hei()+ms.y-s.y;
    
  }
  
  boolean wheel_event(int delta) {
    if(!inside(mouseX, mouseY))return false;
    a.y += delta*ss;
    this.limit();
    return true;
    
  }
  
}

class EImage {
  PImage l;
  
  EImage() {}
  
  void set_size(IVector s) {
    l = createImage(s.x, s.y, ARGB);
  }
  
  void set_img(PImage l) {
    this.l = l;
  }
  
  color get(IVector p) {
    return this.l.get(p.x, p.y);
  }
  
  PImage get(IVector p, IVector s) {
    return this.l.get(p.x, p.y, s.x, s.y);
  }
  
  int wid() {
    return this.l.width;
  }
  
  int hei() {
    return this.l.height;
  }
  
  void load() {
    this.l.loadPixels();
  }
  
  void update() {
    this.l.updatePixels();
  }
  
  void set(int i, color c) {
    //if(!(i<0) && i<wid()*hei())
    this.l.pixels[i] = c;
  }
  
  void set(int i, int j, color c) {
    //if( (!(i<0) && i<wid()) && (!(j<0) && i<hei()) )
    this.set(i+j*wid(), c);
  }
  
  void draw(Box b) {
    image(l.get(0, 0, min(wid(), b.s.x), min(hei(), b.s.y)), b.cx(0), b.cy(0));
  }
  
  void draw(Box b, IVector a) {
    image(
    l.get(a.x, a.y, 
    min(wid()-a.x, b.s.x), 
    min(hei()-a.y, b.s.y)), 
    b.cx(0), b.cy(0));
  }
  
  void paint_pimg(PImage mat, IVector s) {
    this.load();
    mat.loadPixels();
    int w=mat.width, h=mat.height;
    for(int i=max(0, -s.x);i<min(w, wid()-s.x);i++) {
      for(int j=max(0, -s.y);j<min(h, hei()-s.y);j++) {
        this.set(i+s.x, j+s.y, mat.pixels[i+j*w]);
      }
    }
    this.update();
    mat.updatePixels();
  }
  
  void fill_pimg(PImage mat) {
    this.load();
    mat.loadPixels();
    int w=mat.width, h=mat.height;
    for(int i=0;i<wid();i++) {
      for(int j=0;j<hei();j++) {
        this.set(i, j, mat.pixels[i%w+(j%h)*w]);
      }
    }
    this.update();
    mat.updatePixels();
    
  }
  
  //void paint_img(EImage mat, IVector s) {paint_pimg(mat.l, s);}
  //void fill_img(EImage mat) {fill_pimg(mat.l);}
  
  void fill_color(color col) {
    this.load();
    for(int i=0;i<wid()*hei();i++) {
        this.set(i, col);
    }
    this.update();
  }
  
  void paint_color(color col, IVector st, IVector sz) {
    this.load();
    for(int i=max(0, st.x);i<min(st.x+sz.x, wid());i++) {
      for(int j=max(0, st.y);j<min(st.y+sz.y, hei());j++) {
        this.set(i, j, col);
      }
    }
    this.update();
  }
  
}