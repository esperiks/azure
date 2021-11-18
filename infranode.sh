#!/bin/bash

# Get name
aro_name=$(az network lb list  -g aro-dev --query [0].name  -o tsv)
aro_location=$(az network lb list  -g aro-dev --query [0].location -o tsv)
rg_name=aro-dev
number=4

create_infra4(){

#for number in $(seq 4)
#do
cat << EOF | kubectl apply -f -
#cat << EOF
---
apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  labels:
    machine.openshift.io/cluster-api-cluster: $aro_name
    machine.openshift.io/cluster-api-machine-role: infra
    machine.openshift.io/cluster-api-machine-type: infra
  name: $aro_name-infra-${aro_location}${number}
  namespace: openshift-machine-api
spec:
  replicas: 1
  selector:
    matchLabels:
      machine.openshift.io/cluster-api-cluster: $aro_name
      machine.openshift.io/cluster-api-machineset: ${aro_name}-infra-${aro_location}$number
  template:
    metadata:
      creationTimestamp: null
      labels:
        machine.openshift.io/cluster-api-cluster: ${aro_name}
        machine.openshift.io/cluster-api-machine-role: infra
        machine.openshift.io/cluster-api-machine-type: infra
        machine.openshift.io/cluster-api-machineset: ${aro_name}-infra-${aro_location}${number}
    spec:
      metadata:
        creationTimestamp: null
        labels:
          node-role.kubernetes.io/infra: ""
      taints:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
      providerSpec:
        value:
          apiVersion: azureproviderconfig.openshift.io/v1beta1
          credentialsSecret:
            name: azure-cloud-credentials
            namespace: openshift-machine-api
          image:
            offer: ""
            publisher: ""
            resourceID: /resourceGroups/${rg_name}/providers/Microsoft.Compute/images/${aro_name}
            sku: ""
            version: ""
          internalLoadBalancer: ""
          kind: AzureMachineProviderSpec
          location: ${aro_location}
          metadata:
            creationTimestamp: null
          natRule: null
          networkResourceGroup: tri-d-aro-rg
          osDisk:
            diskSizeGB: 512
            managedDisk:
              storageAccountType: Premium_LRS
            osType: Linux
          publicIP: false
          publicLoadBalancer: ""
          resourceGroup: aro-dev
          sshPrivateKey: ""
          sshPublicKey: ""
          subnet: tri-d-aro-worker-snet
          userDataSecret:
            name: worker-user-data
          vmSize: Standard_D8s_v3
          vnet: tri-d-aro-network-vnet
          zone: "1"
EOF

#done
}

create_infra4
