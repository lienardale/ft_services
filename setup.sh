# SERVICES=( ftps grafana influxdb mysql nginx phpmyadmin wordpress ) 
SERVICES=( nginx phpmyadmin mysql wordpress )
# VOLUMES=( mysql influxdb ) 
VOLUMES=( mysql )

rm -rf ~/.ssh/known_hosts

# RESET LOG FILES
rm -rf logs > /dev/null 2>&1
mkdir ./logs > /dev/null 2>&1
mkdir ./logs/imgs_build > /dev/null 2>&1
mkdir ./logs/volumes > /dev/null 2>&1
mkdir ./logs/deployment > /dev/null 2>&1
mkdir ./logs/services > /dev/null 2>&1

# SETUP VM FCT

setup_vm()
{
	if [ ! -f ~/.vm_isset ];
	then
		apt update &> /dev/null
		sudo curl -L "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl &> /dev/null
		sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube &> /dev/null
		sudo chmod +x /usr/local/bin/kubectl /usr/local/bin/minikube &> /dev/null
		touch ~/.vm_isset
		
		sudo chown -R $USER $HOME/.minikube; chmod -R u+wrx $HOME/.minikube
		# minikube start
		# minikube delete
		###		Run docker ###
		if [[ $(service docker status | grep running) = '' ]]
		then
			echo "Starting Docker service..."
			service docker start
			while [[ $(service docker status | grep running) = '' ]]
			do
				sleep 1
			done
		fi
		if [[ $(groups | grep docker) = '' ]]
		then
			sudo usermod -aG docker $USER && newgrp docker
		fi
		echo "SETUP VM COMPLETE"
		# echo "RERUN SCRIPT"
		# sudo usermod -aG docker user42 && newgrp docker
	fi
}

# CHECK IF MACOS OR LINUX

if [ "$(uname -s)" != "Linux" ]
then
		echo "On Mac OS"
		###		Set up colors
		RED="\033[91m"
		GREEN="\033[92m"
		YELLOW="\033[93m"
		BLUE="\033[94m"
		PURPLE="\033[95m"
		CYAN="\033[96m"
		WHITE="\033[97m"
		###		Set up metallb ip range
		IP_RANGE="192.168.99.124-192.168.99.250"
		CPU=3
		DRVR=virtualbox
		###		Install & update k8s/minikube ###
		echo "Install Kubernetes and minikube? (If not sure, press 1)"
		select yn in "Yes" "No"; do
			case $yn in
				Yes )	brew install screen; \
						curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64; \
						chmod +x minikube; \
						sudo mv minikube /usr/local/bin; \
						brew install kubernetes-cli; break;;
				No )	break;;
			esac
		done
		# minikube start
else
		echo "On Linux"
		RED="\e[91m"
		GREEN="\e[92m"
		YELLOW="\e[93m"
		BLUE="\e[94m"
		PURPLE="\e[95m"
		CYAN="\e[96m"
		WHITE="\e[97m"
		IP_RANGE="192.168.99.124-192.168.99.250"
		# IP_RANGE="172.17.0.2-172.17.0.254"
		CPU=2
		DRVR=docker
		setup_vm
fi

# UPDATING METALLB_CONFIG ACCORDING TO OS

cp srcs/metallb_basis srcs/metallb_config.yaml
echo "        - $IP_RANGE" >> srcs/metallb_config.yaml

# ALIASES SETUP FCT

setup_aliases()
{
	if [ ! "$(cat ~/.zshrc | grep "source <(kubectl completion zsh)")" ];
	then
		echo "source <(kubectl completion zsh)" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias k=")" ];
	then
		echo "alias k=kubectl" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "complete -F __start_kubectl k")" ];
	then	
		echo "complete -F __start_kubectl k" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias kcc=")" ];
	then
		echo "alias kcc='kubectl config current-context'" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias kg=")" ];
	then
		echo "alias kg='kubectl get'" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias kga=")" ];
	then
		echo "alias kga='kubectl get all --all-namespaces'" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias kgp=")" ];
	then
		echo "alias kgp='kubectl get pods'" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias kgs=")" ];
	then
		echo "alias kgs='kubectl get services'" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias ksgp=")" ];
	then
		echo "alias ksgp='kubectl get pods -n kube-system'" >> ~/.zshrc
	fi
	if [ ! "$(cat ~/.zshrc | grep "alias kuc=")" ];
	then
		echo "alias kuc='kubectl config use-context'" >> ~/.zshrc
	fi
	echo -ne $GREEN
	echo "ALIASES SET ON ZSH"
	echo -ne $WHITE
}

# SETUP MINIKUBE & DASHBOARD FCT

setup_minikube()
{
	minikube delete
	minikube config set WantUpdateNotification false
	minikube start --vm-driver=$DRVR --cpus=$CPU
	minikube addons enable metrics-server
	minikube addons enable dashboard
	echo -ne $GREEN
	echo "SETUP MINIKUBE COMPLETE"
	echo -ne $WHITE

	# DLD & INSTALL METALLB
	minikube addons enable metallb
	kubectl apply -f srcs/metallb_config.yaml
	eval $(minikube docker-env)
	echo -ne $GREEN
	echo "SETUP METALLB COMPLETE"
	echo -ne $WHITE
}

# BUILDING ONE IMG FCT

build_one()
{
	echo -ne $BLUE
	echo -n "Building $1 image..."
	echo -ne $WHITE
	docker build -t mon${1} srcs/$1/. > logs/imgs_build/${img}.log 2>&1
	echo -ne $GREEN
	echo "$1 image built."
	echo -ne $WHITE
}

# BUILDING ALL IMGS FCT

build_imgs()
{
	for img in ${SERVICES[*]}
	do 
		build_one $img
		wait
	done
	echo -ne $GREEN
	echo "IMAGES BUILT"
	echo -ne $WHITE
}

# BUILDING ONE VOLUME FCT

build_volumes()
{
	for vol in ${VOLUMES[*]}
	do
		kubectl apply -f srcs/conf/volumes/$vol.yaml > logs/volumes/${vol}.log 2>&1
	done
	echo -ne $GREEN
	echo "VOLUMES BUILT"
	echo -ne $WHITE
}

# BUILDING ONE DEPLOYMENT FCT

create_deployments()
{
	for dep in ${SERVICES[*]}
	do
		kubectl apply -f srcs/conf/deployment/$dep.yaml > logs/deployment/${dep}.log 2>&1
	done
	echo -ne $GREEN
	echo "DEPLOYMENTS CREATED"
	echo -ne $WHITE
}

# BUILDING ONE SERVICE FCT

create_services()
{
	for serv in ${SERVICES[*]}
	do
		kubectl apply -f srcs/conf/services/$serv.yaml > logs/services/${serv}.log 2>&1
	done
	echo -ne $GREEN
	echo "SERVICES EXPOSED"
	echo -ne $WHITE
}

# kubectl run my_shell -it --image busybox -- bash : lance shell sur un pod k8s
# k exec -ti $pod -- sh

# run_one_build()
# {
	# eval $(minikube docker-env)
# 	docker run -it mon$1 sh
#   docker exec -ti mon$1 sh
# }

# shell_in_pod()
# {
# see https://kubernetes.io/fr/docs/tasks/debug-application-cluster/get-shell-running-container/
# }

# alias k='kubectl'
alias kgl='kubectl_get_logs'
alias kdp='kubectl_delete_pod'
alias dec='docker_exec_container'
alias kre='kubectl_reload'

#           kubectl_get_pod_name(name)
function    kubectl_get_pod_name {
    kubectl get pods | grep $1 > /dev/null
    if [ $? -ne 0 ]; then
        echo "error pod '$1' not found" >&2
        return -1;
    fi
    kubectl get pods | grep $1 | cut -f1 -d' '
}

#           kubectl_get_logs(name)
function    kubectl_get_logs {
    kubectl_get_pod_name $1 && \
    kubectl logs $(kubectl_get_pod_name $1)
}

#           kubectl_delete_pod(name)
function    kubectl_delete_pod {
    kubectl_get_pod_name $1 && \
    kubectl delete pod $(kubectl_get_pod_name $1)
}

#           docker_exec_container(name)
function    docker_exec_container {
    eval $(minikube docker-env)
    id=$(docker ps -f name=$1 | grep $1_$1 | cut -f1 -d' ')
    if [ -z "$id" ];then
        echo "error container '$1' not found" >&2
        return -1
    fi
    docker exec -ti $id sh
}

run()
{
	setup_aliases
	setup_minikube
	build_imgs
	build_volumes
	create_deployments
	create_services

# opening dashboard :
	echo -ne $GREEN
	echo "OPENING DASHBOARD"
	echo -ne $WHITE
	minikube dashboard &
}

run
