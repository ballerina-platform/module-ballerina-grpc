/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package io.ballerina.stdlib.grpc;

import org.testng.annotations.Test;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.fail;

/**
 * A test class to test ServiceDefinition class functions.
 */
public class ServiceDefinitionTest {

    private String invalidDescriptor = "0A1530375F756E6172795F7365727665722E70726F746F120C6772706373657276696365731A" +
            "1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F627566" +
            "2F656D7074792E70726F746F22370A075265717565737412120A046E616D6518012001280952046E616D6512180A0" +
            "76D65737361676518022001280952076D657373616765221E0A08526573706F6E736512120A04726573701801200" +
            "1280952047265737032C4040A0D48656C6C6F576F726C6431303012430A0568656C6C6F121C2E676F6F676C652E70" +
            "726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616" +
            "C756512430A0774657374496E74121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E67" +
            "6F6F676C652E70726F746F6275662E496E74333256616C756512450A0974657374466C6F6174121B2E676F6F676C6" +
            "52E70726F746F6275662E466C6F617456616C75651A1B2E676F6F676C652E70726F746F6275662E466C6F6174566" +
            "16C756512450A0B74657374426F6F6C65616E121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651" +
            "A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565123B0A0A7465737453747275637412152E6772" +
            "706373657276696365732E526571756573741A132E6772706373657276696365732E526573706F6E736512450A0D" +
            "746573744E6F5265717565737412162E676F6F676C652E70726F746F6275662E456D7074791A1C2E676F6F676C652E" +
            "70726F746F6275662E537472696E6756616C756512460A0E746573744E6F526573706F6E7365121C2E676F6F676C6" +
            "52E70726F746F6275662E537472696E6756616C75651A162E676F6F676C652E70726F746F6275662E456D70747912" +
            "4F0A1774657374526573706F6E7365496E736964654D61746368121C2E676F6F676C652E70726F746F6275662E537" +
            "472696E6756616C75651A162E6772706373657276696365732E526573706F6E7365620670726F746F33";

    @Test()
    public void testGetDescriptorNullDescriptorString() {
        ServiceDefinition definition = new ServiceDefinition(null, null);
        try {
            definition.getDescriptor();
            fail();
        } catch (Exception e) {
            assertEquals(e.getMessage(), "Error while reading the service proto descriptor. " +
                    "input descriptor string is null.");
        }
    }

    @Test()
    public void testFromCodeValueInt() {
        ServiceDefinition definition = new ServiceDefinition(invalidDescriptor, null);
        try {
            definition.getDescriptor();
            fail();
        } catch (Exception e) {
            assertEquals(e.getMessage(), "Error while generating service descriptor : " +
                    "Protocol message tag had invalid wire type.");
        }
    }
}
