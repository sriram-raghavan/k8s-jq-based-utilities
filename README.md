# K8s utilities, based on jq. jq is a lightweight and flexible command-line JSON processor. 

<b>Shell scripts that use kubectl to interact with Kubernetes cluster and jq for JSON processing. </b> <br/>

<b><u>getSpecificDeploymentResourceInfo</u></b> - Get information on replica count, CPU and memory requests and limits for a particular deployment. <br/>
<i>Usage - ./getSpecificDeploymentResourceInfo.sh namespace deployment-name </i>

<b><u>getSpecificDeploymentVersionFromNamespace</u></b> - Get version number for a specific deployment from a namespace.<br/>
<i>Usage - ./getSpecificDeploymentVersionFromNamespace.sh namespace deployment-name</i> <br/>

<b><u>getSpecificSecretFromNamespace</u></b> - Get specific secret from a namespace. <br/>
<i>Usage - ./getSpecificSecretFromNamespace.sh namespace secret-name </i> <br/>

<b><u>getAllSecretsFromNamespace</u></b> - Get all the secrets from a namespace. Exclude secrets that have "-backup-" in their name and type "helm.sh/release.v1"<br/>
<i>Usage - ./getAllSecretsFromNamespace.sh namespace </i> <br/>

<b><u>Base64 Decoded</u></b><br/>

<b><u>getSpecificSecretFromNamespace</u></b> - Get specific secret from a namespace, however the values for the keys will be Base64 decoded one's. <br/>
<i>Usage - ./getSpecificSecretFromNamespace.sh namespace secret-name </i> <br/>
