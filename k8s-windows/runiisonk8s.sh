kubectl apply -f iis.json

kubectl get pods

kubectl expose pods iis --port=80 --type=LoadBalance

kubectl get svc