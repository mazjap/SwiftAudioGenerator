import SwiftUI

struct ContentView: View {
    @StateObject private var soundManager = SoundManager()
    @State private var waveform: WaveformType = .square
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {
                if self.soundManager.isPlaying {
                    self.soundManager.stopPlaying()
                } else {
                    self.soundManager.startPlaying()
                }
            }) {
                Text(soundManager.isPlaying ? "Stop" : "Play")
            }
            
            VStack {
                Text("Frequency:")
                ZStack {
                    TextField(
                        "Sample Rate",
                        text: Binding {
                            "\(Int(soundManager.frequency))"
                        } set: {
                            soundManager.frequency = Double($0) ?? 440
                        }
                    )
                    .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("0")
                        Spacer()
                        Text("1000")
                    }
                }
                Slider(value: $soundManager.frequency, in: 0...1000)
            }
            
            VStack {
                Text("Amplitude:")
                ZStack {
                    TextField(
                        "Sample Rate",
                        text: Binding {
                            String(format: "%.2f", soundManager.waveform.amplitude)
                        } set: {
                            soundManager.waveform.amplitude = Float($0) ?? 0.5
                        }
                    )
                    .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("0.0")
                        Spacer()
                        Text("1.0")
                    }
                }
                Slider(value: $soundManager.waveform.amplitude, in: 0.0...1.0)
            }
            
            Picker(selection: $waveform) {
                Text("Square").tag(WaveformType.square)
                Text("Sine").tag(WaveformType.sine)
                Text("Triangle").tag(WaveformType.triangle)
                Text("Sawtooth").tag(WaveformType.sawtooth)
                Text("Reverse Sawtooth").tag(WaveformType.reverseSawtooth)
            } label: {
                Text("Waveform")
            }
            .onChange(of: waveform) {
                let oldAmp = soundManager.waveform.amplitude
                
                let algo = switch waveform {
                case .square: Waveform.square.algo
                case .sine: Waveform.sine.algo
                case .triangle: Waveform.triangle.algo
                case .sawtooth: Waveform.sawtooth.algo
                case .reverseSawtooth: Waveform.reverseSawtooth.algo
                }
                
                soundManager.waveform = Waveform(amplitude: oldAmp, algo: algo)
            }
        }
        .monospaced()
        .padding()
    }
}

#Preview {
    ContentView()
}
