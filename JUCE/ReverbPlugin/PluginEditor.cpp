// 1. Inclusione Intestazioni
#include "PluginEditor.h"

// 2. Definizione Costruttore GUI
ReverbPluginAudioProcessorEditor::ReverbPluginAudioProcessorEditor (ReverbPluginAudioProcessor& p)
    : AudioProcessorEditor (&p), processor (p)
{

    // 2.1 Dimensioni Editor
    setSize(500, 200);

    // 2.2 Configurazione mixSlider

    // 2.2.1 Stile Slider
    mixSlider.setSliderStyle(juce::Slider::Rotary);
    mixSlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    mixSlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    mixSlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);

    addAndMakeVisible(mixSlider);

    // 2.2.2 Collegamento parametro-slider
    mixAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "mix", mixSlider);
    
    // 2.2.3 Definizione Etichetta Slider
    mixLabel.setText("Mix", juce::dontSendNotification);
    mixLabel.attachToComponent(&mixSlider, false);
    mixLabel.setColour(juce::Label::textColourId, juce::Colours::black);

    addAndMakeVisible(mixLabel);

    // 2.3 Configurazione roomSlider

    // 2.3.1 Stile Slider
    roomSlider.setSliderStyle(juce::Slider::Rotary);
    roomSlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    roomSlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    roomSlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);
    
    addAndMakeVisible(roomSlider);

    // 2.3.2 Collegamento parametro-slider
    roomAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "roomSize", roomSlider);
    
    // 2.3.3 Definizione Etichetta Slider
    roomLabel.setText("Room", juce::dontSendNotification);
    roomLabel.attachToComponent(&roomSlider, false);
    roomLabel.setColour(juce::Label::textColourId, juce::Colours::black);

    addAndMakeVisible(roomLabel);

    // 2.4 Configurazione dampSlider

    // 2.4.1 Stile Slider
    dampSlider.setSliderStyle(juce::Slider::Rotary);
    dampSlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    dampSlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    dampSlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);

    addAndMakeVisible(dampSlider);

    // 2.4.2 Collegamento parametro-slider
    dampAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "damping", dampSlider);
    
    // 2.4.3 Definizione Etichetta Slider
    dampLabel.setText("Damp", juce::dontSendNotification);
    dampLabel.attachToComponent(&dampSlider, false);
    dampLabel.setColour(juce::Label::textColourId, juce::Colours::black);
    addAndMakeVisible(dampLabel);

    // 2.5 Configurazione preDelaySlider

    // 2.5.1 Stile Slider
    preDelaySlider.setSliderStyle(juce::Slider::Rotary);
    preDelaySlider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
    preDelaySlider.setColour(juce::Slider::thumbColourId, juce::Colours::yellow);
    preDelaySlider.setColour(juce::Slider::textBoxTextColourId, juce::Colours::black);

    addAndMakeVisible(preDelaySlider);

    // 2.5.2 Collegamento parametro-slider
    preAttach = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(processor.parameters, "preDelay", preDelaySlider);
    
    // 2.5.3 Definizione Etichetta Slider
    preLabel.setText("PreDelay", juce::dontSendNotification);
    preLabel.attachToComponent(&preDelaySlider, false);
    preLabel.setColour(juce::Label::textColourId, juce::Colours::black);
    addAndMakeVisible(preLabel);

}

// 3. Definizione Distruttore
ReverbPluginAudioProcessorEditor::~ReverbPluginAudioProcessorEditor() {}

// 4. Definizione Interfaccia Grafica
void ReverbPluginAudioProcessorEditor::paint (juce::Graphics& g)
{

    // 4.1 Colore Sfondo
    g.fillAll(juce::Colour::fromRGB(255, 255, 191)); // giallo pastello

    // 4.2 Nome Plugin
    g.setColour (juce::Colours::black);
    g.setFont (15.0f);
    g.drawFittedText ("Reverb Plugin", getLocalBounds(), juce::Justification::centredTop, 1);

}

// 5. Definizione Ridimensionamento Finestra
void ReverbPluginAudioProcessorEditor::resized()
{

    auto area = getLocalBounds().reduced(40);
    auto row = area.removeFromTop(100);

    mixSlider.setBounds(row.removeFromLeft(100));
    roomSlider.setBounds(row.removeFromLeft(100));
    dampSlider.setBounds(row.removeFromLeft(100));
    preDelaySlider.setBounds(row.removeFromLeft(100));

}
