// === EFFECTS_CONTROL.SCD ===

(
// === 1. Controllo plugins: istanziamento e apertura degli effetti nel server audio ===

// 1.1 FX Reverb

// Crystalline (VST esterno)
~fxReverb = Synth(\crystallineFX, [\inBus, ~fxBus1, \out, 0], ~fxGroup);     // Crea un'istanza del SynthDef \crystallineFX, ricevendo segnale da ~fxBus1 e mandandolo in uscita

~crystallinePath = "C:/Program Files/VSTPlugins/Baby Audio/Crystalline.dll"; // Specifica il percorso del plugin VST .dll sul sistema
~crystalline = VSTPluginController(~fxReverb, id: \crystalline);             // Collega un controller VST all'istanza Synth appena creata
~crystalline.open(~crystallinePath, editor: true, verbose: true);            // Apre il plugin dal percorso indicato, mostra l'interfaccia grafica, stampa info dettagliate
~crystalline.editor;                                                         // Visualizza l'editor del plugin (utile per debugging o modifiche live)

// ValhallaRoom (VST esterno)
/*
~fxReverb = Synth(\valhallaRoomFX, [\inBus, ~fxBus1, \out, 0], ~fxGroup);

~valhallaPath = "C:/Program Files/Steinberg/VSTPlugins/ValhallaDSP/ValhallaRoom_x64.dll";
~valhalla = VSTPluginController(~fxReverb, id: \valhalla);
~valhalla.open(~valhallaPath, editor: true, verbose: true);
~valhalla.editor;
*/

// 1.2 FX Delay

// simpleFXDelay (nativo SC)
~fxDelay = Synth(\simpleFXDelay, [\inBus, ~fxBus2, \out, 0], ~fxGroup);
)