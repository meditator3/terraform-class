#!/bin/bash
# ip for connecting 
MASTER_K8S_IP_PUB=$(terraform output -raw  master_ip_pub)
#pass the ingress-rule for argo cd
ssh-keyscan  -H $MASTER_K8S_IP_PUB >> ~/.ssh/known_hosts
scp -i k:/devops/cloud/ariel-key.pem ingress-rule-argo.yaml ubuntu@$MASTER_K8S_IP_PUB
#install argoCD
ssh -i k:/devops/cloud/ariel-key.pem -tt ubuntu@$MASTER_K8S_IP_PUB << 'EOF'
echo " namespacing argoCD"
sudo kubectl create ns argocd
echo " installing argoCD"
sudo curl -L https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | \
sudo sed '/- argocd-server/a \          - --insecure' | \
sudo kubectl apply -f - -n argocd


echo "end install"

echo "applying argocd ingress rule"

sudo kubectl apply -f ingress-rule.yaml -n argocd
echo "patching argo cd deployment for dns zone"
sudo kubectl patch deployment argocd-server -n argocd --type=json -p='[
    {
        "op": "add",
        "path": "/spec/template/spec/containers/0/args/-",
        "value": "--basehref"
    },
    {
        "op": "add",
        "path": "/spec/template/spec/containers/0/args/-",
        "value": "/argocd"
    },
    {
        "op": "add",
        "path": "/spec/template/spec/containers/0/args/-",
        "value": "--insecure"
    }
]'


#!/bin/bash
# Install Argo CD CLI
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/

# Set the password environment variable
export ARGOCD_PASS=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)

# Define variables
ARGOCD_SERVER="argocd.grad.arieldevops.tech" # Removed /argocd
USERNAME="admin"
PASSWORD=$ARGOCD_PASS  # Use the environment variable

# Login (removed sudo)
argocd login $ARGOCD_SERVER --username $USERNAME --password $PASSWORD --insecure

# Deploy an application (removed sudo, fixed the command continuation)
argocd app create my-app \
  --repo https://github.com/meditator3/react-java-mysql.git \
  --path manifest \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace react \
  --sync-policy automated

# Optionally, ensure the app reaches a healthy state (removed sudo)
argocd app wait my-app --health --sync

EOF