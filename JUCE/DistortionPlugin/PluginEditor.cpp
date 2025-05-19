// 1. Inclusione Intestazioni
#include "PluginProcessor.h"
#include "PluginEditor.h"

// 2. Definizione Costruttore GUI
DistortionPluginAudioProcessorEditor::DistortionPluginAudioProcessorEditor (DistortionPluginAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{

    // 2.1 Dimensioni Editor
    setSize(500, 300);

    auto& params = audioProcessor.parameters;

    // 2.2 Configurazione Slider
    auto setupSlider = [&](juce::Slider& slider, const juce::String& paramId, auto& attachment, const juce::String& name)
    {

        // 2.2.1 Stile Slider
        slider.setSliderStyle(juce::Slider::Rotary);
        slider.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
        slider.setColour(juce::Slider::thumbColourId, juce::Colours::darkred);
        slider.setColour(juce::Slider::rotarySliderFillColourId, juce::Colours::red);
        slider.setName(name);

        addAndMakeVisible(slider);

        // 2.2.2 Collegamento parametro-slider
        attachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(params, paramId, slider);
    };

    // 2.3 Inizializzazione degli slider principali
    setupSlider(driveSlider, "drive", driveAttachment, "Drive");
    setupSlider(toneSlider, "tone", toneAttachment, "Tone");
    setupSlider(mixSlider, "mix", mixAttachment, "Mix");
    setupSlider(outputSlider, "output", outputAttachment, "Output");

}

DistortionPluginAudioProcessorEditor::~DistortionPluginAudioProcessorEditor() {}

// 3. Definizione Interfaccia Grafica
void DistortionPluginAudioProcessorEditor::paint (juce::Graphics& g)
{

    // 3.1 Colore Sfondo
    g.fillAll(juce::Colours::darkred);

    // 3.2 Nome Plugin
    g.setColour(juce::Colours::white);
    g.setFont(16.0f);
    g.drawFittedText("Distortion Plugin", getLocalBounds(), juce::Justification::centredTop, 1);

    g.setFont(14.0f);

    // 3.3 Etichetta sotto DriveSlider
    g.drawFittedText("Drive", 
        driveSlider.getX(), 
        driveSlider.getY() - 20, 
        driveSlider.getWidth(), 20, 
        juce::Justification::centred, 1);

    // 3.4 Etichetta sotto ToneSlider
    g.drawFittedText("Tone", 
        toneSlider.getX(), 
        toneSlider.getY() - 20, 
        toneSlider.getWidth(), 20, 
        juce::Justification::centred, 1);

    // 3.5 Etichetta sotto MixSlider 
    g.drawFittedText("Mix", 
        mixSlider.getX(), 
        mixSlider.getY() - 20, 
        mixSlider.getWidth(), 20, 
        juce::Justification::centred, 1);

    // 3.6 Etichetta sotto OutputSlider
    g.drawFittedText("Output", 
        outputSlider.getX(), 
        outputSlider.getY() - 20, 
        outputSlider.getWidth(), 20, 
        juce::Justification::centred, 1);

}

// 4. Definizione Ridimensionamento Finestra
void DistortionPluginAudioProcessorEditor::resized()
{

    driveSlider.setBounds(20, 80, 100, 100);
    toneSlider.setBounds(140, 80, 100, 100);
    mixSlider.setBounds(260, 80, 100, 100);
    outputSlider.setBounds(380, 80, 100, 100);

}
