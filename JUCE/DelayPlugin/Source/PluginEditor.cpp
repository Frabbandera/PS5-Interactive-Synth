// 1. Inclusione Librerie
#include "PluginEditor.h"

// 2. Definizione Costruttore
DelayPluginAudioProcessorEditor::DelayPluginAudioProcessorEditor(DelayPluginAudioProcessor& p)
    : AudioProcessorEditor(&p), processor(p)
{

    // 2.1 Dimensioni Editor
    setSize(400, 300);

    auto violet = juce::Colours::violet;

    // 2.2 Configurazione Slider
    auto setupKnob = [&](juce::Slider& s, const juce::String& paramID,
                         std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment>& att) {
        
        // 2.2.1 Stile Slider
        s.setSliderStyle(juce::Slider::Rotary);
        s.setTextBoxStyle(juce::Slider::TextBoxBelow, false, 60, 20);
        s.setColour(juce::Slider::rotarySliderFillColourId, violet);

        addAndMakeVisible(s);

        // 2.2.2 Collegamento parametro-slider
        att = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(
            processor.parameters, paramID, s);
    };

    // 2.3 Inizializzazione degli slider principali
    setupKnob(delayTimeSlider, "delayTime", delayAttachment);
    setupKnob(feedbackSlider, "feedback", feedbackAttachment);
    setupKnob(mixSlider, "mix", mixAttachment);

}

// 3. Definizione Interfaccia Grafica
void DelayPluginAudioProcessorEditor::paint(juce::Graphics& g)
{

    // 3.1 Colore Sfondo
    g.fillAll(juce::Colours::black);

    // 3.2 Nome Plugin
    g.setColour(juce::Colours::white);
    g.setFont(16.0f);
    g.drawFittedText("Delay Plugin", getLocalBounds(), juce::Justification::centredTop, 1);

    g.setFont(14.0f);

    // 3.3 Etichetta sotto delayTimeSlider
    g.drawFittedText("Time",
        delayTimeSlider.getX(),
        delayTimeSlider.getBottom() + 5,
        delayTimeSlider.getWidth(),
        20,
        juce::Justification::centred,
        1);

    // 3.4 Etichetta sotto feedbackSlider
    g.drawFittedText("Feedback",
        feedbackSlider.getX(),
        feedbackSlider.getBottom() + 5,
        feedbackSlider.getWidth(),
        20,
        juce::Justification::centred,
        1);

    // 3.5 Etichetta sotto mixSlider
    g.drawFittedText("Mix",
        mixSlider.getX(),
        mixSlider.getBottom() + 5,
        mixSlider.getWidth(),
        20,
        juce::Justification::centred,
        1);

}

// 4. Definizione Ridimensionamento Finestra
void DelayPluginAudioProcessorEditor::resized()
{

    auto area = getLocalBounds().reduced(40);
    auto knobArea = area.removeFromTop(200);
    delayTimeSlider.setBounds(knobArea.removeFromLeft(100));
    feedbackSlider.setBounds(knobArea.removeFromLeft(100));
    mixSlider.setBounds(knobArea.removeFromLeft(100));

}
