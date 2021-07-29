
listener Listener ep57 = new (9157);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_57, descMap: getDescriptorMap57()}
service "StructService" on ep57 {

    remote function getStruct(string value) returns map<anydata>|error {
        map<anydata> res = {
            "t": false,
            "u": 123473623,
            "v": true,
            "w": 12.085,
            "x": "first",
            "y": 150
            // "z": [1,2,3]
        };
        return res;
    }

    remote function sendStruct(map<anydata> value) returns string|error {
        map<anydata> expected = {
            "t": false,
            "u": 123473623,
            "v": true,
            "w": 12.085,
            "x": "first",
            "y": 150
            // "z": [1,2,3]
        };
        if expected == value {
            return "OK";
        }
        return value.toString();
    }

    remote function exchangeStruct(map<anydata> value) returns map<anydata>|error {
        map<anydata> expected = {
            "t": false,
            "u": 123473623,
            "v": true,
            "w": 12.085,
            "x": "first",
            "y": 150
            // "z": [1,2,3]
        };
        if expected == value {
            map<anydata> sending = {
                "a": true,
                "b": -15245,
                "c": false,
                "d": -12.085,
                "e": "second",
                "f": -150
                // "z": [1,2,3]
            };
            return sending;
        }
        return value;
    }
}

