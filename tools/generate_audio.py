import math
import os
import random
import struct
import wave

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "audio")

def create_sine_wave(freq, duration, sample_rate=22050, amplitude=0.4):
    num_samples = int(duration * sample_rate)
    samples = []
    for i in range(num_samples):
        t = i / sample_rate
        env = min(1.0, (num_samples - i) / (sample_rate * 0.05)) if i > num_samples - sample_rate * 0.05 else min(1.0, i / (sample_rate * 0.01))
        sample = amplitude * math.sin(2 * math.pi * freq * t) * env
        samples.append(int(sample * 32767))
    return samples

def create_noise_wave(duration, sample_rate=22050, amplitude=0.3):
    num_samples = int(duration * sample_rate)
    samples = []
    for i in range(num_samples):
        env = 1.0 - (i / num_samples)
        sample = amplitude * (random.random() * 2.0 - 1.0) * env
        samples.append(int(sample * 32767))
    return samples

def write_wav(filename, samples, sample_rate=22050):
    filepath = os.path.join(OUTPUT_DIR, filename)
    with wave.open(filepath, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        packed_data = bytearray()
        for s in samples:
            packed_data.extend(struct.pack('<h', max(-32768, min(32767, s))))
        wav_file.writeframes(packed_data)
    print(f"Generated: {filename} ({len(samples)} samples)")

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # 1. Scrub sound
    write_wav("scrub.wav", create_noise_wave(0.2, amplitude=0.3))
    # 2. Spray sound
    write_wav("spray.wav", create_noise_wave(0.25, amplitude=0.4))
    # 3. Bubble pop
    write_wav("bubble_pop.wav", create_sine_wave(880, 0.12, amplitude=0.5))
    # 4. Hammer hit
    write_wav("hammer_hit.wav", create_sine_wave(220, 0.15, amplitude=0.6))
    # 5. Air pump
    write_wav("air_pump.wav", create_noise_wave(0.3, amplitude=0.35))
    # 6. Bulb click
    write_wav("bulb_click.wav", create_sine_wave(1200, 0.08, amplitude=0.4))
    # 7. Part snap
    write_wav("part_snap.wav", create_sine_wave(440, 0.12, amplitude=0.5))
    # 8. Wrong buzz
    write_wav("wrong_buzz.wav", create_sine_wave(150, 0.25, amplitude=0.6))
    # 9. Coin
    write_wav("coin.wav", create_sine_wave(987, 0.2, amplitude=0.5))
    # 10. Level complete
    write_wav("level_complete.wav", create_sine_wave(523, 0.6, amplitude=0.5))
    # 11. Button tap
    write_wav("button_tap.wav", create_sine_wave(600, 0.06, amplitude=0.3))
    # 12. Menu loop
    write_wav("menu_loop.wav", create_sine_wave(330, 2.0, amplitude=0.25))
    # 13. Game loop
    write_wav("game_loop.wav", create_sine_wave(440, 2.0, amplitude=0.25))

if __name__ == "__main__":
    main()
