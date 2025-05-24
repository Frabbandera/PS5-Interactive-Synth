// === MAIN.SCD ===

(
// === 1. Entry point principale del progetto: inizializza i parametri globali, definisce bus e gruppi, e carica i moduli core (sintesi ed effetti di base) ===

// 1.1 Parametri Globali (condivisi da Synth, GUI, MIDI e OSC)
~waveformNames = ["Sine", "Saw", "Square", "LFTri", "LFSaw", "Blip"];      // Nomi forme d'onda disponibili
~waveform1 = 0; ~waveform2 = 1; ~waveform3 = 2;                            // Selezione forma d'onda iniziale per i tre oscillatori
~octave1 = 0; ~octave2 = 0; ~octave3 = 0;                                  // Trasposizione in ottave dei tre oscillatori
~cutoff = 20000; ~lfoFreq = 0; ~lfoDepth = 0.5;                            // Parametri filtro e LFO
~sendLevel = 0.3; ~sendLevel2 = 0.3; ~sendLevel3 = 0.3; ~sendLevel4 = 0.3; // Livelli di invio ai bus FX
~attack = 0.01; ~decay = 0.3; ~sustain = 0.5; ~release = 0.3;              // Parametri ADSR dell'inviluppo
~level1 = 0.3; ~level2 = 0.3; ~level3 = 0.3;                              // Volume individuale dei tre oscillatori
~notes = IdentityDictionary.new;                                           // Dizionario per tracciare le note attive (noteOn/noteOff)

~projectRoot = PathName(thisProcess.nowExecutingPath).pathOnly;         // Definizione del path progetto

s.waitForBoot {

	// 1.2 Bus audio per l’invio ai due effetti principali (reverb e delay)
    ~fxBus1 = Bus.audio(s, 2);     // Bus stereo per riverbero
    ~fxBus2 = Bus.audio(s, 2);     // Bus stereo per delay
	~fxBus3 = Bus.audio(s, 2);     // Bus stereo per flanger
    ~fxBus4 = Bus.audio(s, 2);     // Bus stereo per distortion

    // 1.3 Gruppi di sintesi, effetti e master
    ~masterGroup = Group.tail(s);                  // Gruppo di uscita finale
    ~fxGroup = Group.before(~masterGroup);         // Gruppo per effetti, posizionato prima del master
    ~synthGroup = Group.before(~fxGroup);          // Gruppo per synth, posizionato prima degli effetti

	// 1.4 Caricamento moduli core
    (~projectRoot ++ "SynthDefs/Layered_Synthesis.scd").load;    // SynthDef principale (3 oscillatori)
    (~projectRoot ++ "Effects/Effects_Definition.scd").load;     // Definizione dei SynthDef di effetti (reverb/delay)

	s.sync;  // Sincronizza il server per assicurare che tutto sia caricato prima di proseguire

};
)

(
// 2. Moduli di controllo: caricamento dei moduli che richiedono server già attivo e synthdef disponibili ===

(~projectRoot ++ "Effects/Effects_Control.scd").load;            // Apertura e controllo dei plugin VST
(~projectRoot ++ "Handlers/MIDI_Handlers.scd").load;             // Gestione input da tastiera MIDI
(~projectRoot ++ "Handlers/OSC_PS5_Handlers.scd").load;          // Gestione dei messaggi OSC inviati da Processing (PS5)
)

(
// 3. Visualizzazione Editor FX-Plugins (facoltativo)

~reverbPlugin.editor;
~delayPlugin.editor;
~flangerPlugin.editor;
~distortionPlugin.editor;
)
