#pragma once

// 1. Inclusione Intestazioni
#include <JuceHeader.h>
#include "PluginProcessor.h"

// 2. Definizione Classe GUI
class ReverbPluginAudioProcessorEditor  : public juce::AudioProcessorEditor
{

public:
    ReverbPluginAudioProcessorEditor (ReverbPluginAudioProcessor&);
    ~ReverbPluginAudioProcessorEditor() override;

    void paint (juce::Graphics&) override;
    void resized() override;

private:
    ReverbPluginAudioProcessor& processor;

    juce::Slider mixSlider, roomSlider, dampSlider, preDelaySlider;

    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> mixAttach;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> roomAttach;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> dampAttach;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> preAttach;

    juce::Label mixLabel, roomLabel, dampLabel, preLabel;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (ReverbPluginAudioProcessorEditor)

};
