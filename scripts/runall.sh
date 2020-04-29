
# New code block, line: 155
oc get csr -o name | xargs oc adm certificate approve
# End code block, line: 157


# New code block, line: 161
oc delete ClusterServiceVersion elasticsearch-operator.4.3.5-202003020549 \
    --ignore-not-found=true \
    -n openshift-operators
# End code block, line: 165


# New code block, line: 196
appsody repo list
# End code block, line: 198


# New code block, line: 211
appsody repo add kabanero https://github.com/kabanero-io/kabanero-stack-hub/releases/download/0.7.0/kabanero-stack-hub-index.yaml

appsody list kabanero
# End code block, line: 215


# New code block, line: 230
mkdir /tmp/nodejs-app
cd /tmp/nodejs-app

appsody init kabanero/nodejs-express

# appsody run 
# End code block, line: 237


# New code block, line: 241
# curl localhost:3000
# End code block, line: 243


# New code block, line: 253
#cd /tmp/nodejs-app
# appsody stop
# End code block, line: 256


# New code block, line: 279
mkdir -p /home/ibmdemo/cp4a-labs/think20

cd /home/ibmdemo/cp4a-labs/think20
git clone https://github.com/think-2020-cp4a/service-a.git
cd service-a
git checkout v1

cd /home/ibmdemo/cp4a-labs/think20
git clone https://github.com/think-2020-cp4a/service-b.git
cd service-b
git checkout v1

cd /home/ibmdemo/cp4a-labs/think20
git clone https://github.com/think-2020-cp4a/service-c.git
cd service-c
git checkout v1
# End code block, line: 296


# New code block, line: 303
oc new-project cloudlab
# End code block, line: 305


# New code block, line: 318
cat<<EOF | oc apply -n cloudlab -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: jaeger-config
data:
  JAEGER_ENDPOINT: http://jaeger-collector.istio-system.svc.cluster.local:14268/api/traces
  JAEGER_PROPAGATION: b3
  JAEGER_REPORTER_LOG_SPANS: "true"
  JAEGER_SAMPLER_PARAM: "1"
  JAEGER_SAMPLER_TYPE: const
EOF
# End code block, line: 331


# New code block, line: 348
oc patch configs.imageregistry.operator.openshift.io/cluster \
    --patch '{"spec":{"defaultRoute":true}}' \
    --type=merge

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

docker login -u $(oc whoami) -p $(oc whoami -t) $HOST
# End code block, line: 356


# New code block, line: 363
HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

cd /home/ibmdemo/cp4a-labs/think20/service-a

# this may take a few minutes
appsody build \
    --pull-url image-registry.openshift-image-registry.svc:5000 \
    --push-url $HOST/cloudlab \
    --tag service-a:1.0.0
# End code block, line: 373


# New code block, line: 385
HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

cd /home/ibmdemo/cp4a-labs/think20/service-b

# this may take a few minutes
appsody build \
    --pull-url image-registry.openshift-image-registry.svc:5000 \
    --push-url $HOST/cloudlab \
    --tag service-b:1.0.0
# End code block, line: 395


# New code block, line: 399
HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

cd /home/ibmdemo/cp4a-labs/think20/service-c

# this may take a few minutes
appsody build \
    --pull-url image-registry.openshift-image-registry.svc:5000 \
    --push-url $HOST/cloudlab \
    --tag service-c:1.0.0
# End code block, line: 409


# New code block, line: 413
docker images default-route-openshift-image-registry.apps.demo.ibmdte.net/cloudlab/*
# End code block, line: 415


# New code block, line: 455
cd /home/ibmdemo/cp4a-labs/think20/service-a

appsody deploy \
    --no-build \
    --namespace cloudlab
# End code block, line: 461


# New code block, line: 472
cd /home/ibmdemo/cp4a-labs/think20/service-b

appsody deploy \
    --no-build \
    --namespace cloudlab
# End code block, line: 478


# New code block, line: 482
cd /home/ibmdemo/cp4a-labs/think20/service-c

appsody deploy \
    --no-build \
    --namespace cloudlab
# End code block, line: 488


# New code block, line: 501
oc get AppsodyApplication -n cloudlab -w
# End code block, line: 503


# New code block, line: 530
oc get route -n cloudlab
# End code block, line: 532


# New code block, line: 545
curl service-a-cloudlab.apps.demo.ibmdte.net/node-jee
curl service-a-cloudlab.apps.demo.ibmdte.net/node-springboot
# End code block, line: 548


# New code block, line: 559
cd /home/ibmdemo/cp4a-labs/think20/service-a
appsody deploy delete --namespace cloudlab

cd /home/ibmdemo/cp4a-labs/think20/service-b
appsody deploy delete --namespace cloudlab

cd /home/ibmdemo/cp4a-labs/think20/service-c
appsody deploy delete --namespace cloudlab
# End code block, line: 568


# New code block, line: 590
oc new-app \
    --docker-image=image-registry.openshift-image-registry.svc:5000/cloudlab/service-a:1.0.0 \
    --name=service-a \
    --namespace cloudlab \
    --insecure-registry=true

oc new-app \
    --docker-image=image-registry.openshift-image-registry.svc:5000/cloudlab/service-b:1.0.0 \
    --name=service-b \
    --namespace cloudlab \
    --insecure-registry=true

oc new-app \
    --docker-image=image-registry.openshift-image-registry.svc:5000/cloudlab/service-c:1.0.0 \
    --name=service-c \
    --namespace cloudlab \
    --insecure-registry=true
# End code block, line: 608


# New code block, line: 612
oc expose svc/service-a -n cloudlab
# End code block, line: 614


# New code block, line: 618
curl service-a-cloudlab.apps.demo.ibmdte.net/node-jee
curl service-a-cloudlab.apps.demo.ibmdte.net/node-springboot
# End code block, line: 621


# New code block, line: 679
oc get route -n tekton-pipelines tekton-dashboard
# End code block, line: 681


# New code block, line: 766
oc get dc -n cloudlab -o name | xargs oc delete -n cloudlab
oc get svc -n cloudlab -o name | xargs oc delete -n cloudlab
oc get route -n cloudlab -o name | xargs oc delete -n cloudlab
oc get imagestream -n cloudlab -o name | xargs oc delete -n cloudlab
# End code block, line: 771


# New code block, line: 777
cd /home/ibmdemo/cp4a-labs/think20/service-a/tekton

oc delete -n kabanero --ignore-not-found=true -f service-a-manual-pipeline-run-v1.yaml

oc apply -n kabanero -f service-a-manual-pipeline-run-v1.yaml
# End code block, line: 783


# New code block, line: 787
cd /home/ibmdemo/cp4a-labs/think20/service-b/tekton

oc delete -n kabanero --ignore-not-found=true -f service-b-manual-pipeline-run-v1.yaml

oc apply -n kabanero -f service-b-manual-pipeline-run-v1.yaml
# End code block, line: 793


# New code block, line: 797
cd /home/ibmdemo/cp4a-labs/think20/service-c/tekton

oc delete -n kabanero --ignore-not-found=true -f service-c-manual-pipeline-run-v1.yaml

oc apply -n kabanero -f service-c-manual-pipeline-run-v1.yaml
# End code block, line: 803


# New code block, line: 812
tkn pipelinerun list -n kabanero
# End code block, line: 814


# New code block, line: 827
tkn taskrun list -n kabanero
# End code block, line: 829


# New code block, line: 845
tkn taskrun logs service-a-pipeline-run-v1-build-push-task-2tw5f -n kabanero
# End code block, line: 847


# New code block, line: 873
mkdir -p /home/ibmdemo/cp4a-labs/think20
cd /home/ibmdemo/cp4a-labs/think20

git clone https://github.com/think-2020-cp4a/monitoring.git
# End code block, line: 878


# New code block, line: 882
oc create namespace istio-system
cd /home/ibmdemo/cp4a-labs/think20/monitoring

oc apply -f smcp.yaml -n istio-system
oc apply -f smmr.yaml -n istio-system
# End code block, line: 888


# New code block, line: 892
oc delete ClusterServiceVersion servicemeshoperator.v1.0.9 \
    --ignore-not-found=true \
    -n openshift-operators
# End code block, line: 896


# New code block, line: 912
oc get pod -n istio-system -w
# End code block, line: 914


# New code block, line: 923
oc get pod -n cloudlab -o name | xargs oc delete -n cloudlab
# End code block, line: 925


# New code block, line: 934
# service-a
oc patch service service-a -n cloudlab \
    -p '{"spec":{"ports":[{"port": 3000, "name":"http"}]}}'
oc patch route service-a -n cloudlab \
    -p '{"spec":{"port":{"targetPort": "http"}}}'

# service-b
oc patch service service-b -n cloudlab \
    -p '{"spec":{"ports":[{"port": 8080, "name":"http"}]}}'
oc patch route service-b -n cloudlab \
    -p '{"spec":{"port":{"targetPort": "http"}}}'

# service-c
oc patch service service-c -n cloudlab \
    -p '{"spec":{"ports":[{"port": 9080, "name":"http"}]}}'
oc patch route service-c -n cloudlab \
    -p '{"spec":{"port":{"targetPort": "http"}}}'
# End code block, line: 952


# New code block, line: 958
cd /home/ibmdemo/cp4a-labs/think20/monitoring

oc apply -f smingress.yaml -n cloudlab
oc apply -f service-c-fault-injection.yaml -n cloudlab
# End code block, line: 963


# New code block, line: 969
oc get route istio-ingressgateway -n istio-system
# End code block, line: 971


# New code block, line: 982
for i in {1..2000}
do
    curl istio-ingressgateway-istio-system.apps.demo.ibmdte.net/quoteOrder
    sleep 1
    curl istio-ingressgateway-istio-system.apps.demo.ibmdte.net/quoteItem
    sleep 1
done
# End code block, line: 990


# New code block, line: 1001
oc get route grafana -n istio-system
# End code block, line: 1003


# New code block, line: 1046
oc get route kiali -n istio-system
# End code block, line: 1048


# New code block, line: 1088
oc get route jaeger -n istio-system
# End code block, line: 1090

