// === OSC_PS5_HANDLERS.SCD ===

(
// === 1. Handling Processing's OSC Messages: aggiornamento in tempo reale dei parametri del synth attivo in risposta all'interazione utente con il controller PS5 ===

// 1.1 Cutoff Frequency (L1 e R1)
OSCdef(\cutoffFromController, { |msg|

	var newCutoff = msg[1].clip(20, 20000);                     // Limita il valore tra 20Hz e 20 kHz
    ~cutoff = newCutoff;                                        // Aggiorna lo stato globale
    ~notes.values.do({ |synth|
        synth.set(\cutoff, ~cutoff);                            // Applica il nuovo valore a tutti i synth attivi
    });

	if(~cutoffSlider.notNil) {
		AppClock.sched(0, {
			~cutoffSlider.value = ~cutoff.linexp(20, 20000, 0, 1);  // Aggiornamento GUI se esiste
		});
    };

    ("[OSC] Cutoff aggiornato: " + ~cutoff).postln;             // Debug console

}, '/controller/cutoff');

// 1.2 LFO Frequency (R2 e L2)
OSCdef(\lfoFreqFromController, { |msg|

	var newFreq = msg[1].clip(0, 20);
    ~lfoFreq = newFreq;
    ~notes.values.do({ |synth|
        synth.set(\lfoFreq, ~lfoFreq);
    });

	if(~lfoFreqSlider.notNil) {
		AppClock.sched(0, {
			~lfoFreqSlider.value = ~lfoFreq.linlin(0, 20, 0, 1);
		});
    };

	("[OSC] lfoFreq aggiornato: " + ~lfoFreq).postln;

}, '/controller/lfoFreq');

// 1.3 Reverb Send Level (asse Y dello stick sinistro)
OSCdef(\sendLevel1FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);           // Limita il valore tra 0 (niente) e 1 (max send)
    ~sendLevel = newLevel;
    ~notes.values.do({ |synth|
        synth.set(\sendLevel1, ~sendLevel);     // Aggiorna sendLevel1 (riverbero) su ogni synth attivo
    });

	if(~sendLevelSlider1.notNil) {
		AppClock.sched(0, {
			~sendLevelSlider1.value = ~sendLevel;
		});
    };

    ("[OSC] sendLevel1 (riverbero) aggiornato: " + ~sendLevel).postln;

}, '/controller/sendLevel1');

// 1.4 Delay Send Level (asse X dello stick sinistro)
OSCdef(\sendLevel2FromController, { |msg|

    var newLevel = msg[1].clip(0, 1);
    ~sendLevel2 = newLevel;
    ~notes.values.do({ |synth|
        synth.set(\sendLevel2, ~sendLevel2);
    });

	if(~sendLevelSlider2.notNil) {
		AppClock.sched(0, {
			~sendLevelSlider2.value = ~sendLevel2;
		});
    };

    ("[OSC] sendLevel2 (delay) aggiornato: " + ~sendLevel2).postln;

}, '/controller/sendLevel2');
)