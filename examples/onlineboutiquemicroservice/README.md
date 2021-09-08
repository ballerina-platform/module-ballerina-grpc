# Online Boutique Microservices Example

## Overview

Online Boutique Microservices example is based on the [cloud-native microservices demo application](https://github.com/GoogleCloudPlatform/microservices-demo) of [Google Cloud Platform](https://github.com/GoogleCloudPlatform). 
The original example consists of 10 microservices implemented in various languages and 3 of those microservices are implemented in Ballerina here.
This example shows how Ballerina gRPC module can work effectively with microservices implemented in other languages.

Following shows an overview of the microservices.

| Service                                              | Language      | Description                                                                                                                       |
| ---------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [frontend](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/frontend)                           | Go            | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/cartservice)                     | C#            | Stores the items in the user's shopping cart in Redis and retrieves it.                                                           |
| [productcatalogservice](./productcatalogservice) | Ballerina     | Provides the list of products from a JSON file and ability to search products and get individual products.                        |
| [currencyservice](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/currencyservice)             | Node.js       | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/paymentservice)               | Node.js       | Charges the given credit card info (mock) with the given amount and returns a transaction ID.                                     |
| [shippingservice](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/shippingservice)             | Go            | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock)                                 |
| [emailservice](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/emailservice)                   | Python        | Sends users an order confirmation email (mock).                                                                                   |
| [checkoutservice](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/checkoutservice)             | Go            | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.                            |
| [recommendationservice](./recommendationservice) | Ballerina     | Recommends other products based on what's given in the cart.                                                                      |
| [adservice](./adservice)                         | Ballerina     | Provides text ads based on given context words.                                                                                   |
| [loadgenerator](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/loadgenerator)                 | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend.                                              |

## Run the Example

### Prerequisites
#### Docker and Kubernetes
- Use [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) to install on Mac.
- Use [Docker for Windows](https://docs.docker.com/docker-for-windows/) to install on Windows.
- Install [Docker CE](https://docs.docker.com/v17.12/install/#server) and [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) on Linux.

**Note**: Execute `eval $(minikube docker-env)` after installing Minikube so
that the Docker client points to Minikube’s docker registry.

For this example to work, all the 10 microservices must be running. Therefore, you have to run the following services from [cloud-native microservices demo application](https://github.com/GoogleCloudPlatform/microservices-demo).
* [Frontend](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/frontend)
* [Cart Service](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/cartservice)
* [Currency Service](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/currencyservice)
* [Payment Service](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/paymentservice)
* [Shipping Service](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/shippingservice)
* [Email Service](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/emailservice)
* [Checkout Service](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/checkoutservice)
* [Loadgenerator](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/loadgenerator)

1. Clone the [cloud-native microservices demo application](https://github.com/GoogleCloudPlatform/microservices-demo) of [Google Cloud Platform](https://github.com/GoogleCloudPlatform) and continue to the repository directory.
2. The `kubernetes-manifests` file contains the deploying instructions for all the 10 services. Therefore, first remove the content related to the `adservice, recommendationservice` and `productcatalogservice`.
3. Run `kubectl apply -f ./release/kubernetes-manifests.yaml`to deploy the 7 services.
   
    Note: You can run `kubectl delete -f ./release/kubernetes-manifests.yaml` to stop the 7 services when in need.
4. Now clone this repository and run `sh examples/onlineboutiquemicroservice/scripts/start.sh`(This will build the 3 services and deploy in kubernetes).
5. Run `kubectl get pods` to see whether pods are in a Ready state.
6. If all the pods are running, run `kubectl get service/frontend-external` to get the frontend-external ip.
7. Visit the application on your browser to confirm installation.
   
   Note: If you are on Minikube, get the hostname by executing `minikube ip`. e.g., <MINIKUBE_IP>:<FRONTEND_EXTERNAL_PORT>
8. Run `sh examples/onlineboutiquemicroservice/scripts/stop.sh` to stop the 3 services.

You can rewrite any of the above 7 services using Ballerina to replace the existing services and deploy on kubernetes.
