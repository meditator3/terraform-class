#!/bin/bash

terraform apply -auto-approve

bash ./ip_collector.sh
bash ./kubespraying.sh
bash ./update_hosts.sh

