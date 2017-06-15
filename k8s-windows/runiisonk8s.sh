kubectl apply -f iis.json

kubectl get pods

kubectl expose pods iis --port=80 --type=LoadBalancer

kubectl get svc