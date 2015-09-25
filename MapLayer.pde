
class MapLayer extends Box {
  MEditor e;
  
  Layers ls;
  ArrayList<LButton> lb;
  
  IVector bp; //button_pos
  int n;
  
  MapLayer(MEditor e) {
    this.e = e;
    
    p = new IVector(0, 33);
    s = new IVector(e.s.x-160, e.s.y-33);
    
    n = 0;
    ls = new Layers(this, layer_size()); // set m.x, m.y
    lb = new ArrayList<LButton>();
    bp = new IVector(8, 0);
    for(int i=0;i<3;i++) {
      add_layer();
    }
    
  }
  
  int px(int px) {return e.px(px)-p.x;}
  int py(int py) {return e.py(py)-p.y;}
  
  int cx(int cx) {return e.cx(cx+p.x);}
  int cy(int cy) {return e.cy(cy+p.y);}
  
  void add_layer() {
    Layer l = new Layer(ls);
    LButton b = new LButton(this, l, n, bp);
    
    ls.ls.add(l);
    lb.add(b);
    
    bp.x += b.s.x;
    n++;
  }
  
  void del_layer() {
    LButton button=null;
    for(int i=0;i<lb.size();i++){
      if(lb.get(i).selected())button=lb.get(i);
    }
    if(button==null)return;
    if (nl()<=1 || !e.alert("delete ' "+button.get_ct()+" ' ?"))return ;
    
    if(ls.now > button.get_n())ls.now--;
    for(int i=button.get_n()+1;i<nl();i++) {
      lb.get(i).p.x -= button.s.x;
    }
    bp.x -= button.s.x;
    
    Layer l = button.l;
    ls.ls.remove(l);
    lb.remove(button);
    
    //n--;
  }
  
  int nl() { // number_of_layer
    return lb.size();
  }
  
  void draw() {
    for(int i=0;i<nl();i++) {
      lb.get(i).draw();
    }
    ls.draw();
    
    if(e.d)area();
  }
  
  void update() {
    ls.update();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(ls.press_event(mx, my)) {
    }else {
      for(int i=0;i<nl();i++) {
        if(lb.get(i).press_event(mx, my))break;
      }
    }
    
    return true;
  }
  
  boolean release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(ls.release_event(mx, my)) {}
    
    return true;
  }
  
  boolean key_release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(ls.key_release_event(mx, my)) {
    }else {
      for(int i=0;i<nl();i++) {
        if(lb.get(i).key_release_event(mx, my))break;
      }
    }
    
    return true;
  }
  
  IVector layer_size() {
    JPanel panel = new JPanel();
    panel.setPreferredSize(new Dimension(150, 60));
    panel.setLayout(null);
    
    JTextField[] text = new JTextField[2];
    
    text[0] = new JTextField("50");
    panel.add(new JLabel("X"));
    text[0].setBounds(10, 10, 60, 30);
    panel.add(text[0]);
    
    text[1] = new JTextField("50");
    panel.add(new JLabel("Y"));
    text[1].setBounds(80, 10, 60, 30);
    panel.add(text[1]);
    
    JOptionPane.showConfirmDialog( null, panel, "layer size", JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE );
    
    String[] r = new String[text.length];
    for(int i=0;i<text.length;i++) {
      try {
        r[i] = text[i].getText();
      } catch(NullPointerException e) {
        r[i] = "";
      }
    }
    
    IVector s = new IVector(0);
    s.set(int(r[0]), int(r[1]));
    return s.set(s.x==0?50:s.x, s.y==0?50:s.y);
    
  }
  
}

class Layers extends ImgDisp {
  MapLayer ml;
  
  IVector cs; // canvas_size (chip)
  
  ArrayList<Layer> ls;
  
  int now;
  
  Layer chip;
  PImage mat;
  
  boolean et; //  eidt_type: true: layer, false: mask(img);
  int tt; // tool_type 0: pen(white), 1: eraser(black), 2: select
  IVector pm; // p_mouse
  
  EImage bg_img;
  // img is mask
  
  boolean pr; // mouse_press
  
  Layers(MapLayer ml, IVector cs) {
    this.ml = ml;
    
    p = new IVector(8, 25);
    this.cs = cs;
    s = new IVector(34*ml.e.c, 25*ml.e.c);
    
    ss = 10;
    a = new IVector(0);
    ms = new IVector(2*s.x/3, 2*s.y/3);
    
    et = true;
    tt = 0;
    
    pm = new IVector(0);
    
    ls = new ArrayList<Layer>();
    this.now=0;
    
    chip = new Layer(this, new IVector(1, 1));
    ml.e.sb.cp.img = chip;
    set_chip(ml.e.sb.mat.img, new IVector(0), new IVector(1));
    
    bg_img = new EImage();
    bg_img.set_size(this.s);
    bg_img.fill_pimg(loadImage("./data/bg_img.png"));
    
    img = new EImage();
    img.set_size(this.cs.mult(ml.e.c));
    img.fill_color(color(0));
    
    pr = false;
    
    this.limit();
    
  }
  
  int px(int px) {return ml.px(px)-p.x;}
  int py(int py) {return ml.py(py)-p.y;}
  
  int cx(int cx) {return ml.cx(cx+p.x);}
  int cy(int cy) {return ml.cy(cy+p.y);}
  
  int mx(int px) {return (px(px+a.x)/ml.e.c)-(px(px+a.x)<0?1:0);}
  int my(int py) {return (py(py+a.y)/ml.e.c)-(py(py+a.y)<0?1:0);}
  
  int sx(int px) {return px-(chip.cs.x-1)*ml.e.c/2;}
  int sy(int py) {return py-(chip.cs.y-1)*ml.e.c/2;}
  
  IVector mp(int px, int py) {return new IVector(mx(px), my(py));}
  IVector msp(int px, int py) {return this.mp(sx(px), sy(py));}
  
  Layer get_layer(int i) {
    if(!(i<0) && i<ml.nl())return ls.get(i);
    else return null;
  }
  
  int nl() { // number_of_layer
    return ls.size();
  }
  
  void set_chip(Layer mat, IVector ps, IVector s) {
    chip.cs = s;
    chip.reset();
    for(int i=0;i<s.x;i++) {
      for(int j=0;j<s.y;j++) {
        if( (i+ps.x<0) || (j+ps.y<0) || 
        (i+ps.x>=mat.cs.y) || (j+ps.y>=mat.cs.y) )chip.t[i][j] = -1;
        chip.t[i][j] = mat.t[i+ps.x][j+ps.y];
      }
    }
    chip.paint_pimg(mat.get(ps.mult(ml.e.c), s.mult(ml.e.c)), new IVector(0));
    ml.e.sb.cp.a.set(0);
    ml.e.sb.cp.limit();
  }
  
  void set_chip(EImage mat, IVector ps, IVector s) {
    chip.cs = s;
    chip.reset();
    for(int i=0;i<s.x;i++) {
      for(int j=0;j<s.y;j++) {
        chip.t[i][j] = (i+ps.x)+(mat.wid()/ml.e.c)*(j+ps.y);
      }
    }
    chip.paint_pimg(mat.get(ps.mult(ml.e.c), s.mult(ml.e.c)), new IVector(0));
    ml.e.sb.cp.a.set(0);
    ml.e.sb.cp.limit();
  }
  
  boolean tt(int v) {
    return (tt==v);
  }
  
  void update() {
    if(!inside(mouseX, mouseY))return ;
    
    if(pr&&(tt(0)||tt(1))) { // edit(pen, eraser)
      IVector mp = msp(mouseX, mouseY);
      if(et) {
        if(tt(0)) {
          if(ml.e.i.pk('z') && !pm.equals(mp)) {
            get_layer(now).paint(chip, mp);
            pm.set(mp);
          }else {
            mp = mp(mouseX, mouseY);
            IVector ck = mp.get().sub(pm).div(chip.cs);
            ck.sub(ck.x==0&&mp.x<pm.x?1:0, ck.y==0&&mp.y<pm.y?1:0);
            mp.print();
            if(!ck.equals(0)) {
              mp.set(ck.scl(chip.cs).add(pm));
              get_layer(now).paint(chip, mp);
              pm.set(mp);
            }
          }
        }else if(!pm.equals(mp)) {
          get_layer(now).erase(mp, chip.cs);
          pm.set(mp);
        }
      }else if(!pm.equals(mp)) {
        img.paint_color(tt==0?color(255):color(0), mp.mult(ml.e.c), chip.cs.mult(ml.e.c));
        pm.set(mp);
      }
    }
    
    this.scroll(ml.e.i);
    this.limit();
    
  }
  
  void draw() {
   bg_img.draw((Box)this);
    if(!et) {
      img.draw((Box)this, a);
      tint(255, 100);
    }
    for(int i=0;i<nl();i++){
      if(get_layer(i).disp)get_layer(i).draw((Box)this, a);
    }
    noTint();
    
    noFill();stroke(0);
    rect(cx(-a.x), cy(-a.y), cs.x*ml.e.c, cs.y*ml.e.c);
    
    if(inside(mouseX, mouseY)) {
      if(pr && tt(2)) {
        IVector xp = mp(mouseX, mouseY), ip = mp(mouseX, mouseY);
        xp.max(pm);
        ip.min(pm);
        
        stroke(tt==0?255:0);
        fill(0, 204, 255, 100);
        cp(ip.mult(ml.e.c)).sub(a).box(xp.sub(ip).add(1).mult(ml.e.c));
        
      }else {
        Box mc = new Box(); // mouse_cursor
        if(tt<2) {
          mc.p = cp(msp(mouseX, mouseY).mult(ml.e.c).sub(a));
          mc.s = chip.cs.mult(ml.e.c);
        }else {
          mc.p = cp(mp(mouseX, mouseY).mult(ml.e.c).sub(a));
          mc.s = new IVector(ml.e.c);
        }
        
        if(et && tt(0)) {
          tint(255, 156);
          chip.draw(mc);
          noTint();
        }
        
        switch(tt) {
          case 0:stroke(255);break;
          case 1:stroke(0);break;
          case 2:stroke(0,204,255);break;
          default:stroke(255,0,0);break;
        }
        fill(0, 204, 255, 100);
        mc.box();
        
      }
      
      if(ml.e.d) {
        textAlign(RIGHT, TOP);textSize(12);fill(255);
        text("X: "+mx(mouseX)+" Y: "+my(mouseY), cx(s.x), cy(s.y));
      }
      
    }
    
    if(ml.e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    pr = true;
    
    if(tt(0)||tt(1)) {
      pm = msp(mouseX, mouseY);
      if(et && tt==0)get_layer(now).paint(chip, pm);
      else if(et)get_layer(now).erase(pm, chip.cs);
      else img.paint_color(tt==0?color(255):color(0), pm.mult(ml.e.c), chip.cs.mult(ml.e.c));
    }else if(tt==2) {
      pm = mp(mouseX, mouseY);
    }
    
    return true;
  }
  
  boolean release_event(int mx, int my) {
    pr = false;
    if(!this.inside(mx, my))return false;
    
    if(tt(2)) {
      Layer l = get_layer(now);
      IVector xp = mp(mx, my), ip = mp(mx, my); //<>//
      xp.max(pm);
      ip.min(pm);
      
      set_chip(l, ip, xp.sub(ip).add(1));
    }
    
    return true;
  }
  
  boolean key_release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    if(!pr&&key=='f')auto_fill(mp(mx, my));
    return true;
  }
  
  void auto_fill(IVector sp) {
    if(!tt(0)&&!tt(1))return ;
    int[] dx = { 1, 0,-1, 0}, dy = { 0, 1, 0,-1};
    boolean[][] t = new boolean[cs.x][cs.y];
    for(int i=0;i<cs.x;i++){for(int j=0;j<cs.y;j++){
      t[i][j] = false;
    }}
    ArrayList<IVector> que = new ArrayList<IVector>();
    que.add(sp.get());
    
    if(et) {
      Layer l = get_layer(now);
      IVector ip = sp.get(), xp = sp.get();
      int v = l.t[sp.x][sp.y];
      while(que.size()>0) {
        IVector q = que.get(0);
        if(!t[q.x][q.y] && l.t[q.x][q.y]==v) {
          t[q.x][q.y] = true;
          if(q.x<ip.x)ip.x=q.x;
          else if(q.x>xp.x)xp.x=q.x;
          if(q.y<ip.y)ip.y=q.y;
          else if(q.y>xp.y)xp.y=q.y;
          for(int i=0;i<dx.length;i++) {
            IVector dn = q.get().add(dx[i], dy[i]);
            if(dn.x<0 || dn.y<0 || dn.x>=cs.x || dn.y>=cs.y)continue;
            que.add(dn);
          }
        }
        que.remove(q);
      }
      
      for(int i=ip.x;i<=xp.x;i++) {for(int j=ip.y;j<=xp.y;j++) {
        if(t[i][j]) {
          IVector cp = new IVector(i, j);
          if(tt==0) {
            cp.sub(ip);
            cp.mod(chip.cs);
            l.t[i][j] = chip.t[cp.x][cp.y];
            cp.scl(ml.e.c);
            l.paint_pimg(chip.get(cp, new IVector(ml.e.c)), (new IVector(i, j)).scl(ml.e.c));
          }else {
            l.t[i][j] = -1;
            l.paint_color(color(0, 0), cp.mult(ml.e.c), new IVector(ml.e.c));
          }
        }
      }}
      
    }else {
      IVector ip = sp.get(), xp = sp.get();
      color v = img.get(sp.mult(ml.e.c));
      while(que.size()>0) {
        IVector q = que.get(0);
        if(!t[q.x][q.y] && img.get(q.mult(ml.e.c))==v) {
          t[q.x][q.y] = true;
          if(q.x<ip.x)ip.x=q.x;
          else if(q.x>xp.x)xp.x=q.x;
          if(q.y<ip.y)ip.y=q.y;
          else if(q.y>xp.y)xp.y=q.y;
          for(int i=0;i<dx.length;i++) {
            IVector dn = q.get().add(dx[i], dy[i]);
            if(dn.x<0 || dn.y<0 || dn.x>=cs.x || dn.y>=cs.y)continue;
            que.add(dn);
          }
        }
        que.remove(q);
      }
      
      for(int i=ip.x;i<=xp.x;i++) {for(int j=ip.y;j<=xp.y;j++) {
          IVector cp = new IVector(i, j);
          if(t[i][j])img.paint_color(tt==0?color(255):color(0), cp.mult(ml.e.c), new IVector(ml.e.c, ml.e.c));
      }}
      
    }
    
  }
  void import_file() { // import
    //ml.add_layer();
    String Path=meditor.importImage();
    if(Path!=null)get_layer(nl()-1).paint_pimg(loadImage(Path), new IVector(0, 0));
    //img.paint_pimg(loadImage("./data/o/mask.png"), new IVector(0, 0));
  }
  
  void fill_layer() {
    if(!tt(0)&&!tt(1))return ;
    if(et) {
      if(tt==0)ls.get(now).paint_all(chip);
      else ls.get(now).erase_all();
    }else {
      img.fill_color(tt==0?color(255):color(0));
    }
  }
  
  void save() {
    if(!ml.e.alert("Do you want to save?"))return ;
    PGraphics sl = createGraphics(cs.x*ml.e.c, cs.y*ml.e.c); //save_layer
    sl.beginDraw();
    //sl.background(0);
    for(int i=0;i<nl();i++) {
      if(get_layer(i).disp)sl.image(get_layer(i).l, 0, 0);
    }
    sl.endDraw();
    
    sl.get().save("./data/o/layer.png");
    img.l.get().save("./data/o/mask.png");
    //exit();
  }
  
}

class Layer extends EImage {
  Layers ls;
  IVector cs; // chip_size
  int[][] t; // chip_type
  boolean disp;
  
  Layer(Layers ls) {
    this.ls = ls;
    this.cs = ls.cs;
    reset();
    disp = true;
  }
  
  Layer(Layers ls, IVector cs) {
    this.ls = ls;
    this.cs = cs;
    reset();
    disp = true;
  }
  
  void reset() {
    l = createImage(cs.x*ls.ml.e.c, cs.y*ls.ml.e.c, ARGB);
    this.t = new int[cs.x][cs.y];
    for(int i=0;i<cs.x;i++) {
      for(int j=0;j<cs.y;j++) {
        t[i][j] = -1;
      }
    }
  }
  
  void paint(Layer mat, IVector s) {
    for(int i=max(0, -s.x);i<min(mat.cs.x, cs.x-s.x);i++) {
      for(int j=max(0, -s.y);j<min(mat.cs.y, cs.y-s.y);j++) {
        this.t[s.x+i][s.y+j] = mat.t[i][j];
      }
    }
    paint_pimg(mat.l, s.mult(ls.ml.e.c));
  }
  
  void erase(IVector s, IVector sz) {
    for(int i=max(0, -s.x);i<min(sz.x, cs.x-s.x);i++) {
      for(int j=max(0, -s.y);j<min(sz.y, cs.y-s.y);j++) {
        this.t[s.x+i][s.y+j] = -1;
      }
    }
    paint_color(color(0, 0), s.mult(ls.ml.e.c), sz.mult(ls.ml.e.c));
  }
  
  void paint_all(Layer mat) {
    for(int i=0;i<cs.x;i++) {
      for(int j=0;j<cs.y;j++) {
        this.t[i][j] = mat.t[i%mat.cs.x][j%mat.cs.y];
      }
    }
    fill_pimg(mat.l);
  }
  
  void erase_all() {
    for(int i=0;i<cs.x;i++) {
      for(int j=0;j<cs.y;j++) {
        this.t[i][j] = -1;
      }
    }
    fill_color(color(0, 0));
  }
  
}

class LButton extends Box { // MapLayer_Button
  MapLayer ml;
  Layer l;
  
  int n; // number
  int cs; // content_size
  //boolean pr; // pressed
  
  LButton(MapLayer ml, Layer l, int n, IVector ps) {
    this.ml = ml;
    this.l = l;
    this.n = n;
    
    p = new IVector(ps.x, ps.y);
    s = new IVector(0, 0);
    set_cs(12);
    
  }
  
  int px(int px) {return ml.px(px)-p.x;}
  int py(int py) {return ml.py(py)-p.y;}
  
  int cx(int cx) {return ml.cx(cx+p.x);}
  int cy(int cy) {return ml.cy(cy+p.y);}
  
  void draw() {
    if(this.selected()) {
      if(!l.disp)tint(156, 0, 0);
      else tint(255, 0, 0);
    }else if(!l.disp) {
      tint(156);
    }
    image(ml.e.bt_img, cx(0), cy(0), s.x, s.y);
    noTint();
    
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    text(get_ct(), cx(s.x/2), cy(s.y/2));
    
    if(ml.e.d)area();
  }
  
  void set_cs(int cs) {
    this.cs = cs;
    s.x = (this.cs/3*2+2)*(get_ct().length());
    s.y = this.cs+5;
  }
  
  boolean selected() {
    return (ml.ls.now==get_n());
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(mouseButton == RIGHT)l.disp = !l.disp;
    else if(mouseButton ==LEFT)ml.ls.now = get_n();
    
    return true;
  }
  
  boolean key_release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    //if(keyCode==BACKSPACE)ml.del_layer(this);
    return true;
  }
  
  String get_ct() {
    return "layer "+this.n;
  }
  
  int get_n() {
    return ml.ls.ls.indexOf(l);
  }
  
}