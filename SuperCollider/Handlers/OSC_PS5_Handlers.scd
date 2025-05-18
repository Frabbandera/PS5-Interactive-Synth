// === OSC_PS5_HANDLERS.SCD ===

(
// === 1. Handling Processing's OSC Messages: aggiornamento in tempo reale dei parametri del synth in risposta all'interazione utente con controller PS5 e/o GUI Processing ===

// 1.1 Controller PS5

// 1.1.1 LPF & LFO

// 1.1.1.1 Cutoff Frequency (△ / ⇑)
OSCdef(\cutoffFromController, { |msg|

	var newCutoff = msg[1].clip(0, 20);                            // Limita il valore tra 0 e 20 kHz
    ~cutoff = newCutoff * 1000;                                    // Aggiorna lo stato globale
    ~notes.values.do({ |synth| synth.set(\cutoff, ~cutoff); });    // Applica il nuovo valore a tutti i synth attivi

    ("[OSC] Cutoff aggiornato: " + ~cutoff).postln;                // Debug console

}, '/controller/cutoff');

// 1.1.1.2 LFO Depth (R1 / L1)
OSCdef(\lfoDepthFromController, { |msg|

	var newDepth = msg[1].clip(0, 1);
	~lfoDepth = newDepth;
	~notes.values.do({ |synth| synth.set(\lfoDepth, newDepth) });

	("[OSC] lfoDepth aggiornato: " + newDepth).postln;

}, '/controller/lfoDepth');


// 1.1.1.3 LFO Frequency (R2 / L2)
OSCdef(\lfoFreqFromController, { |msg|

	var newFreq = msg[1].clip(0, 20);
    ~lfoFreq = newFreq;
    ~notes.values.do({ |synth| synth.set(\lfoFreq, ~lfoFreq); });

	("[OSC] lfoFreq aggiornato: " + ~lfoFreq).postln;

}, '/controller/lfoFreq');

// 1.1.2 FX

// 1.1.2.1 Reverb Send Level (asse Y stick sinistro)
OSCdef(\sendLevel1FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);                                     // Limita il valore tra 0 (niente) e 1 (max send)
    ~sendLevel = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel1, ~sendLevel); });    // Aggiorna sendLevel1 (riverbero) su ogni synth attivo

    ("[OSC] Reverb level aggiornato: " + ~sendLevel).postln;

}, '/controller/sendLevel1');

// 1.1.2.2 Delay Send Level (asse X stick sinistro)
OSCdef(\sendLevel2FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);
    ~sendLevel2 = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel2, ~sendLevel2); });

    ("[OSC] Delay level aggiornato: " + ~sendLevel2).postln;

}, '/controller/sendLevel2');

// 1.1.2.3 Flanger Send Level (asse Y stick destro)
OSCdef(\sendLevel3FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);
    ~sendLevel3 = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel3, newLevel) });

    ("[OSC] Flanger level aggiornato: " + newLevel).postln;

}, '/controller/sendLevel3');

// 1.1.2.4 Distortion Send Level (asse X stick destro)
OSCdef(\sendLevel4FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);
    ~sendLevel4 = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel4, newLevel) });

    ("[OSC] Distortion level aggiornato: " + newLevel).postln;

}, '/controller/sendLevel4');

// 1.2 GUI

// 1.2.1 Waveforms Types

// 1.2.1.1 Waveform1
OSCdef(\waveform1FromGUI, { |msg|

	var val = msg[1].asInteger.clip(0, ~waveformNames.size - 1);
	~waveform1 = val;
	~notes.values.do { |s| s.set(\waveform1, val) };

	("[OSC] waveform1 → " + ~waveformNames[val]).postln;

}, "/controller/waveform1");

// 1.2.1.2 Waveform2
OSCdef(\waveform2FromGUI, { |msg|

	var val = msg[1].asInteger.clip(0, ~waveformNames.size - 1);
	~waveform2 = val;
	~notes.values.do { |s| s.set(\waveform2, val) };

	("[OSC] waveform2 → " + ~waveformNames[val]).postln;

}, "/controller/waveform2");

// 1.2.1.3 Waveform3
OSCdef(\waveform3FromGUI, { |msg|

	var val = msg[1].asInteger.clip(0, ~waveformNames.size - 1);
	~waveform3 = val;
	~notes.values.do { |s| s.set(\waveform3, val) };

	("[OSC] waveform3 → " + ~waveformNames[val]).postln;

}, "/controller/waveform3");

// 1.2.2 Waveforms Levels

// 1.2.2.1 Waveform1
OSCdef(\level1FromController, { |msg|

	var newLevel = msg[1].clip(0, 1);
	~level1 = newLevel;
	~notes.values.do({ |synth| synth.set(\level1, newLevel) });

	("[OSC] Waveform1 level aggiornato: " + newLevel).postln;

}, '/controller/level1');

// 1.2.2.2 Waveform2
OSCdef(\level2FromController, { |msg|

	var newLevel = msg[1].clip(0, 1);
	~level2 = newLevel;
	~notes.values.do({ |synth| synth.set(\level2, newLevel) });

	("[OSC] Waveform2 level aggiornato: " + newLevel).postln;

}, '/controller/level2');

// 1.2.2.3 Waveform3
OSCdef(\level3FromController, { |msg|

	var newLevel = msg[1].clip(0, 1);
	~level3 = newLevel;
	~notes.values.do({ |synth| synth.set(\level3, newLevel) });

	("[OSC] Waveform3 level aggiornato: " + newLevel).postln;

}, '/controller/level3');

// 1.2.3 Waveforms Octaves

// 1.2.3.1 Waveform1
OSCdef(\octave1FromGUI, { |msg|

	var val = msg[1].asInteger.clip(-2, 2);
	~octave1 = val;
	~notes.values.do { |s| s.set(\octave1, val) };

	("[OSC] Waveform1 octave aggiornata: " + val).postln;

}, "/controller/octave1");

// 1.2.3.2 Waveform2
OSCdef(\octave2FromGUI, { |msg|

	var val = msg[1].asInteger.clip(-2, 2);
	~octave2 = val;
	~notes.values.do { |s| s.set(\octave2, val) };

	("[OSC] Waveform2 octave aggiornata: " + val).postln;

}, "/controller/octave2");

// 1.2.3.3 Waveform3
OSCdef(\octave3FromGUI, { |msg|

	var val = msg[1].asInteger.clip(-2, 2);
	~octave3 = val;
	~notes.values.do { |s| s.set(\octave3, val) };

	("[OSC] Waveform3 octave aggiornata: " + val).postln;

}, "/controller/octave3");

// 1.2.4 Envelope (ADSR)

// 1.2.4.1 Attack
OSCdef(\attackFromGUI, { |msg|

	var val = msg[1].clip(0, 5);
	~attack = val;
	~notes.values.do { |s| s.set(\attack, val) };

	("[OSC] Attack aggiornato: " + val).postln;

}, "/controller/attack");

// 1.2.4.2 Decay
OSCdef(\decayFromGUI, { |msg|

	var val = msg[1].clip(0, 5);
	~decay = val;
	~notes.values.do { |s| s.set(\decay, val) };

	("[OSC] Decay aggiornato: " + val).postln;

}, "/controller/decay");

// 1.2.4.3 Sustain
OSCdef(\sustainFromGUI, { |msg|

	var val = msg[1].clip(0, 1);
	~sustain = val;
	~notes.values.do { |s| s.set(\sustain, val) };

	("[OSC] Sustain aggiornato: " + val).postln;

}, "/controller/sustain");

// 1.2.4.4 Release
OSCdef(\releaseFromGUI, { |msg|

	var val = msg[1].clip(0, 5);
	~release = val;
	~notes.values.do { |s| s.set(\release, val) };

	("[OSC] Release aggiornato: " + val).postln;

}, "/controller/release");
)