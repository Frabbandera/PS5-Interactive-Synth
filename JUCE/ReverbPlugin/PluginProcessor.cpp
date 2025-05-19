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
          std::make_unique<juce::AudioParameterFloat>("preDelay",  "Pre Delay", 0.0f, 0.2f, 0.0f)
      }) {}

// 3. Definizione Distruttore
ReverbPluginAudioProcessor::~ReverbPluginAudioProcessor() {}

// 4. Allocazione Buffer di preDelay (200 ms)
void ReverbPluginAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock) {

    reverb.setSampleRate(sampleRate);
    int maxDelaySamples = static_cast<int>(0.2 * sampleRate);

    preDelayBuffer.setSize(2, maxDelaySamples);
    preDelayBuffer.clear();
    preDelayWritePos = 0;

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
    reverbParams.wetLevel  = parameters.getRawParameterValue("mix")->load();
    reverbParams.dryLevel  = 1.0f - reverbParams.wetLevel;
    reverbParams.freezeMode = 0.0f;

    // 7.4 Applicazione parametri aggiornati a JUCE
    reverb.setParameters(reverbParams); 

    // 7.5 Conversione tempo di preDelay (ms -> #campioni)
    float preDelayTime = parameters.getRawParameterValue("preDelay")->load();
    int delaySamples = static_cast<int>(preDelayTime * getSampleRate());

    // 7.6 Dimensioni Blocco
    int bufferSize = buffer.getNumSamples();
    int delayBufferSize = preDelayBuffer.getNumSamples();

    // 7.7 Elaborazione per ogni canale (L/R)
    for (int channel = 0; channel < buffer.getNumChannels(); ++channel)
    {

        auto* input = buffer.getReadPointer(channel);
        auto* output = buffer.getWritePointer(channel);
        auto* delayData = preDelayBuffer.getWritePointer(channel);

        // 7.7.1 ELaborazione per ogni campione
        for (int i = 0; i < bufferSize; ++i)
        {
            int readPos = (preDelayWritePos + i - delaySamples + delayBufferSize) % delayBufferSize;
            float delayedSample = delayData[readPos];
            delayData[(preDelayWritePos + i) % delayBufferSize] = input[i];
            output[i] = delayedSample;
        }
    }

    preDelayWritePos = (preDelayWritePos + bufferSize) % delayBufferSize;

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

