# Script Booth

A voice-powered film script generator in one HTML file. A narrator says who speaks ("Alex says that I'm leaving tonight") and presses any key (or a headphone button) whenever the dialogue changes hands. The result appears as real screenplay pages you can edit, export and print.

## Features
- **Live tab**: browser speech recognition (one continuous session) + key markers. Without AI the built-in rules engine decides each line; with AI each segment goes to Gemini.
- **Record tab**: audio or audio+video. Every dialogue change plays a beep that is recorded into the audio track (and its time is saved as metadata). Recordings auto-save to IndexedDB; save .webm / .wav / markers .json / transcript / .zip.
- **Upload tab**: audio or video files. Beeps are found with a Goertzel detector; markers can be added, moved or deleted on a waveform.
- **Without AI** for Record/Upload: hardware-accelerated on-device Whisper (`onnx-community/whisper-tiny` by default or `whisper-base`) with WebGPU and fast segment timestamps in a Web Worker, split by key times, then the rules engine.
- **With AI**: audio is split into ~6 minute parts at quiet moments and sent to Gemini with beep times; replies carry `speech` types (direct / indirect / narration / command) and reasons.
- Live words box, status strip, speaker colours, CONT'D, pagination, page numbers, zoom, line spacing, title page.
- Editing: hover a block for speaker / speech-type selects and delete; text is editable in place.
- Finishing: Format as film script (with undo), Re-check speakers, script library, Fountain / text export, print to PDF.
- Teach the AI: corrections are remembered (up to 200) and the 6 most relevant are injected into prompts; gold recordings (<60 s); .jsonl export for later fine-tuning; accuracy meter.

## Setup
Speech recognition and the microphone need `http://localhost` (or https) in Chrome or Edge.
- **Windows**: double-click `start-windows.bat` (serves only `script-booth.html` on http://localhost:8765/ and opens it).
- **Python**: `python3 -m http.server 8765` in this folder, then open http://localhost:8765/script-booth.html

## Gemini key
Open "AI settings", paste a key from Google AI Studio, press **Save key**, then **Test AI**. The key is stored in your browser's localStorage. You can also set `let API_KEY=''` at the top of the script. Models tried in order: `gemini-2.5-flash`, `gemini-2.0-flash`, `gemini-1.5-flash`, `gemini-1.5-flash-8b`.

## Architecture
One file: CSS variables for light/dark themes; state `S` (script) autosaved to localStorage; rules engine and Gemini both produce the same block format; segments run through a promise queue; a shared recorder handles Live-record and Record tab; IndexedDB stores recordings, corrections and gold examples; the speech model runs in a Blob-URL module Worker.

## Privacy
Without AI, audio never leaves your device (the Whisper model is downloaded once from jsdelivr/Hugging Face). With AI, text segments or audio parts are sent to Google's Gemini API using your key. Live speech recognition in Chrome/Edge uses the browser's own speech service.

## Limitations
- Rules engine converts cue words only; turning indirect speech into first person needs AI.
- Whisper-base is small: expect transcription errors, especially with accents or noise.
- Browsers cannot fine-tune Gemini; "Teach the AI" is prompt examples plus an export for later training.
- Video extraction fallback for undecodable files runs in real time.
- Files over ~40 minutes may exhaust memory.

## Troubleshooting
- *Microphone blocked*: allow it in the address bar; use the typing box meanwhile.
- *Speech network error*: Chrome speech needs internet.
- *Model download fails*: check internet; use "Process with AI" or retry.
- *Keys do nothing*: a key only counts while listening or recording, and not while typing in a field.
- *Beeps not detected*: set the beep frequency in Record > Beep settings to the one used.
