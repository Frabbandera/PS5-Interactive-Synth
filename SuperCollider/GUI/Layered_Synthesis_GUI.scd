// === LAYERED_SYNTHESIS_GUI.SCD ===

(
// === 1. Interfaccia grafica (GUI): gestione slider e menù (forme d'onda, ottave, parametri ADSR, LFO, filtro, FX send e livelli oscillatori) ===

~win = Window("Interactive Synth Control", Rect(200, 200, 360, 700)); // Finestra principale della GUI
~win.background = Color.grey(0.9);                                    // Colore sfondo

// 1.1 Waveforms
~waveformLabel = StaticText(~win, Rect(20, 20, 320, 20))              // Etichetta che mostra le forme d’onda selezionate
    .string_("Waveform 1/2/3: " ++ ~waveformNames[~waveform1] ++ " + " ++ ~waveformNames[~waveform2] ++ " + " ++ ~waveformNames[~waveform3]);

~waveformSlider1 = Slider(~win, Rect(20, 45, 320, 20))                // Slider per waveform1
    .value_(~waveform1 / 5).action_({ |sl|
        ~waveform1 = (sl.value * 5).round;
        ~waveformLabel.string = "Waveform 1/2/3: " ++ ~waveformNames[~waveform1] ++ " + " ++ ~waveformNames[~waveform2] ++ " + " ++ ~waveformNames[~waveform3];
        ~notes.values.do({ |s| s.set(\waveform1, ~waveform1) });
    });

~waveformSlider2 = Slider(~win, Rect(20, 70, 320, 20))                // Slider per waveform2
    .value_(~waveform2 / 5).action_({ |sl|
        ~waveform2 = (sl.value * 5).round;
        ~waveformLabel.string = "Waveform 1/2/3: " ++ ~waveformNames[~waveform1] ++ " + " ++ ~waveformNames[~waveform2] ++ " + " ++ ~waveformNames[~waveform3];
        ~notes.values.do({ |s| s.set(\waveform2, ~waveform2) });
    });

~waveformSlider3 = Slider(~win, Rect(20, 95, 320, 20))                // Slider per waveform3
    .value_(~waveform3 / 5).action_({ |sl|
        ~waveform3 = (sl.value * 5).round;
        ~waveformLabel.string = "Waveform 1/2/3: " ++ ~waveformNames[~waveform1] ++ " + " ++ ~waveformNames[~waveform2] ++ " + " ++ ~waveformNames[~waveform3];
        ~notes.values.do({ |s| s.set(\waveform3, ~waveform3) });
    });

// 1.2 Octaves
StaticText(~win, Rect(20, 120, 320, 16)).string_("Octave Offsets (Osc 1/2/3)");

~octaveMenu1 = PopUpMenu(~win, Rect(20, 140, 100, 20))
    .items_([-2, -1, 0, 1, 2].collect(_.asString)).value_(2)
    .action_({ |m| ~octave1 = m.value - 2; ~notes.values.do({ |s| s.set(\octave1, ~octave1) }); });

~octaveMenu2 = PopUpMenu(~win, Rect(130, 140, 100, 20))
    .items_([-2, -1, 0, 1, 2].collect(_.asString)).value_(2)
    .action_({ |m| ~octave2 = m.value - 2; ~notes.values.do({ |s| s.set(\octave2, ~octave2) }); });

~octaveMenu3 = PopUpMenu(~win, Rect(240, 140, 100, 20))
    .items_([-2, -1, 0, 1, 2].collect(_.asString)).value_(2)
    .action_({ |m| ~octave3 = m.value - 2; ~notes.values.do({ |s| s.set(\octave3, ~octave3) }); });

// 1.3 ADSR
StaticText(~win, Rect(20, 170, 320, 16)).string_("Attack");
Slider(~win, Rect(20, 190, 320, 20)).value_(~attack.linlin(0.001, 2.0, 0, 1))
    .action_({ |sl| ~attack = sl.value.linlin(0, 1, 0.001, 2.0); ~notes.values.do({ |s| s.set(\attack, ~attack) }); });

StaticText(~win, Rect(20, 220, 320, 16)).string_("Decay");
Slider(~win, Rect(20, 240, 320, 20)).value_(~decay.linlin(0.01, 2.0, 0, 1))
    .action_({ |sl| ~decay = sl.value.linlin(0, 1, 0.01, 2.0); ~notes.values.do({ |s| s.set(\decay, ~decay) }); });

StaticText(~win, Rect(20, 270, 320, 16)).string_("Sustain");
Slider(~win, Rect(20, 290, 320, 20)).value_(~sustain)
    .action_({ |sl| ~sustain = sl.value.clip(0, 1); ~notes.values.do({ |s| s.set(\sustain, ~sustain) }); });

StaticText(~win, Rect(20, 320, 320, 16)).string_("Release");
Slider(~win, Rect(20, 340, 320, 20)).value_(~release.linlin(0.01, 5.0, 0, 1))
    .action_({ |sl| ~release = sl.value.linlin(0, 1, 0.01, 5.0); ~notes.values.do({ |s| s.set(\release, ~release) }); });

// 1.4 LPF e LFO
StaticText(~win, Rect(20, 370, 320, 16)).string_("Cutoff Frequency");
~cutoffSlider = Slider(~win, Rect(20, 390, 320, 20)).value_(~cutoff.linlin(20, 20000, 0, 1))
    .action_({ |sl| ~cutoff = sl.value.linexp(0, 1, 20, 20000); ~notes.values.do({ |s| s.set(\cutoff, ~cutoff) }); });

StaticText(~win, Rect(20, 420, 320, 16)).string_("LFO Frequency");
~lfoFreqSlider = Slider(~win, Rect(20, 440, 320, 20)).value_(~lfoFreq.linlin(0, 20, 0, 1))
    .action_({ |sl| ~lfoFreq = sl.value.linlin(0, 1, 0, 20); ~notes.values.do({ |s| s.set(\lfoFreq, ~lfoFreq) }); });

StaticText(~win, Rect(20, 470, 320, 16)).string_("LFO Depth");
Slider(~win, Rect(20, 490, 320, 20)).value_(~lfoDepth)
    .action_({ |sl| ~lfoDepth = sl.value.clip(0, 1); ~notes.values.do({ |s| s.set(\lfoDepth, ~lfoDepth) }); });

// 1.5 FX Send
StaticText(~win, Rect(20, 520, 320, 16)).string_("FX Send Level (Reverb)");
~sendLevelSlider1 = Slider(~win, Rect(20, 540, 320, 20)).value_(~sendLevel)
    .action_({ |sl| ~sendLevel = sl.value; ~notes.values.do({ |s| s.set(\sendLevel1, ~sendLevel) }); });

StaticText(~win, Rect(20, 570, 320, 16)).string_("FX Send Level (Delay)");
~sendLevelSlider2 = Slider(~win, Rect(20, 590, 320, 20)).value_(~sendLevel2)
    .action_({ |sl| ~sendLevel2 = sl.value; ~notes.values.do({ |s| s.set(\sendLevel2, ~sendLevel2) }); });

// 1.6 Oscillators's Levels
StaticText(~win, Rect(20, 620, 320, 16)).string_("Oscillator Levels (1/2/3)");

Slider(~win, Rect(20, 640, 100, 20)).value_(~level1)
    .action_({ |sl| ~level1 = sl.value; ~notes.values.do({ |s| s.set(\level1, ~level1) }); });

Slider(~win, Rect(130, 640, 100, 20)).value_(~level2)
    .action_({ |sl| ~level2 = sl.value; ~notes.values.do({ |s| s.set(\level2, ~level2) }); });

Slider(~win, Rect(240, 640, 100, 20)).value_(~level3)
    .action_({ |sl| ~level3 = sl.value; ~notes.values.do({ |s| s.set(\level3, ~level3) }); });

~win.front;     // Mostra finestra
)