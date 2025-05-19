#pragma once

// 1. Inclusione Intestazioni
#include <JuceHeader.h>
#include "PluginProcessor.h"

// 2. Definizione Classe GUI
class DelayPluginAudioProcessorEditor : public juce::AudioProcessorEditor
{

public:
    DelayPluginAudioProcessorEditor(DelayPluginAudioProcessor&);
    ~DelayPluginAudioProcessorEditor() override {}

    void paint(juce::Graphics&) override;
    void resized() override;

private:
    DelayPluginAudioProcessor& processor;

    juce::Slider delayTimeSlider, feedbackSlider, mixSlider;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> delayAttachment, feedbackAttachment, mixAttachment;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DelayPluginAudioProcessorEditor)

};
