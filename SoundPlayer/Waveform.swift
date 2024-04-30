import Foundation

struct Waveform {
    private let algo: (Float, Float) -> Float
    private let amplitude: Float
    
    func value(for input: Float) -> Float {
        return algo(input, amplitude)
    }
    
    init(amplitude: Float = 1, algo: @escaping (Float, Float) -> Float) {
        self.algo = algo
        self.amplitude = amplitude
    }
    
    static let square = Waveform { input, amplitude in
        if input > 0 {
            return amplitude
        } else {
            return -amplitude
        }
    }
    
    static let sine = Waveform { input, amplitude in
        return sin(input) * amplitude
    }
    
    static let triangle = Waveform { input, amplitude in
        let phase = input / (2 * .pi)
        let value = 2 * abs(phase - floor(phase + 0.5))
        return (2 * amplitude * (value - 0.5))
    }
    
    static let sawtooth = Waveform { input, amplitude in
        let phase = input / (2 * .pi)
        let value = phase - floor(phase)
        return (2 * amplitude * (value - 0.5))
    }
    
    static let reverseSawtooth = Waveform { input, amplitude in
        let phase = input / (2 * .pi)
        let value = 1.0 - (phase - floor(phase))
        return (2 * amplitude * (value - 0.5))
    }
}

enum WaveformType: Hashable {
    case square
    case sine
    case triangle
    case sawtooth
    case reverseSawtooth
}
