// === EFFECTS_DEFINITION.SCD ===

(
// === 1. SynthDef: definizione dei SynthDef relativi agli effetti audio da caricare nel progetto (input: dry signal, output: wet signal) ===

// 1.1 FX Reverb

// Crystalline (VST esterno)
SynthDef(\crystallineFX, {

    |inBus = 0, out = 0|                              // Bus di ingresso e uscita
    var in = In.ar(inBus, 2);                         // Acquisisce segnale stereo dal bus inBus
    var wet = VSTPlugin.ar(in, 2, id: \crystalline);  // Applica il plugin VST con ID \crystalline
    Out.ar(out, wet);                                 // Invia il segnale wet in uscita

}).add;

// ValhallaRoom (VST esterno)
/*
SynthDef(\valhallaRoomFX, {

    |inBus = 0, out = 0|
    var in = In.ar(inBus, 2);
    var wet = VSTPlugin.ar(in, 2, id: \valhalla);
    Out.ar(out, wet);

}).add;
*/

// 1.2 FX Delay

// simpleFXDelay (nativo SC)
SynthDef(\simpleFXDelay, {

    |inBus = 0, out = 0|
    var in = In.ar(inBus, 2);
    var wet = CombC.ar(in, 0.5, 0.3, 3);      // Delay con lunghezza max 0.5s, delay time 0.3s, decay 3s
    Out.ar(out, wet);

}).add;
)