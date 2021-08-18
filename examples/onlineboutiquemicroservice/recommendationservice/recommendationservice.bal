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
