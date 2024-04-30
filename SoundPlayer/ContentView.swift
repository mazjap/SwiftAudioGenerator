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
                Text("Sample Rate:")
                HStack {
                    Text("22050")
                    Spacer()
                    Text("\(Int(soundManager.sampleRate))")
                    Spacer()
                    Text("66150")
                }
                Slider(value: $soundManager.sampleRate, in: 22050.0...66150.0)
            }
            
            VStack {
                Text("Frequency:")
                HStack {
                    Text("000")
                    Spacer()
                    Text("\(Int(soundManager.frequency))")
                    Spacer()
                    Text("880")
                }
                Slider(value: $soundManager.frequency, in: 0...880)
            }
            
            VStack {
                Text("Amplitude:")
                HStack {
                    Text("0.0")
                    Spacer()
                    Text(String(format: "%.2f", soundManager.amplitude))
                    Spacer()
                    Text("1.0")
                }
                Slider(value: $soundManager.amplitude, in: 0.0...1.0)
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
                soundManager.waveform = switch waveform {
                case .square: .square
                case .sine: .sine
                case .triangle: .triangle
                case .sawtooth: .sawtooth
                case .reverseSawtooth: .reverseSawtooth
                }
            }
        }
        .monospaced()
        .padding()
    }
}

#Preview {
    ContentView()
}
