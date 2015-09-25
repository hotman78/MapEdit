
class MEditor extends Box {
  int c; // chip_size
  boolean d; //debug
  
  Gui g;
  SideBar sb;
  MapLayer ml;
  Input i;
  
  PImage bt_img;
  
  boolean pr; // mouse_press
  
  MEditor() {
    c = 16;
    d = false;
    
    p = new IVector(0, 0);
    s = new IVector(width, height); // 720, 500
    
    bt_img = loadImage("btn_img.png");
    
    g = new Gui(this);
    sb = new SideBar(this);
    ml = new MapLayer(this);
    i = new Input(this);
    
  }
  
  void update() {
    ml.update();
    sb.update();
    g.update();
    
  }
  
  void draw() {
    ml.draw();
    sb.draw();
    g.draw();
    
    if(this.d)area();
  }
  
  void mousePressed(){
    if(!i.md) {
      if(sb.press_event(mouseX, mouseY)) {}
      else if(g.press_event(mouseX, mouseY)) {}
      else if(ml.press_event(mouseX, mouseY)) {}
      
    }
    i.mousePressed();
    
  }
  
  void mouseReleased(){
    if(i.md) {
      if(sb.release_event(mouseX, mouseY)) {}
      else if(g.release_event(mouseX, mouseY)) {}
      else if(ml.release_event(mouseX, mouseY)) {}
      
    }
    i.mouseReleased();
    
  }
  
  void mouseWheel(int delta){
    if(sb.wheel_event(delta)) {}
    //i.mouseWheel(delta);
    
  }
  
  void keyPressed(){
    i.keyPressed();
    
  }
  
  void keyReleased(){
    if(ml.key_release_event(mouseX, mouseY)) {}
    i.keyReleased();
    
  }
  
  String[] input(IVector s, int n, String title, String[] lab, String[] def) {
    JPanel panel = new JPanel();
    panel.setPreferredSize(new Dimension(s.x, s.y));
    panel.setLayout(null);
    
    JTextField[] text = new JTextField[n];
    
    for(int i=0;i<n;i++) {
      text[i] = new JTextField(def[i]);
      panel.add(new JLabel(lab[i]));
      text[i].setBounds(10, 10, 60, 30);
      panel.add(text[i]);
    }
    
    JOptionPane.showConfirmDialog( null, panel, title, JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE );
    
    String[] res = new String[n];
    
    for(int i=0;i<n;i++) {
      try{
        res[i] = text[i].getText();
      }catch(NullPointerException e){
        res[i] = "";
      }
    }
    
    return res;
  }
  
  boolean alert(String str) { //このクラスはjavaで作られてます
    int r = JOptionPane.showConfirmDialog( null, str, "alert", JOptionPane.OK_CANCEL_OPTION, JOptionPane.WARNING_MESSAGE );
    return (r==JOptionPane.OK_OPTION);
    
  }
  
  String importImage(){
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch (Exception e) {
      e.printStackTrace();
    }
    JFileChooser chooser = new JFileChooser("./");
    JFrame frame=new JFrame();
    chooser.setDialogTitle("画像をインポートする");
    FileNameExtensionFilter filter = new FileNameExtensionFilter(
        "画像ファイル(*.png,*.jpeg,*.jpg)", "png","jpeg","jpg");
    chooser.setFileFilter(filter);
    int selected = chooser.showOpenDialog(frame);
    if (selected == JFileChooser.APPROVE_OPTION){
      File file = chooser.getSelectedFile();
      println(file.getPath());
      return file.getPath();
    }else if (selected == JFileChooser.CANCEL_OPTION){
      println("キャンセルされました");
      return null;
    }else if (selected == JFileChooser.ERROR_OPTION){
      println("エラー又は取消しがありました");
      return "null";
    }
    return null;

  }
}