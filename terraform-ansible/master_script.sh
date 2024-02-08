mkdir react-java0mysql
cd react-java0mysql
wget https://github.com/meditator3/react-java0mysql/archive/refs/heads/main.zip
unzip main.zip

curl -L https://github.com/kubernetes/kompose/releases/download/v1.32.0/kompose-linux-amd64 -o kompose
chmod +x kompose
mv kompose /usr/local/bin/
mkdir converted_compose
cd converted_compose
kompose convert -f docker-compose.yaml
mv docker-compose.yaml docker-compose.yaml.backup

kubectl apply -f .
