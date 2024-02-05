mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.312.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz
echo "85c1bbd104d539f666a89edef70a18db2596df374a1b51670f2af1578ecbe031  actions-runner-linux-x64-2.312.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.312.0.tar.gz
<<<<<<< HEAD
./config.sh --url https://github.com/meditator3/Grad_proj --token $TOKENRUNNER
=======
./config.sh --url https://github.com/meditator3/Grad_proj --token $RUNNERTOKEN
>>>>>>> 6927a743e5f084d002cf3f40f54ac87b7e3dd9e9
./run.sh
