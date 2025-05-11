// === LAYERED_SYNTHESIS.SCD ===

// === 1. SynthDef: definizione del SynthDef interattivo a tre oscillatori indipendenti,
//                  con manipolazione del segnale (ADSR, LFO, LPF) e doppio send verso bus di effetti (reverb/delay) ===

SynthDef(\interactiveSynth, {

	|freq = 440, amp = 0.5, waveform1 = 0, waveform2 = 0, waveform3 = 0,
	attack = 0.01, decay = 0.3, sustain = 0.5, release = 0.3, gate = 1,
    cutoff = 20000, lfoFreq = 0, lfoDepth = 0,
    out = 0, fxSendBus1 = 0, fxSendBus2 = 0, sendLevel1 = 0.3, sendLevel2 = 0.2,
    octave1 = 0, octave2 = 0, octave3 = 0,
    level1 = 0.3, level2 = 0.3, level3 = 0.3|

    var sig1, sig2, sig3, sig, env, lfo;

	// 1.1 Oscillatori

	// Oscillatore 1
    sig1 = Select.ar(waveform1.clip(0, 5), [  // Selezione della forma d'onda tramite Select.ar in base all'indice waveform1
        SinOsc.ar(freq * (2 ** octave1)),     // Sine
        Saw.ar(freq * (2 ** octave1)),        // Sawtooth
        Pulse.ar(freq * (2 ** octave1), 0.5), // Square
        LFTri.ar(freq * (2 ** octave1)),      // Triangle
        LFSaw.ar(freq * (2 ** octave1)),      // Low-frequency saw
        Blip.ar(freq * (2 ** octave1), 5)     // Band-limited impulse train
    ]) * level1;                              // Volume individuale per Osc 1

	// Oscillatore 2
    sig2 = Select.ar(waveform2.clip(0, 5), [
        SinOsc.ar(freq * (2 ** octave2)),
        Saw.ar(freq * (2 ** octave2)),
        Pulse.ar(freq * (2 ** octave2), 0.5),
        LFTri.ar(freq * (2 ** octave2)),
        LFSaw.ar(freq * (2 ** octave2)),
        Blip.ar(freq * (2 ** octave2), 5)
    ]) * level2;

	// Oscillatore 3
    sig3 = Select.ar(waveform3.clip(0, 5), [
        SinOsc.ar(freq * (2 ** octave3)),
        Saw.ar(freq * (2 ** octave3)),
        Pulse.ar(freq * (2 ** octave3), 0.5),
        LFTri.ar(freq * (2 ** octave3)),
        LFSaw.ar(freq * (2 ** octave3)),
        Blip.ar(freq * (2 ** octave3), 5)
    ]) * level3;

    // 1.2 Somma e normalizzazione
    sig = (sig1 + sig2 + sig3);

    // 1.3 Inviluppo ADSR
    env = Env.adsr(attack, decay, sustain, release);   // Costruzione inviluppo
    sig = sig * EnvGen.kr(env, gate, doneAction: 2);   // Applica l’inviluppo e libera il synth a fine nota

    // 1.4 Modulazione LFO
    lfo = (1 + (SinOsc.kr(lfoFreq) * lfoDepth)) * 0.5; // Modulazione ampiezza LFO (da 0 a 1)
    sig = sig * lfo;                                   // Applica la modulazione LFO al segnale

    // 1.5 LPF
    sig = LPF.ar(sig, cutoff);                         // Filtraggio del segnale

    // 1.6 Output
    Out.ar(out, sig!2);                                // Uscita principale stereo
    Out.ar(fxSendBus1, sig * sendLevel1);              // Send al bus FX 1 (reverb)
    Out.ar(fxSendBus2, sig * sendLevel2);              // Send al bus FX 2 (delay)

}).add;