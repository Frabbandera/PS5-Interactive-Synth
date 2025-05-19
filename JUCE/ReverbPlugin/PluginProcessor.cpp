// 1. Inclusione Intestazioni
#include "PluginProcessor.h"
#include "PluginEditor.h"

// 2. Definizione Costruttore DSP
ReverbPluginAudioProcessor::ReverbPluginAudioProcessor() 
    
    // 2.1 Configurazione input/output (1 bus stereo per ognuno)
    : AudioProcessor (BusesProperties()
                      .withInput ("Input",  juce::AudioChannelSet::stereo(), true)
                      .withOutput("Output", juce::AudioChannelSet::stereo(), true)),

    // 2.2 Definizione Parametri Controllabili
      parameters(*this, nullptr, juce::Identifier("ReverbParams"), //crea i parametri
      {
          std::make_unique<juce::AudioParameterFloat>("mix",       "Mix",       0.0f, 1.0f, 0.5f),
          std::make_unique<juce::AudioParameterFloat>("roomSize",  "Room Size", 0.0f, 1.0f, 0.5f),
          std::make_unique<juce::AudioParameterFloat>("damping",   "Damping",   0.0f, 1.0f, 0.5f),
      }) {}

// 3. Definizione Distruttore
ReverbPluginAudioProcessor::~ReverbPluginAudioProcessor() {}

// 4. Allocazione Buffer di preDelay (200 ms)
void ReverbPluginAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock) {

    reverb.setSampleRate(sampleRate);

}

// 5. Disattivazione 
void ReverbPluginAudioProcessor::releaseResources() {} 

// 6. Definizione compatibilità Layout Canali (stereo)
bool ReverbPluginAudioProcessor::isBusesLayoutSupported(const BusesLayout& layouts) const {
    return layouts.getMainOutputChannelSet() == juce::AudioChannelSet::stereo(); //assicura che il plugin venga usato solo in modalità stereo
}

// 7. DSP
void ReverbPluginAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer&) {
   
    juce::ScopedNoDenormals noDenormals; 

    // 7.1 Recupero numero canali input/output attivi
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    // 7.2 Pulizia canali di uscita non utilizzati
    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i) 
        buffer.clear(i, 0, buffer.getNumSamples());

    // 7.3 Lettura valori correnti dei parametri
    reverbParams.roomSize  = parameters.getRawParameterValue("roomSize")->load();
    reverbParams.damping   = parameters.getRawParameterValue("damping")->load();
    reverbParams.width = 1.0f;        // Espansione stereo
    reverbParams.freezeMode = 0.0f;   // Lasciato a 0, ma potrebbe diventare interattivo
    reverbParams.wetLevel = parameters.getRawParameterValue("mix")->load();
    reverbParams.dryLevel = 1.0f;     // Mantieni sempre il dry, oppure rendilo parametrico
    reverbParams.freezeMode = 0.0f;

    // 7.4 Applicazione parametri aggiornati a JUCE
    reverb.setParameters(reverbParams); 

   // 7.5 - 7.6 - 7.7
    for (int channel = 0; channel < buffer.getNumChannels(); ++channel) {
    auto* input = buffer.getReadPointer(channel);
    auto* output = buffer.getWritePointer(channel);
    juce::FloatVectorOperations::copy(output, input, buffer.getNumSamples());
}
    
    
    // 7.8 Applicazione Riverbero
    reverb.processStereo(buffer.getWritePointer(0), buffer.getWritePointer(1), buffer.getNumSamples());

}

// 8. Creazione Editor GUI
juce::AudioProcessorEditor* ReverbPluginAudioProcessor::createEditor() { //Collega il plugin alla GUI (definita nel PluginEditor)
    return new ReverbPluginAudioProcessorEditor (*this);
}

bool ReverbPluginAudioProcessor::hasEditor() const { return true; }

// 9. Plugin Metadata
const juce::String ReverbPluginAudioProcessor::getName() const { return JucePlugin_Name; }
bool ReverbPluginAudioProcessor::acceptsMidi() const { return false; }
bool ReverbPluginAudioProcessor::producesMidi() const { return false; }
bool ReverbPluginAudioProcessor::isMidiEffect() const { return false; }
double ReverbPluginAudioProcessor::getTailLengthSeconds() const { return 1.0; }

// 10. Plugin Presets (non utilizzati)
int ReverbPluginAudioProcessor::getNumPrograms() { return 1; }
int ReverbPluginAudioProcessor::getCurrentProgram() { return 0; }
void ReverbPluginAudioProcessor::setCurrentProgram (int) {}
const juce::String ReverbPluginAudioProcessor::getProgramName (int) { return {}; }
void ReverbPluginAudioProcessor::changeProgramName (int, const juce::String&) {}

// 11. Stato Plugin
void ReverbPluginAudioProcessor::getStateInformation (juce::MemoryBlock& destData) { //Converte i parametri correnti in un blocco binario da salvare
    
    auto state = parameters.copyState();
    std::unique_ptr<juce::XmlElement> xml (state.createXml());
    copyXmlToBinary (*xml, destData);

}

void ReverbPluginAudioProcessor::setStateInformation (const void* data, int sizeInBytes) { //Ricarica i parametri precedentemente salvati da un preset o progetto
    
    std::unique_ptr<juce::XmlElement> xmlState (getXmlFromBinary (data, sizeInBytes));

    if (xmlState != nullptr && xmlState->hasTagName (parameters.state.getType())) {
        parameters.replaceState (juce::ValueTree::fromXml (*xmlState));
    }
}

// 12. Entrypoint Plugin
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter() 
{
    return new ReverbPluginAudioProcessor();
}

