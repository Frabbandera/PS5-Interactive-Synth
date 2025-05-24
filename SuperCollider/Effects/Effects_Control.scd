// === EFFECTS_CONTROL.SCD ===

(
// === 1. Controllo plugins: istanziamento e apertura degli effetti nel server audio ===

// 1.1 FX Reverb (JUCE)
~fxReverb = Synth(\reverbPluginFX, [\inBus, ~fxBus1, \out, 0.5], ~fxGroup);     // Crea un'istanza del SynthDef \ReverbPluginFX, ricevendo segnale da ~fxBus1 e mandandolo in uscita
~reverbPluginPath = "C:/Program Files/Common Files/VST3/Riverb_prova.vst3";     // Specifica il percorso del plugin VST .vst3 sul sistema
~reverbPlugin = VSTPluginController(~fxReverb, id: \reverbplugin);              // Collega un controller VST all'istanza Synth appena creata
~reverbPlugin.open(~reverbPluginPath, editor: true, verbose: true);             // Apre il plugin dal percorso indicato, mostra l'interfaccia grafica, stampa info dettagliate

// 1.2 FX Delay (JUCE)
~fxDelay = Synth(\simpleFXDelay, [\inBus, ~fxBus2, \out, 0.5], ~fxGroup);
~delayPluginPath = "C:/Program Files/Common Files/VST3/DelayPlugin.vst3";
~delayPlugin = VSTPluginController(~fxDelay, id: \delayplugin);
~delayPlugin.open(~delayPluginPath, editor: true, verbose: true);

// 1.3 FX Flanger (JUCE)
//~fxFlanger = Synth(\flangerFX, [\inBus, ~fxBus3, \out, 0.5], ~fxGroup);

~fxFlanger = Synth(\flangerPluginFX, [\inBus, ~fxBus3, \out, 0.5], ~fxGroup);
~flangerPluginPath = "C:/Program Files/Common Files/VST3/FlangerPlugin.vst3";
~flangerPlugin = VSTPluginController(~fxFlanger, id: \flangerplugin);
~flangerPlugin.open(~flangerPluginPath, editor: true, verbose: true);

// 1.4 FX Distortion (JUCE)
~fxDistortion = Synth(\distortionPluginFX, [\inBus, ~fxBus4, \out, 0.5], ~fxGroup);
~distortionPluginPath = "C:/Program Files/Common Files/VST3/DistortionPlugin.vst3";
~distortionPlugin = VSTPluginController(~fxDistortion, id: \distortionplugin);
~distortionPlugin.open(~distortionPluginPath, editor: true, verbose: true);
)
