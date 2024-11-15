import subprocess
import os
import re
import requests

# Set the PYTHONUNBUFFERED environment variable to force unbuffered output
env = os.environ.copy()
env["PYTHONUNBUFFERED"] = "1"

url_pattern = re.compile(r'https://[a-zA-Z0-9\-]+\.gradio\.live')

try:
    process = subprocess.Popen(['python3', 'app.py'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, env=env)

    # Print each line from the subprocess output
    for line in process.stdout:
        # print(line, end='')
        match = url_pattern.search(line)
        if match:
            print(match.group(0))
            call_back = os.getenv('CALL_BACK')
            data = {
                "param1": "value1",
                "param2": match.group(0)
            }

            headers = {
                'Content-Type': 'application/json'
            }

            response = requests.post(f"{call_back}/hooks/example-webhook", json=data, headers=headers)

            # Optionally, you can print the response or handle it as needed
            print(response.status_code)
            print(response.text)
        # else:
            # print(line, end='')


    process.wait()
except KeyboardInterrupt:
    print("\nProcess interrupted. Terminating...")
    process.terminate()
    process.wait()