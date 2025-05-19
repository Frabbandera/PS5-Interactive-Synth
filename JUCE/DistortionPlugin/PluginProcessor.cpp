// 1. Inclusione Intestazioni
#include "PluginProcessor.h"
#include "PluginEditor.h"

// 2. Definizione  Costruttore DSP
DistortionPluginAudioProcessor::DistortionPluginAudioProcessor()

// 2.1 Definizione Bus Audio 
#ifndef JucePlugin_PreferredChannelConfigurations
    : AudioProcessor(BusesProperties()

// 2.2 Definizione Input/Output
#if ! JucePlugin_IsMidiEffect

#if ! JucePlugin_IsSynth
        .withInput("Input", juce::AudioChannelSet::stereo(), true)
  #endif
        .withOutput("Output", juce::AudioChannelSet::stereo(), true)
  #endif
    ),

    // 2.2.1 Generazione Parametri
    parameters(*this, nullptr, juce::Identifier("Parameters"), createParameterLayout())

#endif
{}

// 3. Definizione Distruttore
DistortionPluginAudioProcessor::~DistortionPluginAudioProcessor() {}

// 4. Plugin Metadata
const juce::String DistortionPluginAudioProcessor::getName() const { return JucePlugin_Name; }
bool DistortionPluginAudioProcessor::acceptsMidi() const { return false; }
bool DistortionPluginAudioProcessor::producesMidi() const { return false; }
bool DistortionPluginAudioProcessor::isMidiEffect() const { return false; }
double DistortionPluginAudioProcessor::getTailLengthSeconds() const { return 0.0; }

// 5. Plugin Presets (non utilizzati)
int DistortionPluginAudioProcessor::getNumPrograms() { return 1; }
int DistortionPluginAudioProcessor::getCurrentProgram() { return 0; }
void DistortionPluginAudioProcessor::setCurrentProgram (int) {}
const juce::String DistortionPluginAudioProcessor::getProgramName (int) { return {}; }
void DistortionPluginAudioProcessor::changeProgramName (int, const juce::String&) {}

// 6. Inizializzazione DSP
void DistortionPluginAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
   juce::dsp::ProcessSpec spec { sampleRate, static_cast<juce::uint32> (samplesPerBlock), static_cast<juce::uint32> (getTotalNumOutputChannels()) };
    lowpassFilter.prepare(spec);
    updateFilter();
}

// 7. Disattivazione 
void DistortionPluginAudioProcessor::releaseResources() {}

// 8. Definizione Compatibilità Layout Canali
#ifndef JucePlugin_PreferredChannelConfigurations
bool DistortionPluginAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
}
#endif

// 9. DSP
void DistortionPluginAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer&)
{

    // 9.1 Lettura valori correnti dei parametri
    auto drive = parameters.getRawParameterValue("drive")->load();
    auto tone = parameters.getRawParameterValue("tone")->load();
    auto mix = parameters.getRawParameterValue("mix")->load();
    auto output = parameters.getRawParameterValue("output")->load();

    updateFilter();

    // 9.2 Elaborazione per ogni canale (L/R)
    for (int channel = 0; channel < buffer.getNumChannels(); ++channel)
    {

        auto* data = buffer.getWritePointer(channel);

        // 9.2.1 Elaborazione per ogni campione
        for (int i = 0; i < buffer.getNumSamples(); ++i)
        {

            float dry = data[i];
            float boosted = dry * drive * 3.0f;
            float wet = std::tanh(boosted * (1.0f + 0.1f * drive));
            float mixed = (1.0f - mix) * dry + mix * wet;
            data[i] = mixed * output;

        }
    }

    // 9.3 Applicazione LPF
    juce::dsp::AudioBlock<float> block(buffer);
    juce::dsp::ProcessContextReplacing<float> context(block);
    lowpassFilter.process(context);
}

// 10. Aggiornamento LPF
void DistortionPluginAudioProcessor::updateFilter()
{
    auto toneHz = parameters.getRawParameterValue("tone")->load();
    *lowpassFilter.state = *juce::dsp::IIR::Coefficients<float>::makeLowPass(getSampleRate(), toneHz);
}

// 11. GUI Editor
bool DistortionPluginAudioProcessor::hasEditor() const { return true; }
juce::AudioProcessorEditor* DistortionPluginAudioProcessor::createEditor() { return new DistortionPluginAudioProcessorEditor(*this); }

// 12. Stato Plugin
void DistortionPluginAudioProcessor::getStateInformation (juce::MemoryBlock&) {}
void DistortionPluginAudioProcessor::setStateInformation (const void*, int) {}

// 13. Entrypoint Plugin
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter() { return new DistortionPluginAudioProcessor(); }

// 14. Definizione Parametri
juce::AudioProcessorValueTreeState::ParameterLayout DistortionPluginAudioProcessor::createParameterLayout()
{
    std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;

    // Drive: 1 – 30 con step 1
    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "drive", "Drive",
        juce::NormalisableRange<float>(1.f, 30.f, 1.f),
        5.f));

    // Tone: 100 – 10000 Hz con step 100
    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "tone", "Tone",
        juce::NormalisableRange<float>(100.f, 10000.f, 100.f),
        5000.f));

    // Mix: 0.0 – 1.0 con step 0.01
    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "mix", "Mix",
        juce::NormalisableRange<float>(0.f, 1.f, 0.01f),
        0.5f));

    // Output: 0.0 – 1.0 con step 0.01
    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "output", "Output",
        juce::NormalisableRange<float>(0.f, 1.f, 0.01f),
        0.8f));

    return { params.begin(), params.end() };
}
