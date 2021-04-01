package org.ballerinalang.net.grpc.builder.syntaxtree.utils;

import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;
import org.ballerinalang.net.grpc.builder.stub.EnumField;
import org.ballerinalang.net.grpc.builder.stub.EnumMessage;
import org.ballerinalang.net.grpc.builder.stub.Field;
import org.ballerinalang.net.grpc.builder.stub.Message;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Enum;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Type;

import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;

public class Types {

    public static Type getValueTypeStream(String name) {
        String typeName = "Context" + name.substring(0,1).toUpperCase() + name.substring(1) + "Stream";
        Record contextStringStream = new Record();
        contextStringStream.addStreamField("content", name);
        contextStringStream.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new Type(true, typeName, contextStringStream.getRecordTypeDescriptorNode());
    }

    public static Type getValueType(String key) {
        String typeName = "Context" + key.substring(0,1).toUpperCase() + key.substring(1);
        Record contextString = new Record();
        if (key.equals("string")) {
            contextString.addStringField("content");
        } else {
            contextString.addCustomField("content", key);
        }
        contextString.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new Type(true, typeName, contextString.getRecordTypeDescriptorNode());
    }

    public static Type getMessageType(Message message) {
        Record messageRecord = new Record();
        for (Field field : message.getFieldList()) {
            switch (field.getFieldType()) {
                case "string" :
                    messageRecord.addStringFieldWithDefaultValue(
                            field.getFieldName(),
                            field.getDefaultValue());
                    break;
                case "boolean" :
                    messageRecord.addBooleanFieldWithDefaultValue(
                            field.getFieldName(),
                            field.getDefaultValue());
                    break;
                default:
                    messageRecord.addCustomFieldWithDefaultValue(
                            field.getFieldType(),
                            field.getFieldName(),
                            field.getDefaultValue());
            }
        }
        return new Type(
                true,
                message.getMessageName(),
                messageRecord.getRecordTypeDescriptorNode());
    }

    public static Enum getEnumType(EnumMessage enumMessage) {
        Enum enumMsg = new Enum(enumMessage.getMessageName(), true);
        for (EnumField field : enumMessage.getFieldList()) {
            enumMsg.addMember(Enum.getEnumMemberNode(field.getName()));
        }
        return enumMsg;
    }
}
