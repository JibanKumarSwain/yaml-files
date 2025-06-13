# yaml-files




this command is setup the .env to deployment.yaml file can access the easlly 
"kubectl create secret generic node-app-secret --from-env-file=.env -n java"

after creating the server.yaml file 
kubectl port-forward  service/node-app-service -n java 5000:80 --address=0.0.0.0 &

while true; do wget -q -0- http://apache-service.apache.svc.cluster.local; done

kubectl create secret generic node-app-secret   --from-literal=MSG91AUTHKEY=your-real-value   -n node --dry-run=client -o yaml | kubectl apply -f 
