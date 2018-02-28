set -x

curl -O -L https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
~/.local/bin/pip install -r requirements.txt --user
curl -o kedge -L https://github.com/kedgeproject/kedge/releases/download/v0.9.0/kedge-linux-amd64
chmod +x kedge
