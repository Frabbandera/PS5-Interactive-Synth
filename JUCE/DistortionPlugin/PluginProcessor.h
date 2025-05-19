#pragma once

// 1. Inclusione Intestazioni
#include <JuceHeader.h>

// 2. Dichiarazione classe DSP principale
class DistortionPluginAudioProcessor  : public juce::AudioProcessor
{

public:
    DistortionPluginAudioProcessor();
    ~DistortionPluginAudioProcessor() override;

    // 2.1 Metodi Essenziali
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

// 2.2 Compatibilità Layout Canali
#ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
#endif

    // 2.3 Elaborazione audio
    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    // 2.4 Editor GUI
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    const juce::String getName() const override;

    // 2.5 Plugin Metadata
    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    // 2.6 Plugin Presets (non utilizzati)
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    // 2.7 Stato Plugin
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

    juce::AudioProcessorValueTreeState parameters;
    static juce::AudioProcessorValueTreeState::ParameterLayout createParameterLayout();

private:
    void updateFilter();

    juce::dsp::ProcessorDuplicator<juce::dsp::IIR::Filter<float>,
                                   juce::dsp::IIR::Coefficients<float>> lowpassFilter;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (DistortionPluginAudioProcessor)

};
