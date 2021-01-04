eval $(minikube docker-env)
docker build -t mon$1 srcs/$1/.
kubectl apply -f srcs/conf/deployment/$1.yaml
kubectl apply -f srcs/conf/services/$1.yaml