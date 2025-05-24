// === EFFECTS_DEFINITION.SCD ===

(
// === 1. SynthDef: definizione dei SynthDef relativi agli effetti audio da caricare nel progetto (input: dry signal, output: wet signal) ===

// 1.1 FX Reverb (JUCE)
SynthDef(\reverbPluginFX, {

    |inBus = 0, out = 0|                               // Bus di ingresso e uscita
    var in = In.ar(inBus, 2);                          // Acquisisce segnale stereo dal bus inBus
    var wet = VSTPlugin.ar(in, 2, id: \reverbplugin);  // Applica il plugin VST con ID \crystalline
    Out.ar(out, wet);                                  // Invia il segnale wet in uscita

}).add;

// 1.2 FX Delay (JUCE)
SynthDef(\simpleFXDelay, {

	|inBus = 0, out = 0|
    var in = In.ar(inBus, 2);
    var wet = VSTPlugin.ar(in, 2, id: \delayplugin);
    Out.ar(out, wet);

}).add;

// 1.3 FX Flanger (JUCE)
/*
SynthDef(\flangerFX, {

    |inBus = 0, out = 0|
    var in = In.ar(inBus, 2);
    var modL = SinOsc.kr(0.2, 0, 0.003, 0.003);
    var modR = SinOsc.kr(0.2, pi, 0.003, 0.003);
    var wetL = DelayC.ar(in[0], 0.01, modL);
    var wetR = DelayC.ar(in[1], 0.01, modR);
    Out.ar(out, [wetL, wetR]);

}).add;
*/

SynthDef(\flangerPluginFX, {

	|inBus = 0, out = 0|
    var in = In.ar(inBus, 2);
    var wet = VSTPlugin.ar(in, 2, id: \flangerplugin);
    Out.ar(out, wet);

}).add;

// 1.4 FX Distortion (JUCE)
SynthDef(\distortionPluginFX, {

	|inBus = 0, out = 0|
    var in = In.ar(inBus, 2);
    var wet = VSTPlugin.ar(in, 2, id: \distortionplugin);
    Out.ar(out, wet);

}).add;
)
