// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/grpc;
import ballerina/lang.'int;
import ballerina/random;

listener grpc:Listener recListener = new (8080);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "RecommendationService" on recListener {

    remote function ListRecommendations(ListRecommendationsRequest request) returns ListRecommendationsResponse|error? {
        int max_responses = 5;
        ProductCatalogServiceClient prodCatalogClient = check new ("http://productcatalogservice:3550");

        ListProductsResponse productResponse = check prodCatalogClient->ListProducts({});
        Product[] filteredProducts = [];

        foreach Product product in productResponse.products {
            int? result = request.product_ids.indexOf(product.id);
            if result is () {
                filteredProducts.push(product);
            }
        }

        int productCount = 'int:min(filteredProducts.length(), max_responses);
        string[] responseIds = [];
        foreach int i in 0..< productCount {
            int randomIndex = check random:createIntInRange(0, filteredProducts.length());
            Product randomProd = filteredProducts.remove(randomIndex);
            responseIds.push(randomProd.id);
        }

        ListRecommendationsResponse response = {
            product_ids: responseIds
        };
        return response;
    }

}
