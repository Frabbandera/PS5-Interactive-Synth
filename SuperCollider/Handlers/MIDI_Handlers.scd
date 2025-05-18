// === MIDI_HANDLERS.SCD ===

(
// === 1. Gestione protocollo MIDI: inizializzazione sistema MIDI e definizione comportamento in relazione agli eventi MIDI noteOn e noteOff ===

// 1.1 Inizializzazione MIDI
MIDIClient.init;            // Inizializza il client MIDI di SuperCollider
MIDIIn.connectAll;          // Collega tutti i dispositivi MIDI in ingresso disponibili

// 1.2 Gestione nota ON
~noteOn = MIDIFunc.noteOn({ |vel, note, chan, src|

    ~notes[note] = Synth(\interactiveSynth, [       // Crea un nuovo Synth \interactiveSynth e lo memorizza nel dizionario

		\freq, note.midicps,                        // Converte la nota MIDI in frequenza in Hz
        \amp, vel / 127,                            // Converte la velocity in ampiezza (range 0–1)

        // Parametri forma d’onda e ottava per ciascun oscillatore
        \waveform1, ~waveform1, \waveform2, ~waveform2, \waveform3, ~waveform3,
        \octave1, ~octave1, \octave2, ~octave2, \octave3, ~octave3,

        // Volume dei singoli oscillatori
        \level1, ~level1, \level2, ~level2, \level3, ~level3,

        // Inviluppo ADSR
        \attack, ~attack, \decay, ~decay, \sustain, ~sustain, \release, ~release,

        // LPF e LFO
        \cutoff, ~cutoff, \lfoFreq, ~lfoFreq, \lfoDepth, ~lfoDepth,

        // Routing verso gli effetti
       \sendLevel1, ~sendLevel, \sendLevel2, ~sendLevel2, \sendLevel3, ~sendLevel3, \sendLevel4, ~sendLevel4,
       \out, 0,
       \fxSendBus1, ~fxBus1, \fxSendBus2, ~fxBus2, \fxSendBus3, ~fxBus3, \fxSendBus4, ~fxBus4


    ], ~synthGroup);  // allocazione synth all’interno del gruppo ~synthGroup

});

// 1.3 Gestione nota OFF
~noteOff = MIDIFunc.noteOff({ |vel, note, chan, src|

    var s = ~notes[note];            // Recupera il synth associato a quella nota
    if (s.notNil) {
        s.set(\gate, 0);             // Chiude l’inviluppo impostando gate = 0 (doneAction: 2 lo libera)
        ~notes.removeAt(note);       // Rimuove il synth dal dizionario
    };

});
)
