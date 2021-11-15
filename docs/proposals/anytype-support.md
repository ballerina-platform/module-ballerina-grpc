# Proposal: Protocol Buffers Any Type Support for gRPC

_Ownes_: @shafreenAnfar @daneshk @BuddhiWathsala @MadhukaHarith92 @dilanSachi  
_Reviewers_: @shafreenAnfar @daneshk @MadhukaHarith92 @dilanSachi  
_Created_: 2021/11/05   
_Updated_: 2021/11/10  
_Issues_: [#1647](https://github.com/ballerina-platform/ballerina-standard-library/issues/1647)  [#2365](https://github.com/ballerina-platform/ballerina-standard-library/issues/2365)  

## Summary
In gRPC, our practice is to use statically-typed messages defined in the protocol buffer definition. However, some microservices have requirements to use dynamic types instead of these static types. For example, when someone develops a proxy service, they cannot stick to one specific message type. On the other hand, there are some use cases where we cannot expose the exact message definition due to security concerns. As a solution for that, protocol buffers allow us to use a type called `Any` that can be any predefined message type or a scalar type. In this proposal, we describe how Ballerina gRPC supports the protobuf `Any` data type.

## Goals
To enable the protobuf `Any` type support in Ballerina gRPC.

## Non-Goals
The type URL in the `Any` type act as a unique identifier to deserialize the message. The type defined in the type URL should be available in the protobuf file. In other words, here, we will only support types URLs start with `type.googleapis.com`. The HTTP/HTTPS URL support will not be available in this version, and the support for them will be available in future.

## Motivation
To allow users to use dynamic message types in gRPC without restricting them to static message types.

## Description
Ballerina stores all the predefined protobuf messages (such as Duration, Timestamp, and wrappers) in the Ballerina protobuf library. Similarly, the definition of the `Any` type will store in the protobuf library. Ballerina defines the protobuf `Any` type as follows.

```ballerina
// Subtypes that are allowed as Any type
public type ValueType int|float|string|boolean|time:Utc|time:Seconds|record {}|()|byte[];

public type ValueTypeDesc typedesc<ValueType>;

# Represent protobuf `Any` type.
#
# + typeUrl - The URL identifier of the message  
# + value - The message  
public type Any record {|
    string typeUrl;
    ValueType value;
|};
```

There is no one to one mapping between protobuf scalar types and Ballerina primitive types. For example, protobuf int32, int64, and other integer representations represent Ballerina int. When we use a Ballerina int as a protobuf `Any` type, the Ballerina gRPC library does not have a way to identify the exact protobuf mapping because Ballerina int could be protobuf int32, int64, or any other integer representation. To solve that problem, Ballerina gRPC makes assumptions to do the protobuf to Ballerina mapping as described in the following table.

|Protobuf Type|Ballerina Type|
|---|---|
|google.protobuf.DoubleValue|float|
|google.protobuf.FloatValue|float|
|google.protobuf.Int64Value|int|
|google.protobuf.UInt64Value|int|
|google.protobuf.Int32Value|int|
|google.protobuf.UInt32Value|int|
|google.protobuf.BoolValue|boolean|
|google.protobuf.StringValue|string|
|google.protobuf.BytesValue|byte[]|
|google.protobuf.Empty|()|
|google.protobuf.Timestamp|time:Utc|
|google.protobuf.Duration|time:Seconds|

The two main actions that users need to use `Any` type is to serialize and deserialize the messages. To do that, two APIs will be introduced to the Ballerina protobuf library. These two APIs will be introduced to the `types.'any` submodule of the protobuf library.

```ballerina
# Generate and return the generic `'any:Any` record that used to represent protobuf `Any` type.
#
# + message - The record or the scalar value to be packed as Any type
# + return - Any value representation of the given message  
public isolated function pack(ValueType message) returns Any;

# Unpack and return the specified Ballerina value
#
# + anyValue - Any value to be unpacked
# + targetTypeOfAny - Type descriptor of the return value
# + return - Return a value of the given type  
public isolated function unpack(Any anyValue, ValueTypeDesc targetTypeOfAny = <>) returns targetTypeOfAny|'any:Error;
```

The usage of the pack and unpack APIs is as follows.

```ballerina
import ballerina/protobuf.types.'any;

// Pack
Person person = {age:70, name:"Jo"};
'any:Any anyValue = 'any:pack(person);

// Unpack
Person|'any:Error person = 'any:unpack(anyValue, Person);
string|'any:Error name = 'any:unpack(pp, string);
```

Here, we need to return an error in the unpack API when users try to unpack to an incorrect type. The unpack API will return an 'any:Error. This 'any:Error will be a subtype of the error defined in the root protobuf module protobuf:Error.

## Testing
- Simple gRPC call that passes protobuf wrapper value (e.g. StringValue, DoubleValue, and Int64Value) as Any type
- Simple gRPC call that passes a user-defined message as Any type
- Simple gRPC call with Any type and headers
- gRPC server streaming call with Any type
- gRPC client streaming call with Any type
- gRPC bidirectional call with Any type


## References
[1] [Protobuf Documentation](https://developers.google.com/protocol-buffers/docs/proto3#any)  
[2] [Any Type Protobuf Definition](https://github.com/protocolbuffers/protobuf/blob/3a4d9316aa9e3f0afec58e83ed744b0be4d337fa/src/google/protobuf/any.proto)

