import AVFoundation
import Combine

class SoundManager: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var audioSourceNode: AVAudioSourceNode?
    private var audioFormat: AVAudioFormat!
    
    @Published var waveform: Waveform = .square
    @Published var frequency: Double = 440.0
    @Published var amplitude: Float = 0.5
    @Published var sampleRate: Double = 44100.0 {
        didSet {
            audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
        }
    }

    @Published var isPlaying: Bool = false
    
    init() {
        setupAudio()
    }

    func startPlaying() {
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
                isPlaying = true
            } catch {
                print("Could not start audio engine: \(error)")
            }
        }
    }
    
    func stopPlaying() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        
        isPlaying = false
    }

    func setupAudio() {
        audioEngine.stop()
        
        audioEngine = AVAudioEngine()
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
        
        audioSourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }

            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let frameLength = Int(frameCount)
            var currentSampleTime = 0.0
            let timePerSample = 1.0 / self.sampleRate

            for frame in 0..<frameLength {
                let sampleVal = sin(2.0 * .pi * self.frequency * currentSampleTime)
                let value = Float(sampleVal) * self.amplitude

                // Generate a square wave
                let squareWaveValue = waveform.value(for: value)

                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = squareWaveValue
                }
                currentSampleTime += timePerSample
            }

            return noErr
        }

        audioEngine.attach(audioSourceNode!)
        audioEngine.connect(audioSourceNode!, to: audioEngine.mainMixerNode, format: audioFormat)
    }
}
