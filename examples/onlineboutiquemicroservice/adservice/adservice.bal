import ballerina/grpc;
import ballerina/random;

listener grpc:Listener adListener = new (9555);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "AdService" on adListener {

    remote function GetAds(AdRequest request) returns AdResponse|error? {
        AdFactory adFactory = new();
        Ad[] ads = [];
        foreach string category in request.context_keys {
            Ad[] availableAds = adFactory.getAdsByCategory(category);
            availableAds.forEach(function (Ad ad) {
                ads.push(ad);
            });
        }
        if ads.length() == 0 {
            ads = check adFactory.getRandomAds();
        }
        AdResponse response = {
            ads: ads
        };
        return response;
    }

}

class AdFactory {

    map<Ad[]> ads = {};
    private int MAX_ADS_TO_SERVE = 2;

    function init() {
        self.ads = self.getAds();
    }

    function getAds() returns map<Ad[]> {
        Ad camera = {
            redirect_url: "/product/2ZYFJ3GM2N",
            text: "Film camera for sale. 50% off."
        };
        Ad lens = {
            redirect_url: "/product/66VCHSJNUP",
            text: "Vintage camera lens for sale. 20% off."
        };
        Ad recordPlayer = {
            redirect_url: "/product/0PUK6V6EV0",
            text: "Vintage record player for sale. 30% off."
        };
        Ad bike = {
            redirect_url: "/product/9SIQT8TOJO",
            text: "City Bike for sale. 10% off."
        };
        Ad baristaKit = {
            redirect_url: "/product/1YMWWN1N4O",
            text: "Home Barista kitchen kit for sale. Buy one, get second kit for free"
        };
        Ad airPlant = {
            redirect_url: "/product/6E92ZMYYFZ",
            text: "Air plants for sale. Buy two, get third one for free"
        };
        Ad terrarium = {
            redirect_url: "/product/L9ECAV7KIM",
            text: "Terrarium for sale. Buy one, get second one for free"
        };
        return {
            "photography": [camera, lens],
            "vintage": [camera, lens, recordPlayer],
            "cycling": [bike],
            "cookware": [baristaKit],
            "gardening": [airPlant, terrarium]
        };
    }

    public function getRandomAds() returns Ad[]|random:Error {
        Ad[] allAds = [];
        self.ads.forEach(function (Ad[] ads) {
            ads.forEach(function (Ad ad) {
                allAds.push(ad);
            });
        });
        Ad[] randomAds = [];
        foreach int i in 0 ..< self.MAX_ADS_TO_SERVE {
            randomAds.push(allAds[check random:createIntInRange(0, allAds.length())]);
        }
        return randomAds;
    }

    public function getAdsByCategory(string category) returns Ad[] {
        return self.ads.get(category);
    }
}
