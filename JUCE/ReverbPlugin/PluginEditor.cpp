// 1. Inclusione Intestazioni
#include "PluginEditor.h"

// 2. Definizione Costruttore GUI
ReverbPluginAudioProcessorEditor::ReverbPluginAudioProcessorEditor (ReverbPluginAudioProcessor& p)
    : AudioProcessorEditor (&p), processor (p)
{
    // 2.1 Dimensioni Editor
    setSize(500, 200);

    // 2.2 Configurazione mixSlider
    mixSlider.setSliderStyle(juce::Slider::Rotary);
    mixSlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    mixSlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    mixSlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);
    addAndMakeVisible(mixSlider);
    mixAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "mix", mixSlider);
    mixLabel.setText("Mix", juce::dontSendNotification);
    mixLabel.attachToComponent(&mixSlider, false);
    mixLabel.setColour(juce::Label::textColourId, juce::Colours::black);
    addAndMakeVisible(mixLabel);

    // 2.3 Configurazione roomSlider
    roomSlider.setSliderStyle(juce::Slider::Rotary);
    roomSlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    roomSlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    roomSlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);
    addAndMakeVisible(roomSlider);
    roomAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "roomSize", roomSlider);
    roomLabel.setText("Room", juce::dontSendNotification);
    roomLabel.attachToComponent(&roomSlider, false);
    roomLabel.setColour(juce::Label::textColourId, juce::Colours::black);
    addAndMakeVisible(roomLabel);

    // 2.4 Configurazione dampSlider
    dampSlider.setSliderStyle(juce::Slider::Rotary);
    dampSlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    dampSlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    dampSlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);
    addAndMakeVisible(dampSlider);
    dampAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "damping", dampSlider);
    dampLabel.setText("Damp", juce::dontSendNotification);
    dampLabel.attachToComponent(&dampSlider, false);
    dampLabel.setColour(juce::Label::textColourId, juce::Colours::black);
    addAndMakeVisible(dampLabel);
}

// 3. Definizione Distruttore
ReverbPluginAudioProcessorEditor::~ReverbPluginAudioProcessorEditor() {}

// 4. Definizione Interfaccia Grafica
void ReverbPluginAudioProcessorEditor::paint(juce::Graphics& g)
{
    g.fillAll(juce::Colour::fromRGB(255, 255, 191)); // giallo pastello
    g.setColour(juce::Colours::black);
    g.setFont(15.0f);
    g.drawFittedText("Reverb Plugin", getLocalBounds(), juce::Justification::centredTop, 1);
}

// 5. Definizione Ridimensionamento Finestra
void ReverbPluginAudioProcessorEditor::resized()
{
    auto area = getLocalBounds().reduced(40);
    auto row = area.removeFromTop(100);

    mixSlider.setBounds(row.removeFromLeft(100));
    roomSlider.setBounds(row.removeFromLeft(100));
    dampSlider.setBounds(row.removeFromLeft(100));
}

