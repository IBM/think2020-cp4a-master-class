# New code block, line: 873
mkdir -p /home/ibmdemo/cp4a-labs/think20
cd /home/ibmdemo/cp4a-labs/think20

git clone https://github.com/think-2020-cp4a/monitoring.git
# End code block, line: 878


# New code block, line: 882
oc create namespace istio-system
cd /home/ibmdemo/cp4a-labs/think20/monitoring

oc apply -f smcpv10.yaml -n istio-system
oc apply -f smmr.yaml -n istio-system
# End code block, line: 888exit

# New code block, line: 892
#oc delete ClusterServiceVersion servicemeshoperator.v1.0.9 \
#    --ignore-not-found=true \
#    -n openshift-operators
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
for i in {1..2}
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

