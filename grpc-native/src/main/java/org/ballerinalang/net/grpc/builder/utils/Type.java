package org.ballerinalang.net.grpc.builder.utils;

import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;
import org.ballerinalang.net.grpc.builder.syntaxtree.Record;

import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getUnionTypeDescriptorNode;

public class Type {

    public static org.ballerinalang.net.grpc.builder.syntaxtree.Type getValueTypeStream(String name) {
        String typeName = "Context" + name.substring(0,1).toUpperCase() + name.substring(1) + "Stream";
        Record contextStringStream = new Record();
        contextStringStream.addStreamField("content", name);
        contextStringStream.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new org.ballerinalang.net.grpc.builder.syntaxtree.Type(true, typeName, contextStringStream.getRecordTypeDescriptorNode());
    }

    public static org.ballerinalang.net.grpc.builder.syntaxtree.Type getValueType(String name) {
        String typeName = "Context" + name.substring(0,1).toUpperCase() + name.substring(1);
        Record contextString = new Record();
        if (name.equals("string")) {
            contextString.addStringField("content");
        } else {
            contextString.addCustomField("content", name);
        }
        contextString.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new org.ballerinalang.net.grpc.builder.syntaxtree.Type(true, typeName, contextString.getRecordTypeDescriptorNode());
    }

    public static org.ballerinalang.net.grpc.builder.syntaxtree.Type getMessageType(String name) {
        Record message = new Record();
        message.addFieldWithDefaultValue("string", "name");
        message.addFieldWithDefaultValue("string", "message");
        return new org.ballerinalang.net.grpc.builder.syntaxtree.Type(true, name, message.getRecordTypeDescriptorNode());
    }
}
