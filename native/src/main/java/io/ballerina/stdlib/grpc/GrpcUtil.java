/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc;

import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.http.api.HttpConstants;
import io.ballerina.stdlib.http.api.HttpUtil;
import io.ballerina.stdlib.http.transport.contract.Constants;
import io.ballerina.stdlib.http.transport.contract.config.ListenerConfiguration;
import io.ballerina.stdlib.http.transport.contract.config.Parameter;
import io.ballerina.stdlib.http.transport.contract.config.SenderConfiguration;
import io.ballerina.stdlib.http.transport.contract.config.SslConfiguration;
import io.ballerina.stdlib.http.transport.contractimpl.sender.channel.pool.ConnectionManager;
import io.ballerina.stdlib.http.transport.contractimpl.sender.channel.pool.PoolConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static io.ballerina.runtime.api.constants.RuntimeConstants.BALLERINA_VERSION;
import static io.ballerina.runtime.api.utils.StringUtils.fromString;
import static io.ballerina.stdlib.grpc.GrpcConstants.ENDPOINT_CONFIG_SECURESOCKET;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERT;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERTKEY_CERT_FILE;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERTKEY_KEY_FILE;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERTKEY_KEY_PASSWORD;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERT_VALIDATION;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERT_VALIDATION_CACHE_SIZE;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERT_VALIDATION_CACHE_VALIDITY_PERIOD;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERT_VALIDATION_TYPE;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CERT_VALIDATION_TYPE_OCSP_STAPLING;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_CIPHERS;
import static io.ballerina.stdlib.grpc.GrpcConstants.SECURESOCKET_CONFIG_DISABLE_SSL;
import static io.ballerina.stdlib.http.api.HttpConstants.ANN_CONFIG_ATTR_SSL_ENABLED_PROTOCOLS;
import static io.ballerina.stdlib.http.api.HttpConstants.CONNECTION_MANAGER;
import static io.ballerina.stdlib.http.api.HttpConstants.CONNECTION_POOLING_MAX_ACTIVE_STREAMS_PER_CONNECTION;
import static io.ballerina.stdlib.http.api.HttpConstants.LISTENER_CONFIGURATION;
import static io.ballerina.stdlib.http.api.HttpConstants.PKCS_STORE_TYPE;
import static io.ballerina.stdlib.http.api.HttpConstants.PROTOCOL_HTTPS;
import static io.ballerina.stdlib.http.api.HttpConstants.SERVER_NAME;

/**
 * Utility class providing utility methods for gRPC listener and client endpoint.
 *
 * @since 1.0.0
 */
public class GrpcUtil {

    private GrpcUtil() {
    }

    private static final Logger log = LoggerFactory.getLogger(GrpcUtil.class);

    public static ConnectionManager getConnectionManager(BMap<BString, Long> poolStruct) {

        ConnectionManager poolManager = (ConnectionManager) poolStruct.getNativeData(CONNECTION_MANAGER);
        if (poolManager == null) {
            synchronized (poolStruct) {
                if (poolStruct.getNativeData(CONNECTION_MANAGER) == null) {
                    PoolConfiguration userDefinedPool = new PoolConfiguration();
                    populatePoolingConfig(poolStruct, userDefinedPool);
                    poolManager = new ConnectionManager(userDefinedPool);
                    poolStruct.addNativeData(CONNECTION_MANAGER, poolManager);
                }
            }
        }
        return poolManager;
    }

    public static void populatePoolingConfig(BMap poolRecord, PoolConfiguration poolConfiguration) {

        long maxActiveConnections = (Long) poolRecord.get(HttpConstants.CONNECTION_POOLING_MAX_ACTIVE_CONNECTIONS);
        poolConfiguration.setMaxActivePerPool(
                validateConfig(maxActiveConnections, HttpConstants.CONNECTION_POOLING_MAX_ACTIVE_CONNECTIONS));

        long maxIdleConnections = (Long) poolRecord.get(HttpConstants.CONNECTION_POOLING_MAX_IDLE_CONNECTIONS);
        poolConfiguration.setMaxIdlePerPool(
                validateConfig(maxIdleConnections, HttpConstants.CONNECTION_POOLING_MAX_IDLE_CONNECTIONS));

        double waitTime = ((BDecimal) poolRecord.get(fromString("waitTime"))).floatValue();
        poolConfiguration.setMaxWaitTime((long) (waitTime * 1000));

        long maxActiveStreamsPerConnection =
                (Long) poolRecord.get(CONNECTION_POOLING_MAX_ACTIVE_STREAMS_PER_CONNECTION);
        poolConfiguration.setHttp2MaxActiveStreamsPerConnection(
                maxActiveStreamsPerConnection == -1 ? Integer.MAX_VALUE : validateConfig(maxActiveStreamsPerConnection,
                        CONNECTION_POOLING_MAX_ACTIVE_STREAMS_PER_CONNECTION));
    }

    public static void populateSenderConfigurations(SenderConfiguration senderConfiguration,
                                                    BMap<BString, Object> clientEndpointConfig, String scheme) {

        BMap<BString, Object> secureSocket = (BMap<BString, Object>) clientEndpointConfig
                .getMapValue(ENDPOINT_CONFIG_SECURESOCKET);

        if (scheme.equals(HttpConstants.PROTOCOL_HTTPS)) {
            if (secureSocket == null) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("The secureSocket " +
                                "configuration should be provided to establish an HTTPS connection")));
            } else {
                populateSSLConfiguration(senderConfiguration, secureSocket);
            }
        }
        double timeoutSeconds = ((BDecimal) clientEndpointConfig.get(fromString("timeout"))).floatValue();
        if (timeoutSeconds < 0) {
            senderConfiguration.setSocketIdleTimeout(0);
        } else {
            senderConfiguration.setSocketIdleTimeout(
                    validateConfig((long) (timeoutSeconds * 1000), HttpConstants.CLIENT_EP_ENDPOINT_TIMEOUT));
        }
    }

    /**
     * Populates SSL configuration instance with secure socket configuration.
     *
     * @param senderConfiguration SSL configuration instance.
     * @param secureSocket        Secure socket configuration.
     */
    public static void populateSSLConfiguration(SslConfiguration senderConfiguration,
                                                BMap<BString, Object> secureSocket) {

        List<Parameter> clientParamList = new ArrayList<>();
        boolean enable = secureSocket.getBooleanValue(SECURESOCKET_CONFIG_DISABLE_SSL);
        if (!enable) {
            senderConfiguration.disableSsl();
            return;
        }
        Object cert = secureSocket.get(SECURESOCKET_CONFIG_CERT);
        if (cert == null) {
            throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Need to configure " +
                            "cert with client SSL certificates file")));
        }
        evaluateCertField(cert, senderConfiguration);
        BMap<BString, Object> key = getBMapValueIfPresent(secureSocket, GrpcConstants.SECURESOCKET_CONFIG_KEY);
        if (key != null) {
            evaluateKeyField(key, senderConfiguration);
        }
        BMap<BString, Object> protocol = getBMapValueIfPresent(secureSocket,
                GrpcConstants.SECURESOCKET_CONFIG_PROTOCOL);
        if (protocol != null) {
            evaluateProtocolField(protocol, senderConfiguration, clientParamList);
        }
        BMap<BString, Object> certValidation = getBMapValueIfPresent(secureSocket, SECURESOCKET_CONFIG_CERT_VALIDATION);
        if (certValidation != null) {
            evaluateCertValidationField(certValidation, senderConfiguration);
        }
        BArray ciphers = secureSocket.containsKey(SECURESOCKET_CONFIG_CIPHERS) ?
                secureSocket.getArrayValue(SECURESOCKET_CONFIG_CIPHERS) : null;
        if (ciphers != null) {
            evaluateCiphersField(ciphers, clientParamList);
        }
        evaluateCommonFields(secureSocket, senderConfiguration, clientParamList);

        if (!clientParamList.isEmpty()) {
            senderConfiguration.setParameters(clientParamList);
        }
    }

    /**
     * Returns Listener configuration instance populated with endpoint config.
     *
     * @param port           listener port.
     * @param endpointConfig listener endpoint configuration.
     * @return transport listener configuration instance.
     */
    public static ListenerConfiguration getListenerConfig(long port, BMap endpointConfig) {

        BString host = endpointConfig.getStringValue(HttpConstants.ENDPOINT_CONFIG_HOST);
        BMap<BString, Object> sslConfig = endpointConfig.getMapValue(ENDPOINT_CONFIG_SECURESOCKET);
        double idleTimeout = ((BDecimal) endpointConfig.get(fromString("timeout"))).floatValue();

        ListenerConfiguration listenerConfiguration = new ListenerConfiguration();

        if (host == null || host.getValue().trim().isEmpty()) {
            listenerConfiguration.setHost(HttpConstants.HTTP_DEFAULT_HOST);
        } else {
            listenerConfiguration.setHost(host.getValue());
        }

        if (port == 0) {
            throw new RuntimeException("Listener port is not defined!");
        }
        listenerConfiguration.setPort(Math.toIntExact(port));

        if (idleTimeout < 0) {
            throw new RuntimeException("Idle timeout cannot be negative. If you want to disable the " +
                    "timeout please use value 0");
        }
        listenerConfiguration.setSocketIdleTimeout(Math.toIntExact((long) (idleTimeout * 1000)));

        // Set HTTP version
        listenerConfiguration.setVersion(Constants.HTTP_2_0);

        if (endpointConfig.getType().getName().equalsIgnoreCase(LISTENER_CONFIGURATION)) {
            BString serverName = endpointConfig.getStringValue(SERVER_NAME);
            listenerConfiguration.setServerHeader(serverName != null ? serverName.getValue() : getServerName());
        } else {
            listenerConfiguration.setServerHeader(getServerName());
        }

        if (sslConfig != null) {
            return setSslConfig(sslConfig, listenerConfiguration);
        }

        listenerConfiguration.setPipeliningEnabled(true); //Pipelining is enabled all the time
        return listenerConfiguration;
    }

    private static String getServerName() {

        String userAgent;
        String version = System.getProperty(BALLERINA_VERSION);
        if (version != null) {
            userAgent = "ballerina/" + version;
        } else {
            userAgent = "ballerina";
        }
        return userAgent;
    }

    private static ListenerConfiguration setSslConfig(BMap<BString, Object> secureSocket,
                                                      ListenerConfiguration listenerConfiguration) {

        List<Parameter> serverParamList = new ArrayList<>();
        listenerConfiguration.setScheme(PROTOCOL_HTTPS);

        BMap<BString, Object> key = getBMapValueIfPresent(secureSocket, GrpcConstants.SECURESOCKET_CONFIG_KEY);
        assert key != null; // This validation happens at Ballerina level
        evaluateKeyField(key, listenerConfiguration);
        BMap<BString, Object> mutualSsl = getBMapValueIfPresent(secureSocket,
                GrpcConstants.SECURESOCKET_CONFIG_MUTUAL_SSL);
        if (mutualSsl != null) {
            String verifyClient = mutualSsl.getStringValue(GrpcConstants.SECURESOCKET_CONFIG_VERIFY_CLIENT).getValue();
            listenerConfiguration.setVerifyClient(verifyClient);
            Object cert = mutualSsl.get(SECURESOCKET_CONFIG_CERT);
            evaluateCertField(cert, listenerConfiguration);
        }
        BMap<BString, Object> protocol = getBMapValueIfPresent(secureSocket,
                GrpcConstants.SECURESOCKET_CONFIG_PROTOCOL);
        if (protocol != null) {
            evaluateProtocolField(protocol, listenerConfiguration, serverParamList);
        }
        BMap<BString, Object> certValidation = getBMapValueIfPresent(secureSocket, SECURESOCKET_CONFIG_CERT_VALIDATION);
        if (certValidation != null) {
            evaluateCertValidationField(certValidation, listenerConfiguration);
        }
        BArray ciphers = secureSocket.containsKey(SECURESOCKET_CONFIG_CIPHERS) ?
                secureSocket.getArrayValue(SECURESOCKET_CONFIG_CIPHERS) : null;
        if (ciphers != null) {
            evaluateCiphersField(ciphers, serverParamList);
        }
        evaluateCommonFields(secureSocket, listenerConfiguration, serverParamList);

        listenerConfiguration.setTLSStoreType(PKCS_STORE_TYPE);
        if (!serverParamList.isEmpty()) {
            listenerConfiguration.setParameters(serverParamList);
        }
        listenerConfiguration.setId(HttpUtil.getListenerInterface(listenerConfiguration.getHost(),
                listenerConfiguration.getPort()));
        return listenerConfiguration;
    }

    private static void evaluateKeyField(BMap<BString, Object> key, SslConfiguration sslConfiguration) {
        if (key.containsKey(GrpcConstants.SECURESOCKET_CONFIG_KEYSTORE_FILE_PATH)) {
            String keyStoreFile = key.getStringValue(GrpcConstants.SECURESOCKET_CONFIG_KEYSTORE_FILE_PATH).getValue();
            if (keyStoreFile.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("KeyStore file location " +
                                "must be provided for secure connection.")));
            }
            String keyStorePassword = key.getStringValue(GrpcConstants.SECURESOCKET_CONFIG_KEYSTORE_PASSWORD)
                    .getValue();
            if (keyStorePassword.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("KeyStore password must " +
                                "be provided for secure connection.")));
            }
            sslConfiguration.setKeyStoreFile(keyStoreFile);
            sslConfiguration.setKeyStorePass(keyStorePassword);
        } else {
            String certFile = key.getStringValue(SECURESOCKET_CONFIG_CERTKEY_CERT_FILE).getValue();
            String keyFile = key.getStringValue(SECURESOCKET_CONFIG_CERTKEY_KEY_FILE).getValue();
            BString keyPassword = key.containsKey(SECURESOCKET_CONFIG_CERTKEY_KEY_PASSWORD) ?
                    key.getStringValue(SECURESOCKET_CONFIG_CERTKEY_KEY_PASSWORD) : null;
            if (certFile.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Certificate file " +
                                "location must be provided for secure connection.")));
            }
            if (keyFile.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Private key file " +
                                "location must be provided for secure connection.")));
            }
            if (sslConfiguration instanceof ListenerConfiguration) {
                sslConfiguration.setServerCertificates(certFile);
                sslConfiguration.setServerKeyFile(keyFile);
                if (keyPassword != null && !keyPassword.getValue().isBlank()) {
                    sslConfiguration.setServerKeyPassword(keyPassword.getValue());
                }
            } else {
                sslConfiguration.setClientCertificates(certFile);
                sslConfiguration.setClientKeyFile(keyFile);
                if (keyPassword != null && !keyPassword.getValue().isBlank()) {
                    sslConfiguration.setClientKeyPassword(keyPassword.getValue());
                }
            }
        }
    }

    private static void evaluateCertField(Object cert, SslConfiguration sslConfiguration) {
        if (cert instanceof BMap) {
            BMap<BString, BString> trustStore = (BMap<BString, BString>) cert;
            String trustStoreFile = trustStore.getStringValue(GrpcConstants.SECURESOCKET_CONFIG_TRUSTSTORE_FILE_PATH)
                    .getValue();
            String trustStorePassword = trustStore.getStringValue(GrpcConstants.SECURESOCKET_CONFIG_TRUSTSTORE_PASSWORD)
                    .getValue();
            if (trustStoreFile.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("TrustStore file " +
                                "location must be provided for secure connection.")));
            }
            if (trustStorePassword.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("TrustStore password " +
                                "must be provided for secure connection.")));
            }
            sslConfiguration.setTrustStoreFile(trustStoreFile);
            sslConfiguration.setTrustStorePass(trustStorePassword);
        } else {
            String certFile = ((BString) cert).getValue();
            if (certFile.isBlank()) {
                throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Certificate file " +
                                "location must be provided for secure connection.")));
            }
            if (sslConfiguration instanceof ListenerConfiguration) {
                sslConfiguration.setServerTrustCertificates(certFile);
            } else {
                sslConfiguration.setClientTrustCertificates(certFile);
            }
        }
    }

    private static void evaluateProtocolField(BMap<BString, Object> protocol,
                                              SslConfiguration sslConfiguration,
                                              List<Parameter> paramList) {
        List<String> sslEnabledProtocolsValueList = Arrays.asList(
                protocol.getArrayValue(GrpcConstants.SECURESOCKET_CONFIG_PROTOCOL_VERSIONS).getStringArray());
        if (!sslEnabledProtocolsValueList.isEmpty()) {
            String sslEnabledProtocols = sslEnabledProtocolsValueList.stream().collect(
                    Collectors.joining(",", "", ""));
            Parameter serverProtocols = new Parameter(ANN_CONFIG_ATTR_SSL_ENABLED_PROTOCOLS, sslEnabledProtocols);
            paramList.add(serverProtocols);
        }
        String sslProtocol = protocol.getStringValue(GrpcConstants.SECURESOCKET_CONFIG_PROTOCOL_NAME).getValue();
        if (!sslProtocol.isBlank()) {
            sslConfiguration.setSSLProtocol(sslProtocol);
        }
    }

    private static void evaluateCertValidationField(BMap<BString, Object> certValidation,
                                                    SslConfiguration sslConfiguration) {
        String type = certValidation.getStringValue(SECURESOCKET_CONFIG_CERT_VALIDATION_TYPE).getValue();
        if (type.equals(SECURESOCKET_CONFIG_CERT_VALIDATION_TYPE_OCSP_STAPLING.getValue())) {
            sslConfiguration.setOcspStaplingEnabled(true);
        } else {
            sslConfiguration.setValidateCertEnabled(true);
        }
        long cacheSize = certValidation.getIntValue(SECURESOCKET_CONFIG_CERT_VALIDATION_CACHE_SIZE).intValue();
        long cacheValidityPeriod = certValidation.getIntValue(
                SECURESOCKET_CONFIG_CERT_VALIDATION_CACHE_VALIDITY_PERIOD).intValue();
        if (cacheValidityPeriod != 0) {
            sslConfiguration.setCacheValidityPeriod(Math.toIntExact(cacheValidityPeriod));
        }
        if (cacheSize != 0) {
            sslConfiguration.setCacheSize(Math.toIntExact(cacheSize));
        }
    }

    private static void evaluateCiphersField(BArray ciphers, List<Parameter> paramList) {
        Object[] ciphersArray = ciphers.getStringArray();
        List<Object> ciphersList = Arrays.asList(ciphersArray);
        if (ciphersList.size() > 0) {
            String ciphersString = ciphersList.stream().map(Object::toString).collect(
                    Collectors.joining(",", "", ""));
            Parameter serverParameters = new Parameter(HttpConstants.CIPHERS, ciphersString);
            paramList.add(serverParameters);
        }
    }

    private static void evaluateCommonFields(BMap<BString, Object> secureSocket, SslConfiguration sslConfiguration,
                                             List<Parameter> paramList) {
        if (!(sslConfiguration instanceof ListenerConfiguration)) {
            boolean hostNameVerificationEnabled = secureSocket.getBooleanValue(
                    GrpcConstants.SECURESOCKET_CONFIG_HOST_NAME_VERIFICATION_ENABLED);
            sslConfiguration.setHostNameVerificationEnabled(hostNameVerificationEnabled);
        }
        sslConfiguration.setSslSessionTimeOut((int) getLongValueOrDefault(secureSocket,
                GrpcConstants.SECURESOCKET_CONFIG_SESSION_TIMEOUT));
        sslConfiguration.setSslHandshakeTimeOut(getLongValueOrDefault(secureSocket,
                GrpcConstants.SECURESOCKET_CONFIG_HANDSHAKE_TIMEOUT));
        String enableSessionCreation = String.valueOf(secureSocket.getBooleanValue(
                GrpcConstants.SECURESOCKET_CONFIG_SHARE_SESSION));
        Parameter enableSessionCreationParam = new Parameter(GrpcConstants.SECURESOCKET_CONFIG_SHARE_SESSION.getValue(),
                enableSessionCreation);
        paramList.add(enableSessionCreationParam);
    }

    private static BMap<BString, Object> getBMapValueIfPresent(BMap<BString, Object> map, BString key) {
        return map.containsKey(key) ? (BMap<BString, Object>) map.getMapValue(key) : null;
    }

    private static long getLongValueOrDefault(BMap<BString, Object> map, BString key) {
        return map.containsKey(key) ? ((BDecimal) map.get(key)).intValue() : 0L;
    }

    private static int validateConfig(long value, BString configName) {

        try {
            return Math.toIntExact(value);
        } catch (ArithmeticException e) {
            log.warn("The value set for the configuration needs to be less than {}. The " + configName.getValue() +
                    "value is set to {}", Integer.MAX_VALUE);
            return Integer.MAX_VALUE;
        }
    }

    public static String getTypeName(Type type) {
        if (type.getTag() == TypeTags.TUPLE_TAG) {
            return "Timestamp";
        } else if (type.getTag() == TypeTags.DECIMAL_TAG) {
            return "Duration";
        } else if (type.getTag() == TypeTags.MAP_TAG) {
            return "Struct";
        }
        return type.getName();
    }
}
