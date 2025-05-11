# Tutorial Avvio Applicazione

## 📁 1. Donwload Files

### 🔹 SuperCollider

All'interno della cartella `SuperCollider/` troverai il progetto suddiviso nei seguenti moduli:

| Cartella             | Contenuto                                                        |
|----------------------|------------------------------------------------------------------|
| `SynthDefs/`         | Definizione del sintetizzatore interattivo                      |
| `Effects/`           | Definizione e apertura dei plugin di effetto (reverb, delay...) |
| `Handlers/`          | Gestione MIDI e messaggi OSC dal gamepad                        |
| `GUI/`               | Interfaccia grafica per controllo parametri                     |
| `main.scd`           | Script principale: **compilalo per avviare il sistema**         |

### 🔹 Processing

Contiene lo script che legge i dati dal controller PS4/PS5 e li invia a SuperCollider tramite OSC.

---

## 🧰 2. Requisiti Processing – Installazione librerie

### 🔹 Librerie necessarie:

- `oscP5`  
- `Game Control Plus`  
- `G4P` (solo per configuratore)

### 🔹 Come installarle:

1. Apri Processing
2. Vai su **Sketch > Import Library... > Add Library...**
3. Nella finestra che si apre, cerca e installa:
   - **oscP5**
   - **Game Control Plus**
   - **G4P** (serve solo per configurare il controller)

---

## 🎮 3. Scopri a quale porta è collegato il tuo controller

Esegui questo script Processing **prima di lanciare l’app**:

```java
import org.gamecontrolplus.*;
ControlIO control;

void setup() {
size(400, 100);
control = ControlIO.getInstance(this);

ControlDevice[] devices = control.getDevices();
for (int i = 0; i < devices.length; i++) {
 println("Device #" + i + ": " + devices[i].getName());
}
}
```

Copia il numero corretto (es. 2) e sostituisci la riga nel file OSC_PS5_Handlers.pde: device = control.getDevice(2); 

---

## ▶️ 4. Avvio dell'applicazione

1. Collega il controller PS4 o PS5 via USB
2. Avvia SuperCollider, apri main.scd e compila
3. Avvia lo sketch OSC_PS5_Handlers.pde in Processing
4. Suona con la tastiera MIDI e interagisci con il gamepad (trigger, stick, pulsanti)
5. La GUI si aggiornerà automaticamente
