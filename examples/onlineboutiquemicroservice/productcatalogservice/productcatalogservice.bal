import ballerina/grpc;
import ballerina/io;

const string CATALOG_PATH = "resources/products.json";

listener grpc:Listener adListener = new (3550);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "ProductCatalogService" on adListener {

    remote function ListProducts() returns ListProductsResponse|error? {
        ProductUtil utils = check new ();
        ListProductsResponse response = {
            products: check utils.getProducts()
        };
        return response;
    }

    remote function GetProduct(GetProductRequest request) returns Product|error? {
        ProductUtil utils = check new ();
        Product[] products = check utils.getProducts();
        foreach Product product in products {
            if product.id == request.id {
                return product;
            }
        }
        return {};
    }

    remote function SearchProducts(SearchProductsRequest request) returns SearchProductsResponse|error? {
        ProductUtil utils = check new ();
        Product[] productResults = [];
        Product[] products = check utils.getProducts();
        foreach Product product in products {
            if product.name.toLowerAscii().includes(request.query.toLowerAscii()) || product.description.toLowerAscii().includes(request.query.toLowerAscii()) {
                productResults.push(product);
            }
        }
        return {
            results: productResults
        };
    }

}

class ProductUtil {

    json productCatalog = {};

    function init() returns error? {
        check self.readCatalog();
    }

    function readCatalog() returns error? {
        self.productCatalog = check io:fileReadJson(CATALOG_PATH);
    }

    function getProducts() returns Product[]|error {
        json jsonProducts = check self.productCatalog.products;
        Product[] products = check self.mapJsonListToProductList(jsonProducts);
        return products;
    }

    private function mapJsonListToProductList(json jsonList) returns Product[]|error {
        anydata[] jsonProducts = <anydata[]> jsonList;
        Product[] products = [];
        foreach var jsonProduct in jsonProducts {
            prod mprod = check jsonProduct.cloneWithType(prod);
            Money money = {
                currency_code: mprod.priceUsd.currencyCode,
                nanos: mprod.priceUsd.nanos,
                units: mprod.priceUsd.units
            };
            Product product = {
                id: mprod.id,
                name: mprod.name,
                description: mprod.description,
                picture: mprod.picture,
                price_usd: money,
                categories: mprod.categories
            };
            products.push(product);
        }
        return products;
    }
}

type PriceUsd record {|
    string currencyCode;
    int units = 0;
    int nanos = 0;
|};

type prod record {|
    string id;
    string name;
    string description;
    PriceUsd priceUsd;
    string picture;
    string[] categories;
|};
