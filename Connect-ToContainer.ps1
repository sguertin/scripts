function Connect-ToContainer {
    param(
        $Name,
        $Group
    )
    # prestep: Make sure you're pointing at the dev environment
    az aks get-credentials -n $Name -g $Group;
    # Add Public Key to Pod
    $resourceGroup = Read-Host "What resource group?";
    $name = Read-Host "What Pod?";
    az vm user update --resource-group $resourceGroup --name $name --username azureuser --ssh-key-value $env:USERPROFILE\.ssh\id_rsa.pub;

    kubectl cp $env:USERPROFILE\.ssh\id_rsa aks-ssh-6fd7758688-qj6sj:/root/.ssh/id_rsa

    kubectl exec -it $sshPodName -- /bin/bash

    chmod 600 /root/.ssh/id_rsa

    ssh azureuser@$name
}
