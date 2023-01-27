# AZD Deployment - JBoss EAP Pet Store Application Deployed to Azure App Service (AAS) 
## Description 
In this sample app template of the Pet Store application.The  Application is deployed to an Azure App Service (AAS) secured by Azure Firewall

## Deploy JBoss EAP Applicaiton to Azure App Services:

--
Tech stack:

- Azure App Service
- Azure App Service Plan
- Azure Fire Wall
- Azure Bastion
- Azure App Service (AAS)
- Azure PostgreSQL DB
- Bicep
- Maven

---

## Introduction

This is a quickstart template. It deploys the following:

* Deploying Pet Store App:
  *  *** NOTE*** if you are deplying this from a subscription and not an actual Environment, please rememeber to set the template Environment to your Resoure Group with the following command:
    - azd env set AZURE_RESOURCE_GROUP petstore_AZD_eastus
  
  * Use the following Command:
    - azd up 
 
  * Use the follwoing Commands
    - azd init
    - azdProvision
    - azd  Deploy

> Refer to the [App Templates](https://github.com/microsoft/App-Templates) repo Readme for more samples that are compatible with [AzureAccelerators](https://github.com/Azure/azure-dev/).

## Prerequisites
- Local shell with Azure CLI installed or [Azure Cloud Shell](https://ms.portal.azure.com/#cloudshell/)
- Azure Subscription, on which you are able to create resources and assign permissions
  - View your subscription using ```az account show``` 
  - If you don't have an account, you can [create one for free](https://azure.microsoft.com/free).  

## Getting Started
### Fork the repository

1.  Fork the repository by clicking the 'Fork' button on the top right of the page.
This creates a local copy of the repository for you to work in. 

2.  Run "azd init" to initialize your project. 
  - select empty template
  - supply an environment name. Can be anything. I use "tsn106"
  - pick a region
  - supply an Azure subscription

3. Run "azd provision" to provision the Azure resources.  
  
4. After running azd init, the azure.yaml file is also added to the root of your project. Think of azure.yaml as the app’s user manual for azd. azd refers to this file to learn more about the app so that it knows, for instance, what Azure service will be hosting your app, how to build and deploy your app.

5. Finally, deploy the app by running: "azd deploy".
 
# Pet Store Website

<img width="1042" alt="petstore-screenshot" src="https://github.com/MikeTB-Microsoft/App_Template_JBoss_EAP_on_AppService/blob/main/src/jbossappser-construction/images/petstore02.png">


# Pet Store Website - IP Address 

4. If you wish to view the Pet Store Deployment, you have the following options:

- Log into the Azure Portal
- Nagivate to the "petstore_hub_eastus" Resource Group
- Navigate to the App Service to view the website link
