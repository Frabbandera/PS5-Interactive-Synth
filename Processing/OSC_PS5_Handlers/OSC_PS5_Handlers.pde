// === OSC_PS5_HANDLERS.PDE ===

// === 1. Mappatura OSC: mappatura input del controller PS5 (via Game Control Plus) 
//                a messaggi OSC inviati a SuperCollider (via oscP5) ===

// 1.1 Importazione librerie e impostazione setup inizale
import org.gamecontrolplus.*;          // Libreria per leggere controller
import net.java.games.input.*;         // API JInput usata da GCP

import oscP5.*;                        // Libreria per OSC in Processing
import netP5.*;

ControlIO control;                     // Istanza del gestore dei dispositivi GCP
ControlDevice device;                  // Controller PS5 selezionato
ControlSlider r2, l2;                  // Trigger analogici: R2 e L2

OscP5 oscP5;                           // Gestione locale dei messaggi OSC
NetAddress supercollider;              // Indirizzo remoto per SC

float lfoFreq = 0.0;                   // Frequenza LFO (accumulatore)
float cutoff = 20000;                  // Valore iniziale del filtro cutoff

// 1.2 Inizializzazione controller
void setup() {
  
  size(400, 200);                               // Dimensione finestra
  
  // 1.2.1 Selezione controller
  control = ControlIO.getInstance(this);        // Ottiene accesso alla libreria GPC
  device = control.getDevice(2);                // Seleziona il controller alla porta specificata
  
  if (device == null) {
    println("Controller non trovato.");
    exit();                                    // Termina se nessun controller valido
  }

  println("Controller selezionato: " + device.getName());

  // 1.2.2 Mappatura trigger posteriori R2 e L2
  r2 = device.getSlider("Rotazione Y");        // R2 → asse confermato in configuratore
  l2 = device.getSlider("Rotazione X");        // L2 → idem

  // 1.2.3 Configurazione comunicazione OSC
  oscP5 = new OscP5(this, 12000);                      // Inizializza la comunicazione OSC in uscita
  supercollider = new NetAddress("127.0.0.1", 57120);  // Definisce dove mandare i messaggi OSC (porta di SuperCollider)

}

// 1.3 Elaborazione continua dell'input utente
void draw() {
  
  // 1.3.1 Impostazioni grafiche
  background(255);
  fill(0);
  textSize(14);

  // 1.3.2 Controllo cutoff (L1/R1)
  
  // 1.3.2.1 Mappatura cutoff
  ControlButton l1 = device.getButton(5);     // L1 → diminuisce cutoff
  ControlButton r1 = device.getButton(6);     // R1 → aumenta cutoff

  float cutoffStep = 100;                     // Incremento/decremento [Hz] per frame

  if (r1.pressed()) {
    cutoff += cutoffStep;
  } else if (l1.pressed()) {
    cutoff -= cutoffStep;
  }

  cutoff = constrain(cutoff, 20, 20000);      // Limita range utile

  // 1.3.2.2 Invio valore cutoff via OSC
  OscMessage cutoffMsg = new OscMessage("/controller/cutoff");
  cutoffMsg.add(cutoff);
  oscP5.send(cutoffMsg, supercollider);

  // 1.3.2.3 Debug visuale
  text("Cutoff: " + int(cutoff) + " Hz", 20, height - 40); 

  // 1.3.3 Controllo LFO Freq (R2/L2)
  
  // 1.3.3.1 Mappatura LFO
  float r2Val = map(r2.getValue(), -1, 1, 0, 1);    // Normalizzazione trigger (-1,1)->(0,1)
  float l2Val = map(l2.getValue(), -1, 1, 0, 1);
  float delta = r2Val - l2Val;                      // Differenza netta (R2 aumenta/L2 riduce)

  lfoFreq += delta * 0.5;                           // Integrazione incrementale
  lfoFreq = constrain(lfoFreq, 0, 20);              // Limite in frequenza (Hz)

  // 1.3.3.2 Invio valore LFO via OSC
  OscMessage msg = new OscMessage("/controller/lfoFreq");
  msg.add(lfoFreq);
  oscP5.send(msg, supercollider);

  // 1.3.3.3 Visualizzazione stato LFO
  text("R2: " + nf(r2Val, 1, 2), 20, 30);
  text("L2: " + nf(l2Val, 1, 2), 20, 50);
  text("Delta: " + nf(delta, 1, 2), 20, 70);
  text("LFO Freq: " + nf(lfoFreq, 1, 2), 20, 100);

  // 1.3.3.4 LFO visual bar
  fill(0, 100, 255);
  rect(20, 120, map(lfoFreq, 0, 20, 0, width - 40), 20);
  
  // 1.3.4 Controllo riverbero (asse Y stick sinistro)
  
  // 1.3.4.1 Mappatura riverbero
  ControlSlider stickLeftY = device.getSlider("Asse Y");
  float rawY = stickLeftY.getValue();                      // Range [-1 (giù), 1 (su)]
  float stickY = abs(rawY);                                // Trasforma Range in [0, 1]
  stickY = constrain(stickY, 0, 1);

  // 1.3.4.2 Invio valore riverbero via OSC
  OscMessage revMsg = new OscMessage("/controller/sendLevel1");
  revMsg.add(stickY);
  oscP5.send(revMsg, supercollider);

  // 1.3.5 Controllo delay (asse X stick sinistro)
  
  // 1.3.5.1 Mappatura delay
  ControlSlider stickLeftX = device.getSlider("Asse X");
  float rawX = stickLeftX.getValue();
  float stickX = abs(rawX);
  stickX = constrain(stickX, 0, 1);

  // 1.3.5.2 Invio valore delay via OSC
  OscMessage delMsg = new OscMessage("/controller/sendLevel2");
  delMsg.add(stickX);
  oscP5.send(delMsg, supercollider);
  
}
