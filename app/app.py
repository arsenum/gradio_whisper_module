import gradio as gr
from pydub import AudioSegment
import whisper
import warnings

warnings.filterwarnings("ignore", message=".*libcudnn_cnn_infer.so.8.*")
def analyze_audio(audio_file):
    # Load the uploaded audio file
    sound = AudioSegment.from_file(audio_file.name)
    
    # Placeholder logic for audio analysis (e.g., check if it's a whisper)
    # Here, we'll assume a simple condition (e.g., based on audio volume)
    max_volume = sound.max
    if max_volume < -30:
        result = f"File '{audio_file.name}' is recognized as a whisper."
    else:
        result = f"File '{audio_file.name}' is not recognized as a whisper."

    return result

with gr.Blocks() as demo:
    # Define input block for uploading an audio file
    audio_file = gr.File(label="Upload MP3 Audio File", type="filepath")

    # Define output block to display recognition result
    output_text = gr.Textbox(label="Recognition Result")

    # Define button block to trigger the whisper recognition
    analyze_btn = gr.Button("Analyze Whisper!")

    # Define action function for the button click
    def analyze_whisper(audio_file):
        if audio_file:  # Check if a file was uploaded
            # try:
            #     # Read the uploaded audio file data
            #     audio_data = audio_file.read()
                
            #     # Perform audio analysis (replace this with your analysis logic)
            #     recognition_result = analyze_audio(audio_data)  # Call a function to analyze audio data
                
            #     # Update the output block with the recognition result
            #     if recognition_result is not None:
            #         output_text.value = "result"
            #     else:
            #         output_text.value = "Recognition failed or no result."
            
            # except Exception as e:
            #     output_text.value = f"Error: {e}"
            #output_text.text = "result"
            
            # load audio and pad/trim it to fit 30 seconds
            model = whisper.load_model("base")
            result = model.transcribe(audio=audio_file)
            # audio = whisper.pad_or_trim(audio)

            # make log-Mel spectrogram and move to the same device as the model
            # mel = whisper.log_mel_spectrogram(audio).to(model.device)

            # # detect the spoken language
            # _, probs = model.detect_language(mel)
            # print(f"Detected language: {max(probs, key=probs.get)}")

            # # decode the audio
            # options = whisper.DecodingOptions()
            # result = whisper.decode(model, mel, options)
            return  result["text"]
        else:
            output_text.value = "No audio file uploaded."


    # Assign the action function to the button click event
    analyze_btn.click(fn=analyze_whisper, inputs=audio_file, outputs=output_text, api_name="greet")
print("Done")
demo.launch(share=True, server_name="0.0.0.0")

