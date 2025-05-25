# 🎮 PlaySynth – PS5/PS4 Interactive Synthesizer

**PlaySynth** is an interactive synthesizer project that allows users to control audio synthesis parameters using a PlayStation 5 (DualSense) controller or PlayStation 4 controller. The system integrates **SuperCollider** for sound synthesis, **Processing** for a dynamic graphical interface, and **Python** to handle controller inputs via the **OSC (Open Sound Control)** protocol.

> 🎓 Developed as a final project for the course *Computer Music – Languages and Systems* at Politecnico di Milano (MSc in Music & Acoustic Engineering).

---

## 🧠 Concept

PlaySynth creates an immersive real-time sound manipulation environment using a PS5 controller. The user can:

* Navigate synthesis parameters using analog sticks and buttons.
* Trigger modes (Mono, Poly, Random).
* Control ADSR envelope, waveform selection, filter cutoff, LFO, reverb, delay, flanger, and distortion via an interactive GUI.

---

## 🧱 Architecture

![blockdiagram](https://raw.githubusercontent.com/Frabbandera/PS5-Interactive-Synth/refs/heads/main/Resources/blockdiagram.jpeg.jpg)

* **Python** captures controller data and maps it to OSC messages.
* **Processing** (Java-based) manages the graphical interface and routes interaction via OSC.
* **SuperCollider** is the real-time audio engine.
* **MIDI interaction** in SuperCollider.

---

## 💻 Technologies Used

| Component      | Technology                   |
| -------------- | ---------------------------- |
| GUI            | Processing + ControlP5       |
| Controller I/O | Python + pygame + python-osc |
| Synthesis      | SuperCollider                |
| Communication  | OSC (Open Sound Control)     |
| Effects Engine | JUCE (VST plugins)           |

---

## 🖥️ Interface Overview

* 🎛️ **Knobs**: ADSR, LFO Rate/Depth, Cutoff, Glide

* 🟢 **XY Pads**: Control 4 FX (Reverb, Delay, Flanger, Distortion)

* 🎮 **PS5 Button Mapping**:

  * D-Pad: Filter and Glide control
  * Circle/Square: Switch Mono/Poly modes
  * Triangle/Cross: Toggle Random Synthesis Parameters/Reset
  * L1/L2, R1/R2: Affect LFOs
  * PS button: Random FX parameters
  * Touch Pad: Resets all parameters to default values

---

## 🔧 Setup & Installation

### 1. Requirements

* Python 3.x with:

  * `pygame`
  * `python-osc`
* Processing with ControlP5 and oscP5 libraries
* SuperCollider (recommended version ≥ 3.11)
* PS5 controller (wired or Bluetooth)
* JUCE plugins compiled if used (optional)

### 2. Launch Steps

1. **Run Python script**

   * Located in `Python/osc_ps5_handler.py`
   * Connects to the PS5 controller and starts sending OSC messages
2. **Open Processing sketch**

   * Found in `Processing/PS5_GUI.pde`
   * Launch the interface and verify GUI feedback
3. **Start SuperCollider**

   * Load `SuperCollider/interactiveSynth.scd`
   * Boot server and evaluate synth + OSC receiver
4. *(Optional)* Launch VST effects if connected via JUCE plugin

---

## 🧪 Features in Detail

### 🔊 Synthesis

* 3 Oscillators with selectable waveform (Sine, Saw, Square, LFTri, Blip)
* Octave shift and level per oscillator
* ADSR envelope for amplitude control
* Glide parameter for smooth pitch transitions

### 🌊 FX Section

* Reverb, Delay, Flanger, Distortion (controlled via XY pads)
* Each effect has its own OSC-controlled send level
* Visual feedback of parameters in GUI and OSC logs

### 🎲 Randomization & Control

* Randomize and reset waveforms, ADSR, LFO, filter by symbols pad (Triangle/Cross)
* Randomize FX parameters by PSbutton and reset by Touch Pad
* GUI and sound engine stay synchronized through OSC

---

## 🎨 GUI Preview

![PlaySynth GUI](https://raw.githubusercontent.com/Frabbandera/PS5-Interactive-Synth/refs/heads/main/Resources/PLAYSYNTH_GUI.png)

> Colors are inspired by the PS button colors and by the 2000s cartoon "Teletubbies" – pastel red, yellow, green, violet.

---

## 📄 Credits

* **Francesco Bandera**
* **Francesco Crociani**
* **Anna Impembo**
* **Eleonora Serra**

Developed at Politecnico di Milano – Master of Science in Music & Acoustic Engineering
Course: *Computer Music – Languages and Systems*

---
