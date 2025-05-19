// === 1.  Setup Iniziale ===

// 1.1 Importazione librerie
import netP5.*;      // Gestione rete
import oscP5.*;      // Gestione OSC
import controlP5.*;  // Gestione GUI

// 1.2 Dichiarazione oggetti principali
NetAddress sc;
NetAddress py;
OscP5 oscP5;
ControlP5 cp5;

Group oscGroup, envGroup, lfoGroup, fxGroup, joypadGroup;  // Dichiarazione gruppi GUI

// 1.3 Inizializzazione per gli XY Pads
PVector xyPad1Pos, xyPad2Pos;
int padSize = 180;  // Lato quadrato XY
boolean draggingXY1 = false, draggingXY2 = false;
float lastFX3 = 0;  // Reverb
float lastFX4 = 0;  // Delay
float lastFX6 = 0;  // Flanger
float lastFX7 = 0;  // Distortion

 
// 1.4 Inizializzazione GUI
void setup() {
  
  size(1450, 820);
  
  // 1.4.1 Setup
  sc = new NetAddress("127.0.0.1", 57120);
  py = new NetAddress("127.0.0.1", 12001);
  oscP5 = new OscP5(this, 12000);
  cp5 = new ControlP5(this);

  // 1.4.2 Sezioni GUI
  setupOscillators();
  setupEnvelope();
  setupModulation();
  setupFX();
  
}

// 1.5 Gestione Sfondo e Sezioni
void draw() {
  background(255, 253, 240);
  fill(240);
  
  // Oscillators 
  fill(235, 220, 180);
  noStroke();
  rect(10, 10, 440, 380);
  fill(0);
  
  // Envelope
  fill(255, 180, 180);
  noStroke();
  rect(460, 10, 480, 180);
  fill(0);
  
  // Modulation
  fill(200, 180, 255);
  noStroke();
  rect(460, 200, 480, 190);
  fill(0);
  
  // FX 
  fill(170, 220, 170);
  noStroke();
  rect(10, 400, 1400, 410);
  fill(0);
  
  // XY PAD 1: Delay (X) + Reverb (Y)
  drawXYPad(140, 550, "Delay + Reverb", xyPad1Pos);

  // XY PAD 2: Distortion (X) + Flanger (Y)
  drawXYPad(1100, 550, "Distortion + Flanger", xyPad2Pos);

}

// === 2. Funzioni Setup GUI ===

// 2.1 Oscillators
void setupOscillators() {
  
  oscGroup = cp5.addGroup("Oscillators");

  String[] waveNames = {"Sine", "Saw", "Square", "LFTri", "LFSaw", "Blip"};
  
  for (int i = 0; i < 3; i++) {
    int y0 = 20 + i * 100;

    cp5.addDropdownList("waveform" + (i + 1))
      .setPosition(20, y0)
      .setSize(120, 80)
      .setItems(waveNames)
      .setGroup(oscGroup)
      .setLabel("Wave " + (i + 1))
      .setColorBackground(color(205, 180, 140))
      .setColorForeground(color(180, 125, 85))
      .setColorActive(color(180, 125, 85));

    cp5.addKnob("level" + (i + 1))
      .setPosition(210, y0 + 10)
      .setRadius(30)
      .setRange(0, 1)
      .setValue(0.3)
      .setGroup(oscGroup)
      .setLabel("Level")
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setColorBackground(color(205, 180, 140))
      .setColorForeground(color(180, 125, 85))
      .setColorActive(color(180, 125, 85));

    cp5.addKnob("octave" + (i + 1))
      .setPosition(320, y0 + 10)
      .setRadius(30)
      .setRange(-2, 2)
      .snapToTickMarks(true)
      .setNumberOfTickMarks(4)
      .setValue(0)
      .setGroup(oscGroup)
      .setLabel("Octave")
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setColorBackground(color(205, 180, 140))
      .setColorForeground(color(180, 125, 85))
      .setColorActive(color(180, 125, 85));
  }
    cp5.addSlider("glide")
    .setPosition(70, 350)
    .setSize(300, 20)
    .setRange(0.5, 2.0)       // da -1 ottava (0.5) a +1 ottava (2.0)
    .setValue(1.0)
    .setGroup(oscGroup)
    .setLabel("Glide Factor")
    .setColorBackground(color(205, 180, 140))
    .setColorForeground(color(150, 110, 60))
    .setColorActive(color(150, 110, 60));
}

// 2.2 Envelope 
void setupEnvelope() {
  
  envGroup = cp5.addGroup("Envelope");
    
  cp5.addSlider("attack")
    .setPosition(480, 40)
    .setSize(70, 120)
    .setRange(0, 5)
    .setValue(0.01)
    .setGroup(envGroup)
    .setLabel("Attack")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));

  cp5.addSlider("decay")
    .setPosition(600, 40)
    .setSize(70, 120)
    .setRange(0, 5)
    .setValue(0.3)
    .setGroup(envGroup)
    .setLabel("Decay")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));

  cp5.addSlider("sustain")
    .setPosition(720, 40)
    .setSize(70, 120)
    .setRange(0, 1)
    .setValue(0.5)
    .setGroup(envGroup)
    .setLabel("Sustain")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));

  cp5.addSlider("release")
    .setPosition(840, 40)
    .setSize(70, 120)
    .setRange(0, 5)
    .setValue(0.3)
    .setGroup(envGroup)
    .setLabel("Release")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));
}

// 2.3 Modulation Setup
void setupModulation() {
  
  lfoGroup = cp5.addGroup("Modulation");

  cp5.addKnob("lfoFreq")
    .setPosition(500, 245)
    .setRadius(45)
    .setRange(0, 20)
    .setValue(0)
    .setGroup(lfoGroup)
    .setLabel("LFO Freq")
    .setDragDirection(ControlP5.VERTICAL)
    .setResolution(-100)
    .setColorBackground(color(150, 140, 225))
    .setColorForeground(color(80, 0, 160))
    .setColorActive(color(80, 0, 160));

  cp5.addKnob("lfoDepth")
    .setPosition(650, 245)
    .setRadius(45)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(lfoGroup)
    .setLabel("LFO Depth")
    .setDragDirection(ControlP5.VERTICAL)
    .setResolution(-100)
    .setColorBackground(color(150, 140, 225))
    .setColorForeground(color(80, 0, 160))
    .setColorActive(color(80, 0, 160));

  cp5.addKnob("cutoff")
    .setPosition(800, 245)
    .setRadius(45)
    .setRange(0, 20)
    .setValue(10)
    .setGroup(lfoGroup)
    .setLabel("Cutoff")
    .setDragDirection(ControlP5.VERTICAL)
    .setResolution(-100)
    .setColorBackground(color(150, 140, 225))
    .setColorForeground(color(80, 0, 160))
    .setColorActive(color(80, 0, 160));
}

// 2.4 FXs Setup
void setupFX() {
  
  fxGroup = cp5.addGroup("FXPads");

  cp5.addSlider("FX3")
    .setPosition(480, 420)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Reverb")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("r_roomsize")
      .setPosition(505, 445)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Room Size");
    
    cp5.addKnob("r_damping")
      .setPosition(585, 445)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Damping");
    
     cp5.addKnob("r_mix")
      .setPosition(505, 515)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Mix");
      
    cp5.addKnob("r_predelay")
      .setPosition(585, 515)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Pre-Delay");

  cp5.addSlider("FX4")
    .setPosition(480, 590)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Delay")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("de_delaytime")
      .setPosition(505, 620)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Delay Time");
    
    cp5.addKnob("de_feedback")
      .setPosition(585, 620)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Feedback");
    
     cp5.addKnob("de_mix")
      .setPosition(545, 690)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Mix");

  cp5.addSlider("FX6")
    .setPosition(735, 420)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Flanger")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("f_rate")
      .setPosition(735, 445)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Rate");
    
    cp5.addKnob("f_depth")
      .setPosition(800, 445)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Depth");
    
     cp5.addKnob("f_delay")
      .setPosition(865, 445)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Delay");
      
    cp5.addKnob("f_feedback")
      .setPosition(767, 515)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Feedback");
      
    cp5.addKnob("f_mix")
      .setPosition(833, 515)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Mix");

  cp5.addSlider("FX7")
    .setPosition(735, 590)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Distortion")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("di_drive")
      .setPosition(760, 620)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Drive");
    
    cp5.addKnob("di_tone")
      .setPosition(840, 620)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Tone");
    
     cp5.addKnob("di_mix")
      .setPosition(760, 690)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Mix");
      
    cp5.addKnob("di_output")
      .setPosition(840, 690)
      .setRadius(25)
      .setRange(0, 1)
      .setValue(0)
      .setGroup(fxGroup)
      .setColorBackground(color(120, 180, 140))
      .setColorForeground(color(20, 100, 20))
      .setColorActive(color(20, 100, 20))
      .setDragDirection(ControlP5.VERTICAL)
      .setResolution(-100)
      .setLabel("Output");
      
    // === Inizializzazione XY Pads ===
    xyPad1Pos = new PVector(140, 550);
    xyPad2Pos = new PVector(1100, 550); 

}

// === 3. Gestione Piani Cartesiani ===
void drawXYPad(int x, int y, String label, PVector pos) {
  // Background pad
  stroke(100);
  fill(color(20, 100, 20));
  rect(x, y, padSize, padSize);
  fill(50);
  textAlign(LEFT);
  text(label, x, y - 5);

  // Croce centrale
  stroke(200);
  line(x + padSize / 2, y, x + padSize / 2, y + padSize);
  line(x, y + padSize / 2, x + padSize, y + padSize / 2);

  // Punto di controllo
  fill(color(120, 180, 140));
  noStroke();
  ellipse(pos.x, pos.y, 14, 14);
}

void mousePressed() {
  if (dist(mouseX, mouseY, xyPad1Pos.x, xyPad1Pos.y) < 20) draggingXY1 = true;
  if (dist(mouseX, mouseY, xyPad2Pos.x, xyPad2Pos.y) < 20) draggingXY2 = true;
}

void mouseReleased() {
  draggingXY1 = false;
  draggingXY2 = false;
}

void mouseDragged() {
  if (draggingXY1) {
    xyPad1Pos.x = constrain(mouseX, 140, 140 + padSize);
    xyPad1Pos.y = constrain(mouseY, 550, 550 + padSize);
    
    float delayVal = map(xyPad1Pos.x, 140, 140 + padSize, 0, 1);
    float reverbVal = map(xyPad1Pos.y, 550 + padSize, 550, 0, 1);  // Y invertito
    sendOSC("/controller/sendLevel2", delayVal);  // FX4 = delay
    sendOSC("/controller/sendLevel1", reverbVal); // FX3 = reverb
    cp5.get(Slider.class, "FX4").setValue(delayVal);
    cp5.get(Slider.class, "FX3").setValue(reverbVal);
  }

  if (draggingXY2) {
    xyPad2Pos.x = constrain(mouseX, 1100, 1100 + padSize);
    xyPad2Pos.y = constrain(mouseY, 550, 550 + padSize);
    
    float distortionVal = map(xyPad2Pos.x, 1100, 1100 + padSize, 0, 1);
    float flangerVal = map(xyPad2Pos.y, 550 + padSize, 550, 0, 1);
    sendOSC("/controller/sendLevel4", distortionVal); // FX7 = distortion
    sendOSC("/controller/sendLevel3", flangerVal);    // FX6 = flanger
    cp5.get(Slider.class, "FX7").setValue(distortionVal);
    cp5.get(Slider.class, "FX6").setValue(flangerVal);
  }
}

// === 4. Invio OSC ===

// 4.1 Logica invio OSC
void sendOSC(String address, float val) {
  
  OscMessage m = new OscMessage(address);
  m.add(val);
  oscP5.send(m, sc);
  oscP5.send(m, py); 
  
}

// 4.2 Invio OSC a seguito di modifica controlli GUI

void controlEvent(ControlEvent e) {
  
  String name = e.getName();
  float val = e.getValue();

  // 4.2.1 LPF & LFO
  if (name.equals("cutoff")) {
    sendOSC("/controller/cutoff", val);
    
  } else if (name.equals("lfoFreq")) {
    sendOSC("/controller/lfoFreq", val);
    
  } else if (name.equals("lfoDepth")) {
    sendOSC("/controller/lfoDepth", val);
    
  // 4.2.2 Envelope (ADSR)
  } else if (name.equals("attack")) {
    sendOSC("/controller/attack", val);
    
  } else if (name.equals("decay")) {
    sendOSC("/controller/decay", val);
    
  } else if (name.equals("sustain")) {
    sendOSC("/controller/sustain", val);
    
  } else if (name.equals("release")) {
    sendOSC("/controller/release", val);  
    
  // 4.2.3 Fxs
  } else if (name.equals("FX3")) {               // riverbero
    sendOSC("/controller/sendLevel1", val);
    lastFX3 = val;
    xyPad1Pos.y = map(val, 0, 1, 550 + padSize, 550);
  } else if (name.equals("r_roomsize")) {
    sendOSC("/controller/r_roomsize", val);
  } else if (name.equals("r_damping")) {
    sendOSC("/controller/r_damping", val);
  } else if (name.equals("r_mix")) {
    sendOSC("/controller/r_mix", val);
  } else if (name.equals("r_predelay")) {
    sendOSC("/controller/r_predelay", val);
  
  } else if (name.equals("FX4")) {
    sendOSC("/controller/sendLevel2", val);
    lastFX4 = val;
    xyPad1Pos.x = map(val, 0, 1, 140, 140 + padSize);    
  } else if (name.equals("de_delaytime")) {
    sendOSC("/controller/de_delaytime", val);
  } else if (name.equals("de_feedback")) {
    sendOSC("/controller/de_feedback", val);
  } else if (name.equals("de_mix")) {
    sendOSC("/controller/de_mix", val);
    
  } else if (name.equals("FX6")) {
    sendOSC("/controller/sendLevel3", val);
    lastFX6 = val;
    xyPad2Pos.y = map(val, 0, 1, 550 + padSize, 550); 
    
  } else if (name.equals("FX7")) {
    sendOSC("/controller/sendLevel4", val);
    lastFX7 = val;
    xyPad2Pos.x = map(val, 0, 1, 1100, 1100 + padSize);
  } else if (name.equals("di_drive")) {
    sendOSC("/controller/di_drive", val);
  } else if (name.equals("di_tone")) {
    sendOSC("/controller/di_tone", val);
  } else if (name.equals("di_mix")) {
    sendOSC("/controller/di_mix", val);
  } else if (name.equals("di_output")) {
    sendOSC("/controller/di_output", val);
  
  // 4.2.4 Waveforms Levels
  } else if (name.equals("level1")) {
    sendOSC("/controller/level1", val);
    
  } else if (name.equals("level2")) {
    sendOSC("/controller/level2", val);
    
  } else if (name.equals("level3")) {
    sendOSC("/controller/level3", val);
    
  // 4.2.5 Waveforms Octaves
  } else if (name.equals("octave1")) {
    sendOSC("/controller/octave1", round(val));
    
  } else if (name.equals("octave2")) {
    sendOSC("/controller/octave2", round(val));
    
  } else if (name.equals("octave3")) {
    sendOSC("/controller/octave3", round(val));
  
  // 4.2.6 Waveforms Types
  } else if (name.startsWith("waveform")) {
    int idx = (int) val;
    sendOSC("/controller/" + name, idx);
    
  // 4.2.7 Glide  
  } else if (name.equals("glide")) {
    sendOSC("/controller/glide", val);
    
  } else if (name.equals("glideTime")) {
    sendOSC("/controller/glideTime", val);
  
  }
}


// === 5. Ricezione OSC ===
void oscEvent(OscMessage m) {
  
  String addr = m.addrPattern();
  float val = m.get(0).floatValue();

  // 5.1 LPF & LFO
  if (addr.equals("/controller/cutoff")) {
    cp5.get(Knob.class, "cutoff").setValue(val);
    
  } else if (addr.equals("/controller/lfoFreq")) {
    cp5.get(Knob.class, "lfoFreq").setValue(val);
    
  } else if (addr.equals("/controller/lfoDepth")) {
    cp5.get(Knob.class, "lfoDepth").setValue(val);
    
  // 5.2 Envelope (ADSR)
  } else if (addr.equals("/controller/attack")) {
    val = constrain(val, 0.001, 5.0);
    cp5.get(Slider.class, "attack").setValue(val);
    
  } else if (addr.equals("/controller/decay")) {
    cp5.get(Slider.class, "decay").setValue(val);
    
  } else if (addr.equals("/controller/sustain")) {
    cp5.get(Slider.class, "sustain").setValue(val);
    
  } else if (addr.equals("/controller/release")) {
    cp5.get(Slider.class, "release").setValue(val);
  
  // 5.3 FXs
  } else if (addr.equals("/controller/sendLevel1")) {
    cp5.get(Slider.class, "FX3").setValue(val);
    lastFX3 = val;
    xyPad1Pos.y = map(val, 0, 1, 550 + padSize, 550);
  } else if (addr.equals("/controller/r_roomsize")) {
    cp5.get(Knob.class, "r_roomsize").setValue(val);
    
  } else if (addr.equals("/controller/sendLevel2")) {
    cp5.get(Slider.class, "FX4").setValue(val);
    lastFX4 = val;
    xyPad1Pos.x = map(val, 0, 1, 140, 140 + padSize);
    
  } else if (addr.equals("/controller/sendLevel3")) {
    cp5.get(Slider.class, "FX6").setValue(val);
    lastFX6 = val;
    xyPad2Pos.y = map(val, 0, 1, 550 + padSize, 550); 
    
  } else if (addr.equals("/controller/sendLevel4")) {
    cp5.get(Slider.class, "FX7").setValue(val);
    lastFX7 = val;
    xyPad2Pos.x = map(val, 0, 1, 1100, 1100 + padSize);
    
  // 5.4 Waveforms Levels
  } else if (addr.equals("/controller/level1")) {
    cp5.get(Knob.class, "level1").setValue(val);
    
  } else if (addr.equals("/controller/level2")) {
    cp5.get(Knob.class, "level2").setValue(val);
    
  } else if (addr.equals("/controller/level3")) {
    cp5.get(Knob.class, "level3").setValue(val);
    
  // 5.5 Waveforms Types
  } else if (addr.equals("/controller/waveform1")) {
    cp5.get(DropdownList.class, "waveform1").setValue(val);
    
  } else if (addr.equals("/controller/waveform2")) {
    cp5.get(DropdownList.class, "waveform2").setValue(val);
    
  } else if (addr.equals("/controller/waveform3")) {
    cp5.get(DropdownList.class, "waveform3").setValue(val);
    
  // 5.6 Waveforms Octaves
  } else if (addr.equals("/controller/octave1")) {
    cp5.get(Knob.class, "octave1").setValue(val);
    
  } else if (addr.equals("/controller/octave2")) {
    cp5.get(Knob.class, "octave2").setValue(val);
    
  } else if (addr.equals("/controller/octave3")) {
    cp5.get(Knob.class, "octave3").setValue(val);
  
  // 5.7 Glide
  } else if (addr.equals("/controller/glide")) {
    cp5.get(Slider.class, "glide").setValue(val);
    
  } else {
    println("OSC ricevuto: " + addr + " = " + val);
    
  }
}
