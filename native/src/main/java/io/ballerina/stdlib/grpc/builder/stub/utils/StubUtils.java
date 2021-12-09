package io.ballerina.stdlib.grpc.builder.stub.utils;

/**
 * Utilities related to Stub files.
 *
 */
public class StubUtils {

    public static final String[] RESERVED_LITERAL_NAMES = {
            "import", "as", "public", "private", "external", "final", "service", "resource", "function", "object",
            "record", "annotation", "parameter", "transformer", "worker", "listener", "remote", "xmlns", "returns",
            "version", "channel", "abstract", "client", "const", "typeof", "source", "from", "on", "group", "by",
            "having", "order", "where", "followed", "for", "window", "every", "within", "snapshot", "inner", "outer",
            "right", "left", "full", "unidirectional", "forever", "limit", "ascending", "descending", "int", "byte",
            "float", "decimal", "boolean", "string", "error", "map", "json", "xml", "table", "stream", "any",
            "typedesc", "type", "future", "anydata", "handle", "var", "new", "init", "if", "match", "else",
            "foreach", "while", "continue", "break", "fork", "join", "some", "all", "try", "catch", "finally", "throw",
            "panic", "trap", "return", "transaction", "abort", "retry", "onretry", "retries", "committed", "aborted",
            "with", "in", "lock", "untaint", "start", "but", "check", "checkpanic", "primarykey", "is", "flush",
            "wait", "default", "enum", "error"};
}
