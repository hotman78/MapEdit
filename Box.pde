
class Box {
  IVector p, s;
  
  Box() {}
  
  boolean inside(int px, int py) {
    return px(px)>0 && px(px)<s.x && py(py)>0 && py(py)<s.y;
  }
  
  int px(int px) {return px-p.x;}
  int py(int py) {return py-p.y;}
  
  int cx(int cx) {return cx+p.x;}
  int cy(int cy) {return cy+p.y;}
  
  IVector pp(int px,int py) {return new IVector(px(px), py(py));}
  IVector cp(int cx,int cy) {return new IVector(cx(cx), cy(cy));}
  
  IVector pp(IVector p) {return this.pp(p.x, p.y);}
  IVector cp(IVector c) {return this.cp(c.x, c.y);}
  
  void area() {
    noFill();
    stroke(255);
    this.box();
  }
  
  void box() {
    cp(0, 0).box(s);
  }
  
}

class IVector { // int_vector
  int x, y;
  
  IVector(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  IVector(int v) {
    this.x = v;
    this.y = v;
  }
  
  IVector get() {
    return new IVector(this.x, this.y);
  }
  
  IVector set(int x, int y) {
    this.x = x;
    this.y = y;
    return this;
  }
  
  IVector add(int ax, int ay) {
    this.x += ax;
    this.y += ay;
    return this;
  }
  
  IVector sub(int sx, int sy) {
    this.x -= sx;
    this.y -= sy;
    return this;
  }
  
  IVector mod(int mx, int my) {
    this.x %= mx;
    this.y %= my;
    return this;
  }
  
  IVector scl(int vx, int vy) { // scalar?
    this.x *= vx;
    this.y *= vy;
    return this;
  } //<>//
  
  IVector div(int vx, int vy) {
    this.x /= vx;
    this.y /= vy;
    return this;
  }
  
  boolean equals(int x, int y) {
    return (this.x==x && this.y==y);
  }
  
  IVector set(IVector v) {return this.set(v.x, v.y);}
  IVector add(IVector a) {return this.add(a.x, a.y);}
  IVector sub(IVector s) {return this.sub(s.x, s.y);}
  IVector mod(IVector m) {return this.mod(m.x, m.y);}
  IVector scl(IVector v) {return this.scl(v.x, v.y);}
  IVector div(IVector v) {return this.div(v.x, v.y);}
  boolean equals(IVector v) {return this.equals(v.x, v.y);}
  
  IVector set(int v) {return this.set(v, v);}
  IVector add(int a) {return this.add(a, a);}
  IVector sub(int s) {return this.sub(s, s);}
  IVector mod(int m) {return this.mod(m, m);}
  IVector scl(int v) {return this.scl(v, v);}
  IVector div(int v) {return this.div(v, v);}
  boolean equals(int v) {return this.equals(v, v);}
  
  IVector mult(int v) {
    return this.get().scl(v);
  }
  
  IVector max(IVector v) {
    this.x = (x>v.x?x:v.x);
    this.y = (y>v.y?y:v.y);
    return this;
  }
  
  IVector min(IVector v) {
    this.x = (x<v.x?x:v.x);
    this.y = (y<v.y?y:v.y);
    return this;
  }
  
  void print() {println("x: "+x+", y: "+y);} // debug
  void point() {ellipse(x, y, 2, 2);} // debug
  
  void box(IVector s) {
    rect(this.x, this.y, s.x, s.y);
  }
  
}