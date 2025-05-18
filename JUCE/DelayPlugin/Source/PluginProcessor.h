#pragma once

// 1. Inclusione Librerie
#include <JuceHeader.h>

// 2. Dichiarazione clsse DSP principale
class DelayPluginAudioProcessor : public juce::AudioProcessor
{

public:
    DelayPluginAudioProcessor();
    ~DelayPluginAudioProcessor() override {}

    // 2.1 Metodi Essenziali 
    void prepareToPlay(double sampleRate, int samplesPerBlock) override;
    void releaseResources() override {}
    void processBlock(juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    // 2.2 Editor GUI
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override { return true; }

    const juce::String getName() const override { return JucePlugin_Name; }

    // 2.3 Capacit� MIDI
    bool acceptsMidi() const override { return false; }
    bool producesMidi() const override { return false; }
    bool isMidiEffect() const override { return false; }
    double getTailLengthSeconds() const override { return 0.0; }

    // 2.4 Presets (non utilizzati)
    int getNumPrograms() override { return 1; }
    int getCurrentProgram() override { return 0; }
    void setCurrentProgram(int index) override {}
    const juce::String getProgramName(int index) override { return {}; }
    void changeProgramName(int index, const juce::String& newName) override {}

    // 2.5 Stato Plugin
    void getStateInformation(juce::MemoryBlock& destData) override {}
    void setStateInformation(const void* data, int sizeInBytes) override {}

    juce::AudioProcessorValueTreeState parameters;

private:
    juce::AudioBuffer<float> delayBuffer;
    int writePosition = 0;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DelayPluginAudioProcessor)

};
