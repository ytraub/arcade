import subprocess
import time
import re

def read_nfc() :
    while True :
        result = subprocess.run(
            ["nfc-poll"],
            capture_output=True,
            text=True
        )

        match = re.search(
            r"UID.*?: ([\da-fA-F ]+)",
            result.stdout
        )

        if match:
            uid = match.group(1).replace(" ", "").upper()
            return uid

        time.sleep(1)