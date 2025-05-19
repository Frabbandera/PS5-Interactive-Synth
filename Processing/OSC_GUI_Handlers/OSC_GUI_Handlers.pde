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

// 1.3 Inizializzazione GUI
void setup() {
  
  size(1450, 820);
  
  // 1.3.1 Setup
  sc = new NetAddress("127.0.0.1", 57120);
  py = new NetAddress("127.0.0.1", 12001);
  oscP5 = new OscP5(this, 12000);
  cp5 = new ControlP5(this);

  // 1.3.2 Sezioni GUI
  setupOscillators();
  setupEnvelope();
  setupModulation();
  setupFX();
  setupJoypad();
  
}

// 1.4 Gestione Sfondo
void draw() {
  background(255, 253, 240);
  fill(240);
  text("Controlli via Controller PS5 (OSC)", 30, 30);
}

// === 2. Funzioni Setup GUI

// 2.1 Oscillators
void setupOscillators() {
  
  oscGroup = cp5.addGroup("Oscillators")
    .setPosition(10, 50)
    .setSize(440, 380)
    .setBackgroundColor(color(235, 220, 180, 180))
    .setLabel("Oscillators");

  String[] waveNames = {"Sine", "Saw", "Square", "LFTri", "LFSaw", "Blip"};
  
  for (int i = 0; i < 3; i++) {
    int y0 = 10 + i * 130;

    cp5.addDropdownList("waveform" + (i + 1))
      .setPosition(20, y0)
      .setSize(140, 120)
      .setItems(waveNames)
      .setGroup(oscGroup)
      .setLabel("Wave " + (i + 1))
      .setColorBackground(color(205, 180, 140))
      .setColorForeground(color(180, 125, 85))
      .setColorActive(color(180, 125, 85));

    cp5.addKnob("level" + (i + 1))
      .setPosition(210, y0 + 10)
      .setRadius(35)
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
      .setRadius(35)
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
}

// 2.2 Envelope 
void setupEnvelope() {
  
  envGroup = cp5.addGroup("Envelope")
    .setPosition(460, 50)
    .setSize(480, 180)
    .setBackgroundColor(color(255, 180, 180, 180))
    .setLabel("ADSR Envelope");

  cp5.addSlider("attack")
    .setPosition(30, 40)
    .setSize(70, 120)
    .setRange(0, 5)
    .setValue(0.01)
    .setGroup(envGroup)
    .setLabel("Attack")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));

  cp5.addSlider("decay")
    .setPosition(150, 40)
    .setSize(70, 120)
    .setRange(0, 5)
    .setValue(0.3)
    .setGroup(envGroup)
    .setLabel("Decay")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));

  cp5.addSlider("sustain")
    .setPosition(270, 40)
    .setSize(70, 120)
    .setRange(0, 1)
    .setValue(0.5)
    .setGroup(envGroup)
    .setLabel("Sustain")
    .setColorBackground(color(205, 140, 150))
    .setColorForeground(color(150, 20, 55))
    .setColorActive(color(150, 20, 55));

  cp5.addSlider("release")
    .setPosition(390, 40)
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
  
  lfoGroup = cp5.addGroup("Modulation")
    .setPosition(460, 250)
    .setSize(480, 180)
    .setBackgroundColor(color(200, 180, 255, 180))
    .setLabel("LFO & Filter");

  cp5.addKnob("lfoFreq")
    .setPosition(40, 40)
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
    .setPosition(200, 40)
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
    .setPosition(360, 40)
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
  
  fxGroup = cp5.addGroup("FXPads")
    .setPosition(10, 450)
    .setSize(1400, 360)
    .setBackgroundColor(color(170, 220, 170, 180))
    .setLabel("Effects Pads");

  cp5.addSlider("FX3")
    .setPosition(455, 10)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Reverb")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("r_roomsize")
      .setPosition(480, 35)
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
      .setPosition(560, 35)
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
      .setPosition(480, 105)
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
      .setPosition(560, 105)
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
    .setPosition(455, 180)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Delay")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("de_delaytime")
      .setPosition(480, 210)
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
      .setPosition(560, 210)
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
      .setPosition(520, 280)
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
    .setPosition(710, 10)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Flanger")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("f_rate")
      .setPosition(710, 35)
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
      .setPosition(775, 35)
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
      .setPosition(840, 35)
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
      .setPosition(742, 105)
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
      .setPosition(808, 105)
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
    .setPosition(710, 180)
    .setSize(180, 20)
    .setRange(0, 1)
    .setValue(0)
    .setGroup(fxGroup)
    .setLabel("Distortion")
    .setColorBackground(color(120, 180, 140))
    .setColorForeground(color(20, 100, 20))
    .setColorActive(color(20, 100, 20));
    
    cp5.addKnob("di_drive")
      .setPosition(735, 210)
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
      .setPosition(815, 210)
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
      .setPosition(735, 280)
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
      .setPosition(815, 280)
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
}

// 2.5 Joypad Setup
void setupJoypad() {
  joypadGroup = cp5.addGroup("Joypad")
    .setPosition(950, 50)
    .setSize(460, 380)
    .setBackgroundColor(color(235, 220, 180, 180))
    .setLabel("Joystick Layout");

  pushMatrix();
  translate(1050 + 195, 50 + 380);
  fill(200);
  noStroke();
  float s = 60;
  triangle(-s, 0, -s/2, -s/2, -s/2, s/2);
  triangle( s, 0,  s/2, -s/2,  s/2, s/2);
  triangle(0, -s, -s/2, -s/2, s/2, -s/2);
  triangle(0,  s, -s/2, s/2, s/2, s/2);
  popMatrix();
}

// === 3. Invio OSC ===

// 3.1 Logica invio OSC
void sendOSC(String address, float val) {
  
  OscMessage m = new OscMessage(address);
  m.add(val);
  oscP5.send(m, sc);
  oscP5.send(m, py); 
  
}

// 3.2 Invio OSC a seguito di modifica controlli GUI

void controlEvent(ControlEvent e) {
  
  String name = e.getName();
  float val = e.getValue();

  // 3.2.1 LPF & LFO
  if (name.equals("cutoff")) {
    sendOSC("/controller/cutoff", val);
    
  } else if (name.equals("lfoFreq")) {
    sendOSC("/controller/lfoFreq", val);
    
  } else if (name.equals("lfoDepth")) {
    sendOSC("/controller/lfoDepth", val);
    
  // 3.2.2 Envelope (ADSR)
  } else if (name.equals("attack")) {
    sendOSC("/controller/attack", val);
    
  } else if (name.equals("decay")) {
    sendOSC("/controller/decay", val);
    
  } else if (name.equals("sustain")) {
    sendOSC("/controller/sustain", val);
    
  } else if (name.equals("release")) {
    sendOSC("/controller/release", val);  
    
  // 3.2.3 Fxs
  } else if (name.equals("FX3")) {
    sendOSC("/controller/sendLevel1", val);
    
  } else if (name.equals("FX4")) {
    sendOSC("/controller/sendLevel2", val);
    
  } else if (name.equals("FX6")) {
    sendOSC("/controller/sendLevel3", val);
    
  } else if (name.equals("FX7")) {
    sendOSC("/controller/sendLevel4", val);
    
  // 3.2.3 Waveforms Levels
  } else if (name.equals("level1")) {
    sendOSC("/controller/level1", val);
    
  } else if (name.equals("level2")) {
    sendOSC("/controller/level2", val);
    
  } else if (name.equals("level3")) {
    sendOSC("/controller/level3", val);
    
  // 3.2.4 Waveforms Octaves
  } else if (name.equals("octave1")) {
    sendOSC("/controller/octave1", round(val));
    
  } else if (name.equals("octave2")) {
    sendOSC("/controller/octave2", round(val));
    
  } else if (name.equals("octave3")) {
    sendOSC("/controller/octave3", round(val));
  
  // 3.2.5 Waveforms Types
  } else if (name.startsWith("waveform")) {
    int idx = (int) val;
    sendOSC("/controller/" + name, idx);
    
  }
}

// === 4. Ricezione OSC ===
void oscEvent(OscMessage m) {
  
  String addr = m.addrPattern();
  float val = m.get(0).floatValue();

  // 4.1 LPF & LFO
  if (addr.equals("/controller/cutoff")) {
    cp5.get(Knob.class, "cutoff").setValue(val);
    
  } else if (addr.equals("/controller/lfoFreq")) {
    cp5.get(Knob.class, "lfoFreq").setValue(val);
    
  } else if (addr.equals("/controller/lfoDepth")) {
    cp5.get(Knob.class, "lfoDepth").setValue(val);
    
  // 4.2 Envelope (ADSR)
  } else if (addr.equals("/controller/attack")) {
    val = constrain(val, 0.001, 5.0);
    cp5.get(Slider.class, "attack").setValue(val);
    
  } else if (addr.equals("/controller/decay")) {
    cp5.get(Slider.class, "decay").setValue(val);
    
  } else if (addr.equals("/controller/sustain")) {
    cp5.get(Slider.class, "sustain").setValue(val);
    
  } else if (addr.equals("/controller/release")) {
    cp5.get(Slider.class, "release").setValue(val);
  
  // 4.3 FXs
  } else if (addr.equals("/controller/sendLevel1")) {
    cp5.get(Slider.class, "FX3").setValue(val);
    
  } else if (addr.equals("/controller/sendLevel2")) {
    cp5.get(Slider.class, "FX4").setValue(val);
    
  } else if (addr.equals("/controller/sendLevel3")) {
    cp5.get(Slider.class, "FX6").setValue(val);
    
  } else if (addr.equals("/controller/sendLevel4")) {
    cp5.get(Slider.class, "FX7").setValue(val);
    
  // 4.4 Waveforms Levels
  } else if (addr.equals("/controller/level1")) {
    cp5.get(Knob.class, "level1").setValue(val);
    
  } else if (addr.equals("/controller/level2")) {
    cp5.get(Knob.class, "level2").setValue(val);
    
  } else if (addr.equals("/controller/level3")) {
    cp5.get(Knob.class, "level3").setValue(val);
    
  // 4.5 Waveforms Types
  } else if (addr.equals("/controller/waveform1")) {
    cp5.get(DropdownList.class, "waveform1").setValue(val);
    
  } else if (addr.equals("/controller/waveform2")) {
    cp5.get(DropdownList.class, "waveform2").setValue(val);
    
  } else if (addr.equals("/controller/waveform3")) {
    cp5.get(DropdownList.class, "waveform3").setValue(val);
    
  // 4.6 Waveforms Octaves
  } else if (addr.equals("/controller/octave1")) {
    cp5.get(Knob.class, "octave1").setValue(val);
    
  } else if (addr.equals("/controller/octave2")) {
    cp5.get(Knob.class, "octave2").setValue(val);
    
  } else if (addr.equals("/controller/octave3")) {
    cp5.get(Knob.class, "octave3").setValue(val);
  
  } else {
    println("OSC ricevuto: " + addr + " = " + val);
    
  }
}
