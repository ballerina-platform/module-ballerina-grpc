import ballerina/grpc;

listener grpc:Listener ep78 = new (9178);

@grpc:Descriptor {value: SERVER_ERROR_TYPES_DESC}
service "ServerErrorTypesService" on ep78 {

    remote function GetServerError(int errorType) returns error? {
        if errorType == 1 {
            return error grpc:CancelledError("Cancelled execution");
        }
        if errorType == 2 {
            return error grpc:UnKnownError("Unknown request");
        }
        if errorType == 3 {
            return error grpc:InvalidArgumentError("Invalid argument");
        }
        if errorType == 4 {
            return error grpc:DeadlineExceededError("Deadline exceeded");
        }
        if errorType == 5 {
            return error grpc:NotFoundError("Not found");
        }
        if errorType == 6 {
            return error grpc:AlreadyExistsError("Already exists");
        }
        if errorType == 7 {
            return error grpc:PermissionDeniedError("Permission denied");
        }
        if errorType == 8 {
            return error grpc:UnauthenticatedError("Unauthenticated");
        }
        if errorType == 9 {
            return error grpc:ResourceExhaustedError("Resource exhausted");
        }
        if errorType == 10 {
            return error grpc:FailedPreconditionError("Failed precondition");
        }
        if errorType == 11 {
            return error grpc:AbortedError("Aborted execution");
        }
        if errorType == 12 {
            return error grpc:OutOfRangeError("Out of range");
        }
        if errorType == 13 {
            return error grpc:UnimplementedError("Unimplemented");
        }
        if errorType == 14 {
            return error grpc:InternalError("Internal error");
        }
        if errorType == 15 {
            return error grpc:UnavailableError("Unavailable");
        }
        if errorType == 16 {
            return error grpc:DataLossError("Data loss");
        }
        return error("Unknown error type");
    }
}

