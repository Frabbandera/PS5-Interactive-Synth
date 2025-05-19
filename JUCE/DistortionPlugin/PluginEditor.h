#pragma once

// 1. Inclusione Librerie
#include <JuceHeader.h>
#include "PluginProcessor.h"

// 2. Definizione classe GUI
class DistortionPluginAudioProcessorEditor  : public juce::AudioProcessorEditor
{

public:
    DistortionPluginAudioProcessorEditor (DistortionPluginAudioProcessor&);
    ~DistortionPluginAudioProcessorEditor() override;

    void paint (juce::Graphics&) override;
    void resized() override;

private:
    DistortionPluginAudioProcessor& audioProcessor;

    juce::Slider driveSlider, toneSlider, mixSlider, outputSlider;

    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> driveAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> toneAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> mixAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> outputAttachment;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (DistortionPluginAudioProcessorEditor)

};
