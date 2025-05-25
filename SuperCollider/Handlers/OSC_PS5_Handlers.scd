// === OSC_PS5_HANDLERS.SCD ===

(

~osc = NetAddr("127.0.0.1", 12000);
// === 1. Handling Processing's OSC Messages: aggiornamento in tempo reale dei parametri del synth in risposta all'interazione utente con controller PS5 e/o GUI Processing ===

// 1.1 Controller PS5

// 1.1.1 LPF & LFO

// 1.1.1.1 Cutoff Frequency (<= / =>)
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

    var newLevel = msg[1].clip(0, 0.5);                                     // Limita il valore tra 0 (niente) e 1 (max send)
    ~sendLevel = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel1, ~sendLevel); });    // Aggiorna sendLevel1 (riverbero) su ogni synth attivo

    ("[OSC] Reverb level aggiornato: " + ~sendLevel).postln;

}, '/controller/sendLevel1');

// === Parametri interni del plugin riverbero (GUI)

// Room Size
OSCdef(\rRoomSizeFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~reverbPlugin.notNil) {
		~reverbPlugin.set(1, val);  // Param index 1: Room Size
		("[OSC] Reverb Room Size → " + val).postln;
	}
}, "/controller/r_roomsize");

// Damping
OSCdef(\rDampingFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~reverbPlugin.notNil) {
		~reverbPlugin.set(2, val);  // Param index 2: Damping
		("[OSC] Reverb Damping → " + val).postln;
	}
}, "/controller/r_damping");

// Mix
OSCdef(\rMixFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~reverbPlugin.notNil) {
		~reverbPlugin.set(0, val);  // Param index 0: Mix
		("[OSC] Reverb Mix → " + val).postln;
	}
}, "/controller/r_mix");

// Pre Delay
OSCdef(\rPreDelayFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~reverbPlugin.notNil) {
		~reverbPlugin.set(3, val);  // Param index 3: Pre Delay
		("[OSC] Reverb Pre Delay → " + val).postln;
	}
}, "/controller/r_predelay");


// 1.1.2.2 Delay Send Level (asse X stick sinistro)
OSCdef(\sendLevel2FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);
    ~sendLevel2 = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel2, ~sendLevel2); });

    ("[OSC] Delay level aggiornato: " + ~sendLevel2).postln;

}, '/controller/sendLevel2');

// === Parametri interni del plugin delay (GUI)

// Delay Time
OSCdef(\deDelayTimeFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~delayPlugin.notNil) {
		~delayPlugin.set(0, val);  // Param index 0: Delay Time
		("[OSC] Delay Time → " + val).postln;
	}
}, "/controller/de_delaytime");

// Feedback
OSCdef(\deFeedbackFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~delayPlugin.notNil) {
		~delayPlugin.set(1, val);  // Param index 1: Feedback
		("[OSC] Delay Feedback → " + val).postln;
	}
}, "/controller/de_feedback");

// Mix
OSCdef(\deMixFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~delayPlugin.notNil) {
		~delayPlugin.set(2, val);  // Param index 2: Mix
		("[OSC] Delay Mix → " + val).postln;
	}
}, "/controller/de_mix");


// 1.1.2.3 Flanger Send Level (asse Y stick destro)
OSCdef(\sendLevel3FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);
    ~sendLevel3 = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel3, newLevel) });

    ("[OSC] Flanger level aggiornato: " + newLevel).postln;

}, '/controller/sendLevel3');

// === Parametri interni del plugin Flanger (GUI)

// Dry/Wet
OSCdef(\fdrywetFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~flangerPlugin.notNil) {
		~flangerPlugin.set(0, val);
		("[OSC] Flanger dry/wet → " + val).postln;
	}
}, "/controller/f_drywet");

// Depth
OSCdef(\fdepthFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~flangerPlugin.notNil) {
		~flangerPlugin.set(1, val);
		("[OSC] Flanger depth → " + val).postln;
	}
}, "/controller/f_depth");

// Rate
OSCdef(\frateFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~flangerPlugin.notNil) {
		~flangerPlugin.set(2, val);
		("[OSC] Flanger rate → " + val).postln;
	}
}, "/controller/f_rate");

// Feedback
OSCdef(\ffeedbackFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~flangerPlugin.notNil) {
		~flangerPlugin.set(3, val);
		("[OSC] Flanger feedback → " + val).postln;
	}
}, "/controller/f_feedback");

// Amplitude
OSCdef(\famplitudeFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~flangerPlugin.notNil) {
		~flangerPlugin.set(4, val);
		("[OSC] Flanger amplitude → " + val).postln;
	}
}, "/controller/f_amplitude");





// 1.1.2.4 Distortion Send Level (asse X stick destro)
OSCdef(\sendLevel4FromController, { |msg|

    var newLevel = msg[1].clip(0, 0.3);
    ~sendLevel4 = newLevel;
    ~notes.values.do({ |synth| synth.set(\sendLevel4, newLevel) });

    ("[OSC] Distortion level aggiornato: " + newLevel).postln;

}, '/controller/sendLevel4');

// === Parametri interni del plugin Distortion (GUI)

// Drive
OSCdef(\diDriveFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~distortionPlugin.notNil) {
		~distortionPlugin.set(0, val);  // Param index 0: Drive
		("[OSC] Distortion Drive → " + val).postln;
	}
}, "/controller/di_drive");

// Tone
OSCdef(\diToneFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~distortionPlugin.notNil) {
		~distortionPlugin.set(1, val);  // Param index 1: Tone
		("[OSC] Distortion Tone → " + val).postln;
	}
}, "/controller/di_tone");

// Mix
OSCdef(\diMixFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~distortionPlugin.notNil) {
		~distortionPlugin.set(2, val);  // Param index 2: Mix
		("[OSC] Distortion Mix → " + val).postln;
	}
}, "/controller/di_mix");

// Output
OSCdef(\diOutputFromGUI, { |msg|
	var val = msg[1].clip(0, 1);
	if(~distortionPlugin.notNil) {
		~distortionPlugin.set(3, val);  // Param index 3: Output
		("[OSC] Distortion Output → " + val).postln;
	}
}, "/controller/di_output");


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

// 1.1.3 Glide (Joystick o GUI)

// 1.1.3.1 Glide Factor (es. 0.5 = -1 ottava, 2.0 = +1 ottava)
OSCdef(\glideFromController, { |msg|
	var val = msg[1];
	~glide = val;
	~notes.values.do { |s| s.set(\glide, val) };
	("[OSC] Glide factor aggiornato: " + val).postln;
}, "/controller/glide");




// 1.2.5 Modalità MONO / POLY
OSCdef(\monoModeFromGUI, { |msg|
	var val = msg[1].asInteger.clip(0, 1);
	~isMono = (val == 1);
	("[OSC] Modalità MONO attivata? " ++ ~isMono).postln;
	~osc.sendMsg("/controller/monoMode", val);

}, "/controller/monoMode");

OSCdef(\polyModeFromGUI, { |msg|
	var val = msg[1].asInteger.clip(0, 1);
	~isMono = (val == 0);  // L'opposto di mono
	("[OSC] Modalità POLY attivata? " ++ (~isMono.not)).postln;
	~osc.sendMsg("/controller/polyMode", val);

}, "/controller/polyMode");


// 1.2.6 RANDOM

OSCdef(\randomizeSynthParams, { |msg|

	"🎲 Randomizzazione parametri synth...".postln;

	~waveform1 = (~waveformNames.size.rand).clip(0, ~waveformNames.size - 1.0);
	~waveform2 = (~waveformNames.size.rand).clip(0, ~waveformNames.size - 1.0);
	~waveform3 = (~waveformNames.size.rand).clip(0, ~waveformNames.size - 1.0);

	~attack = rrand(0.005, 5.0).round(0.001);
	~decay = rrand(0.1, 5.0).round(0.01);
	~sustain = rrand(0.3, 1.0).round(0.01);
	~release = rrand(0.1, 5.0).round(0.01);
	~cutoff = rrand(0.2, 20);
	~lfoFreq = rrand(0.1, 10.0).round(0.1);
	~lfoDepth = rrand(0.0, 1.0).round(0.01);

	"→ waveforms: % | % | %".format(
		~waveformNames[~waveform1],
		~waveformNames[~waveform2],
		~waveformNames[~waveform3]
	).postln;

	("→ ADSR: A %.3f D %.3f S %.3f R %.3f".format(~attack, ~decay, ~sustain, ~release)).postln;
	("→ LFO: freq %.2fHz depth %.2f | LPF cutoff: %.1fHz".format(~lfoFreq, ~lfoDepth, ~cutoff)).postln;

	// Aggiorna i synth attivi
	~notes.values.do({ |s|
		s.set(
			\waveform1, ~waveform1,
			\waveform2, ~waveform2,
			\waveform3, ~waveform3,
			\attack, ~attack,
			\decay, ~decay,
			\sustain, ~sustain,
			\release, ~release,
			\cutoff, ~cutoff,
			\lfoFreq, ~lfoFreq,
			\lfoDepth, ~lfoDepth
		);
	});

~osc.sendMsg("/controller/waveform1", ~waveform1);
~osc.sendMsg("/controller/waveform2", ~waveform2);
~osc.sendMsg("/controller/waveform3", ~waveform3);

~osc.sendMsg("/controller/attack", ~attack);
~osc.sendMsg("/controller/decay", ~decay);
~osc.sendMsg("/controller/sustain", ~sustain);
~osc.sendMsg("/controller/release", ~release);

~osc.sendMsg("/controller/cutoff", ~cutoff);
~osc.sendMsg("/controller/lfoFreq", ~lfoFreq);
~osc.sendMsg("/controller/lfoDepth", ~lfoDepth);

}, "/controller/randomize");

// 1.2.7 RESET

OSCdef(\resetSynthParams, { |msg|

	"🔄 Reset parametri synth ai valori di default...".postln;

	~waveform1 = 0.0;
	~waveform2 = 1.0;
	~waveform3 = 2.0;

	~attack = 0.01;
	~decay = 0.3;
	~sustain = 0.5;
	~release = 0.3;
	~cutoff = 20000;
	~lfoFreq = 0.0;
	~lfoDepth = 0.0;

	("→ waveform1/2/3 reset a: " ++ ~waveformNames[0]).postln;
	("→ ADSR: A %.3f D %.3f S %.3f R %.3f".format(~attack, ~decay, ~sustain, ~release)).postln;
	("→ LFO: freq %.2fHz depth %.2f | LPF cutoff: %.1fHz".format(~lfoFreq, ~lfoDepth)).postln;

	~notes.values.do({ |s|
		s.set(
			\waveform1, ~waveform1,
			\waveform2, ~waveform2,
			\waveform3, ~waveform3,
			\attack, ~attack,
			\decay, ~decay,
			\sustain, ~sustain,
			\release, ~release,
			\cutoff, ~cutoff,
			\lfoFreq, ~lfoFreq,
			\lfoDepth, ~lfoDepth
		);
	});

~osc.sendMsg("/controller/waveform1", ~waveform1);
~osc.sendMsg("/controller/waveform2", ~waveform2);
~osc.sendMsg("/controller/waveform3", ~waveform3);

~osc.sendMsg("/controller/attack", ~attack);
~osc.sendMsg("/controller/decay", ~decay);
~osc.sendMsg("/controller/sustain", ~sustain);
~osc.sendMsg("/controller/release", ~release);

~osc.sendMsg("/controller/cutoff", 20.00);
~osc.sendMsg("/controller/lfoFreq", ~lfoFreq);
~osc.sendMsg("/controller/lfoDepth", ~lfoDepth);

}, "/controller/reset");




// === 1.2.8 RANDOM FX ===
OSCdef(\randomizeFXParams, { |msg|

	"🎲 Randomizzazione parametri FX...".postln;

	// --- REVERB (plugin param indices: 0 = Mix, 1 = Room Size, 2 = Damping, 3 = Pre Delay)
	~reverbPlugin.notNil.if {
		var mix = rrand(0.2, 1.0).round(0.01);
		//var roomSize = rrand(0.4, 1.0).round(0.01);
		var damping = rrand(0.1, 0.9).round(0.01);
		var predelay = rrand(0.0, 1.0).round(0.01);
		~reverbPlugin.set(0, mix);
		//~reverbPlugin.set(1, roomSize);
		~reverbPlugin.set(2, damping);
		~reverbPlugin.set(3, predelay);
		~osc.sendMsg("/controller/r_mix", mix);
		//~osc.sendMsg("/controller/r_roomsize", roomSize);
		~osc.sendMsg("/controller/r_damping", damping);
		~osc.sendMsg("/controller/r_predelay", predelay);
	};

	// --- DELAY (plugin param indices: 0 = Time, 1 = Feedback, 2 = Mix)
	~delayPlugin.notNil.if {
		var time = rrand(0.1, 1.0).round(0.01);
		//var fb = rrand(0.2, 0.95).round(0.01);
		var mix = rrand(0.2, 1.0).round(0.01);
		~delayPlugin.set(0, time);
		//~delayPlugin.set(1, fb);
		~delayPlugin.set(2, mix);
		~osc.sendMsg("/controller/de_delaytime", time);
		//~osc.sendMsg("/controller/de_feedback", fb);
		~osc.sendMsg("/controller/de_mix", mix);
	};

	// --- FLANGER (plugin param indices: 0 = DryWet, 1 = Depth, 2 = Rate, 3 = Feedback, 4 = Amplitude)
	~flangerPlugin.notNil.if {
		var drywet = rrand(0.2, 1.0).round(0.01);
		var depth = rrand(0.1, 1.0).round(0.01);
		var rate = rrand(0.05, 0.6).round(0.01);
		var fb = rrand(0.0, 0.95).round(0.01);
		//var amp = rrand(0.3, 1.0).round(0.01);
		~flangerPlugin.set(0, drywet);
		~flangerPlugin.set(1, depth);
		~flangerPlugin.set(2, rate);
		~flangerPlugin.set(3, fb);
		//~flangerPlugin.set(4, amp);
		~osc.sendMsg("/controller/f_drywet", drywet);
		~osc.sendMsg("/controller/f_depth", depth);
		~osc.sendMsg("/controller/f_rate", rate);
		~osc.sendMsg("/controller/f_feedback", fb);
		//~osc.sendMsg("/controller/f_amplitude", amp);
	};

	// --- DISTORTION (plugin param indices: 0 = Drive, 1 = Tone, 2 = Mix, 3 = Output)
	~distortionPlugin.notNil.if {
		var drive = rrand(0.2, 1.0).round(0.01);
		//var tone = rrand(0.1, 1.0).round(0.01);
		var mix = rrand(0.3, 1.0).round(0.01);
		var out = rrand(0.15, 0.5).round(0.01);
		~distortionPlugin.set(0, drive);
		//~distortionPlugin.set(1, tone);
		~distortionPlugin.set(2, mix);
		~distortionPlugin.set(3, out);
		~osc.sendMsg("/controller/di_drive", drive);
		//~osc.sendMsg("/controller/di_tone", tone);
		~osc.sendMsg("/controller/di_mix", mix);
		~osc.sendMsg("/controller/di_output", out);
	};

}, "/controller/randomizeFX");

OSCdef(\resetFXParams, { |msg|

	"🎲 Randomizzazione parametri FX...".postln;

	// --- REVERB (plugin param indices: 0 = Mix, 1 = Room Size, 2 = Damping, 3 = Pre Delay)
	~reverbPlugin.notNil.if {
		var mix = 0.50;
		//var roomSize = rrand(0.4, 1.0).round(0.01);
		var damping = 0.50;
		var predelay = 0.50;
		~reverbPlugin.set(0, mix);
		//~reverbPlugin.set(1, roomSize);
		~reverbPlugin.set(2, damping);
		~reverbPlugin.set(3, predelay);
		~osc.sendMsg("/controller/r_mix", mix);
		//~osc.sendMsg("/controller/r_roomsize", roomSize);
		~osc.sendMsg("/controller/r_damping", damping);
		~osc.sendMsg("/controller/r_predelay", predelay);
	};

	// --- DELAY (plugin param indices: 0 = Time, 1 = Feedback, 2 = Mix)
	~delayPlugin.notNil.if {
		var time = 0.50;
		//var fb = rrand(0.2, 0.95).round(0.01);
		var mix = 0.50;
		~delayPlugin.set(0, time);
		//~delayPlugin.set(1, fb);
		~delayPlugin.set(2, mix);
		~osc.sendMsg("/controller/de_delaytime", time);
		//~osc.sendMsg("/controller/de_feedback", fb);
		~osc.sendMsg("/controller/de_mix", mix);
	};

	// --- FLANGER (plugin param indices: 0 = DryWet, 1 = Depth, 2 = Rate, 3 = Feedback, 4 = Amplitude)
	~flangerPlugin.notNil.if {
		var drywet = 0.50;
		var depth = 0.50;
		var rate = 0.50;
		var fb = 0.50;
		//var amp = rrand(0.3, 1.0).round(0.01);
		~flangerPlugin.set(0, drywet);
		~flangerPlugin.set(1, depth);
		~flangerPlugin.set(2, rate);
		~flangerPlugin.set(3, fb);
		//~flangerPlugin.set(4, amp);
		~osc.sendMsg("/controller/f_drywet", drywet);
		~osc.sendMsg("/controller/f_depth", depth);
		~osc.sendMsg("/controller/f_rate", rate);
		~osc.sendMsg("/controller/f_feedback", fb);
		//~osc.sendMsg("/controller/f_amplitude", amp);
	};

	// --- DISTORTION (plugin param indices: 0 = Drive, 1 = Tone, 2 = Mix, 3 = Output)
	~distortionPlugin.notNil.if {
		var drive =0.50;
		//var tone = rrand(0.1, 1.0).round(0.01);
		var mix = 0.50;
		var out = 0.30;
		~distortionPlugin.set(0, drive);
		//~distortionPlugin.set(1, tone);
		~distortionPlugin.set(2, mix);
		~distortionPlugin.set(3, out);
		~osc.sendMsg("/controller/di_drive", drive);
		//~osc.sendMsg("/controller/di_tone", tone);
		~osc.sendMsg("/controller/di_mix", mix);
		~osc.sendMsg("/controller/di_output", out);
	};

}, "/controller/resetFX");

)










