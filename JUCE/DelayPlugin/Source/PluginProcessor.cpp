// 1. Inclusione Librerie
#include "PluginProcessor.h"
#include "PluginEditor.h"

// 2. Definizione Costruttore
DelayPluginAudioProcessor::DelayPluginAudioProcessor()
    : parameters(*this, nullptr, juce::Identifier("DelayParams"), {

        // 2.1 Definizione Parametri Controllabili
        std::make_unique<juce::AudioParameterFloat>("delayTime", "Delay Time", 0.2f, 800.0f, 200.0f),
        std::make_unique<juce::AudioParameterFloat>("feedback", "Feedback", 0.0f, 0.95f, 0.5f),
        std::make_unique<juce::AudioParameterFloat>("mix", "Mix", 0.0f, 1.0f, 0.5f)

    })
{}

// 3. Allocazione Buffer di Delay 
void DelayPluginAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock)
{
    delayBuffer.setSize(getTotalNumOutputChannels(), (int)(sampleRate * 2.0));
    delayBuffer.clear();
    writePosition = 0;
}

// 4. DSP
void DelayPluginAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer&)
{

    // 4.1 Dimensioni Blocco
    const int numSamples = buffer.getNumSamples();
    const int numChannels = getTotalNumInputChannels();

    // 4.1 Lettura valori correnti dei parametri
    float delayTimeMs = *parameters.getRawParameterValue("delayTime");
    float feedback = *parameters.getRawParameterValue("feedback");
    float mix = *parameters.getRawParameterValue("mix");

    // 4.2 Conversione tempo di delay (ms -> #campioni)
    const int delaySamples = static_cast<int>(getSampleRate() * delayTimeMs / 1000.0);

    // 4.3 Elaborazione per ogni canale (L/R)
    for (int ch = 0; ch < numChannels; ++ch)
    {

        float* channelData = buffer.getWritePointer(ch);
        float* delayData = delayBuffer.getWritePointer(ch);

        int localWrite = writePosition;

        // 4.3.1 ELaborazione per ogni campione
        for (int i = 0; i < numSamples; ++i)
        {

            int readPosition = (localWrite + delayBuffer.getNumSamples() - delaySamples) % delayBuffer.getNumSamples();
            float delayedSample = delayData[readPosition];

            delayData[localWrite] = channelData[i] + delayedSample * feedback;
            channelData[i] = channelData[i] * (1.0f - mix) + delayedSample * mix;

            localWrite = (localWrite + 1) % delayBuffer.getNumSamples();

        }
    }

    writePosition = (writePosition + numSamples) % delayBuffer.getNumSamples();

}

// 5. Creazione Editor GUI
juce::AudioProcessorEditor* DelayPluginAudioProcessor::createEditor()
{
    return new DelayPluginAudioProcessorEditor(*this);
}

// 6. Entrypoint Plugin 
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new DelayPluginAudioProcessor();
}
