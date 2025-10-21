# XP264- Explore how to run cloud-native applications on SAP BTP, Kyma runtime

## Description

This repository contains the material for the SAP TechEd 2025 session catalog number XP264 - [**Explore how to run cloud-native applications on SAP BTP, Kyma runtime.**](https://www.sap.com/events/teched/berlin/flow/sap/te25/catalog-inperson/page/catalog/session/1749035076180001oik0)  

  * Day-2 Operations: Maintenance, Monitoring, and Optimization
  * Onpremise connectivity

## Overview

This session introduces attendees to **Day-2** operation with SAP BTP, Kyma runtime - to help connect and extend enterprise applications in the cloud-native world.  

> SAP BTP, Kyma Runtime (SKR) is a managed offering of a Kubernetes Cluster based on Gardener, extended by set of building blocks called Kyma modules. The idea is that each instance of the Kyma runtime is a separate Kubernetes cluster with its own set of modules. Clusters are not shared between customers, and each customer has its own isolated environment. All instances are managed by a central Kyma Control Plane (KCP) that orchestrates the lifecycle of the underlying hyperscaler project, the Gardener Cluster, and the Kyma modules.


<table style="width: 100%; border-collapse: collapse; background-color: #f5f5f5;" border="1">
<tbody>
<tr style="height: 193px;">
<td style="width: 71.6%; height: 193px;">
<div>
<h1><a href="https://help.sap.com/docs/btp/sap-business-technology-platform/kyma-environment"><img class="aligncenter" src="exercises/ex0/images/kyma-runtime-stack.drawio.svg" alt="" height="600"/></a></h1>
</div>
</td>
</tr>
</tbody>
</table> 

### During the session you will learn

  * how to run applications on the Kyma runtime for SAP BTP and discover the power of smooth integration with cloud applications and on-premise systems using the advanced connectivity features.  
  * to explore operational best practices from mastering troubleshooting techniques and intelligent root-cause analysis to event-driven autoscaling that adapts to your business needs in real time.
  * about multitenant application with SAP BTP, Kyma runtime.

## Requirements

The requirements to follow the exercises in this repository are...

  * You need to have a GitHub user. If you don't have one so far, please sign-up on GitHub before going through the exercises
  * Additional configuration on your SAP TECHED 2025 Client laptop (that should be pre-installed)
    
  kubectl plugins | install [jq](https://jqlang.org/download/) | [Kyma CLI for SAP BTP, Kyma Runtime](https://tools.hana.ondemand.com/#cloud) |
  -- | -- | -- |
  install [krew.exe](https://github.com/kubernetes-sigs/krew/releases/download/v0.4.5/krew.exe) | install jq with `winget install jqlang.jq` | install [kyma cli](https://github.com/kyma-project/cli/releases/download/3.2.0/kyma_Windows_x86_64.zip) 
  installing the oidc-login plugin | |
  install view-serviceaccount-kubeconfig plugin | |

  * Github actions (GHA). You may run the GHA-based exercises direclty from a browser on the laptop from your forked repository.  Alternatively, you may use VSCode terminal and other plugins you may be familiar with.

  * As this is a Day-2 operation brief, the entire cloud landscape has been pre-configured with a number of shared components like SAP Cloud Logging, SAP HANA Cloud and others.  
    * All the SAP Kyma environments have been configured to the same template (via terraform automation).  
    * Each SAP Kyma kubernetes cluster offers the same setup (with very minor differences)...

  * Last but not least, you will be able to *play* with a pre-deployed SAP Build multitenant application which follows BTP multitenancy paradigm.  

## Exercises

* #### [Exercise 0 - Preparation Steps](exercises/ex0#exercice-0---preparation-steps)

  * [Exercise 0.0 - Sign up for a GitHub account](exercises/ex0#exercise-00---sign-up-for-a-new-github-account)
  * [Exercise 0.1 - Create a Copy of This Repository](exercises/ex0#exercise-01---create-a-copy-of-this-repository)
  * [Exercise 0.2 - Discover your SAP BTP managed kubernetes landscape](exercises/ex0#exercise-02---discover-your-managed-kubernetes-landscape)
  * [Exercise 0.3 - Solution brief. Functional architecture](exercises/ex0#exercise-03---solution-brief-funtional-architecture)

* #### [Exercise 1 - First things first. Getting acquainted with SAP BTP, Kyma Runtime (SKR)](exercises/ex1#exercise-1---first-things-first-getting-acquainted-with-sap-btp-kyma-runtime-skr)

  * [Exercise 1.0 - Discover SAP Kyma architecture](exercises/ex1#exercise-10---discover-sap-kyma-architecture)
  * [Exercise 1.1 - Easy access to your teched landscape.](exercises/ex1#exercise-11---easy-access-to-your-teched-landscape)
  * [Exercise 1.2 - Discover Kyma CLI](exercises/ex1#exercise-12---discover-kyma-cli)
  * [Exercise 1.3 - Firefighter access to your kyma cluster](exercises/ex1#exercise-13---fire-fighter-access-to-your-kyma-cluster)
  * [Exercise 1.4 - Getting to know your kyma cluster in more details](exercises/ex1#exercise-14---getting-to-know-your-kyma-cluster)
  * [Exercise 1.5 - Accessing other diagnostic information with btp and kubernetes terraform providers](exercises/ex1#exercise-15---accessing-other-diagnostic-information-with-btp-and-kubernetes-terraform-providers)
  * [Exercise 1.6 - Multitenancy playground](exercises/ex1#exercise-16---btp-multitenancy-with-kyma)


Provide the exercise content here directly in README.md using [markdown](https://guides.github.com/features/mastering-markdown/) and linking to the specific exercise pages, below is an example.

- [Getting Started](exercises/ex0/)
- [Exercise 1 - First Exercise Description](exercises/ex1/)
    - [Exercise 1.1 - Exercise 1 Sub Exercise 1 Description](exercises/ex1#exercise-11-sub-exercise-1-description)
    - [Exercise 1.2 - Exercise 1 Sub Exercise 2 Description](exercises/ex1#exercise-12-sub-exercise-2-description)
- [Exercise 2 - Second Exercise Description](exercises/ex2/)
    - [Exercise 2.1 - Exercise 2 Sub Exercise 1 Description](exercises/ex2#exercise-21-sub-exercise-1-description)
    - [Exercise 2.2 - Exercise 2 Sub Exercise 2 Description](exercises/ex2#exercise-22-sub-exercise-2-description)

  
**OR** Link to the Tutorial Navigator for example...

Start the exercises [here](https://developers.sap.com/tutorials/abap-environment-trial-onboarding.html).

**IMPORTANT**

Your repo must contain the .reuse and LICENSES folder and the License section below. DO NOT REMOVE the section or folders/files. Also, remove all unused template assets(images, folders, etc) from the exercises folder. 

## Contributing
Please read the [CONTRIBUTING.md](./CONTRIBUTING.md) to understand the contribution guidelines.

## Code of Conduct
Please read the [SAP Open Source Code of Conduct](https://github.com/SAP-samples/.github/blob/main/CODE_OF_CONDUCT.md).

## How to obtain support

Support for the content in this repository is available during the actual time of the online session for which this content has been designed. Otherwise, you may request support via the [Issues](../../issues) tab.

## License
Copyright (c) 2024 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
