import os
import subprocess
import threading
import io
import cv2
import base64
import httpx
import ollama
import asyncio
from ollama import AsyncClient
import time
#from gtts import gTTS
#import pyttsx3
#engine = pyttsx3.init()

def gstreamer_pipeline(
    capture_width=1280,
    capture_height=720,
    display_width=640,
    display_height=360,
    framerate=30,
    flip_method=0,
    ):
    return (
        "nvarguscamerasrc ! "
        "video/x-raw(memory:NVMM), "
        "width=(int)%d, height=(int)%d, "
        "format=(string)NV12, framerate=(fraction)%d/1 ! "
        "nvvidconv flip-method=%d ! "
        "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
        "videoconvert ! "
        "video/x-raw, format=(string)BGR ! appsink"
        % (
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )



video = cv2.VideoCapture(gstreamer_pipeline(flip_method=2), cv2.CAP_GSTREAMER)

a = 0
img_counter = 0
in_progress = False
message = ""


def chat(frame):
    global in_progress
    global message
    in_progress = True
    is_success, buffer = cv2.imencode(".jpg", frame)
    io_buf = io.BytesIO(buffer)
    print("sending image to Ollama")
    print(time.gmtime())
    response = ollama.generate('llava:7b', 'If you see me, describe me in one sentence. Otherwise, describe the background in one sentence.',
                               images=[io_buf], stream=False, options=dict(num_predict=30))
    print(response['response'], end='', flush=True)
    message = response['response']
    #engine.say(message)
    #engine.runAndWait()
    #output = gTTS(text=message, lang='en', slow=False)
    #output.save("message.mp3")
    #os.system('mpg123  message.mp3')

    subprocess.run('echo "' + message + '"| piper --model en_US-lessac-medium.onnx --output_file message.wav', shell=True)
    subprocess.Popen('aplay message.wav', shell=True)


    in_progress = False

while True:

    a = a + 1
    check, frame = video.read()
    #cv2.imwrite("test.png", frame)
    if not check:
        continue
    # frame = cv2.resize(frame, (960, 540))
    copy = frame.copy()
    cv2.putText(frame, message, (0,20),  cv2.FONT_HERSHEY_SIMPLEX, 0.5,(0, 0, 0), 2)
    cv2.imshow("Ollava", frame)
    #base64_image = base64.b64encode(frame)


    if not in_progress:
        threading.Thread(target=chat, args=(copy, )).start()


    # cv2.waitK0ey(0)
    key = cv2.waitKey(1)

    if key == ord('q'):
        break
    elif key == ord('i'):
        # SPACE pressed
        img_name = "opencv_frame_{}.png".format(img_counter)
        cv2.imwrite(img_name, frame)
        print("{} written!".format(img_name))
        img_counter += 1

video.release()
cv2.destroyAllWindows()
