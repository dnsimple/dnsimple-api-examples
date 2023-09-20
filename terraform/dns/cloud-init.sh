#!/bin/bash

set -Eeuxo pipefail

python3 -m ensurepip
pip3 install boto3 Flask flask-cors
python3 << 'EndOfPython'
${code}
EndOfPython
