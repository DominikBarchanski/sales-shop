/**
 * Created by dominikbarchanski on 23/05/2022.
 */

@isTest
private class CalloutClassTest {
    @isTest static void testCalloutPost() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(MockHttpResponseGenerator.ADD_HOP));
        Test.startTest();
        HttpResponse res = REST_calloutTest.postTest();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"hospitalId": "XD123","hospitalStreet": null,"hospitalPhone": "123321123","hospitalName": "481713520","hospitalEmail": null,"hospitalCountry": "Poland","hospitalCity": "Warszawa"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();
    }
    @isTest static void testCalloutPut() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(MockHttpResponseGenerator.COU_HOP));
        Test.startTest();
        HttpResponse res = REST_calloutTest.putTest();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '["Anglia","Polska"]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();
    }
    @isTest static void testCalloutPatch() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(MockHttpResponseGenerator.UPD_HOP));
        Test.startTest();
        HttpResponse res = REST_calloutTest.patchTest();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"Status":"OK"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();

    }
    @isTest static void testCalloutGet() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(MockHttpResponseGenerator.SER_HOP));
        Test.startTest();
        HttpResponse res = REST_calloutTest.getTest();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"hospitalStreet": null,"hospitalPhone": "123321123","hospitalName": "481713520","hospitalEmail": null,"hospitalCountry": "Poland","hospitalCity": "Warszawa"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();
    }
    @isTest static void testCalloutDelete() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(MockHttpResponseGenerator.DEL_HOP));
        Test.startTest();
        HttpResponse res = REST_calloutTest.deleteTest();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"Status":"OK"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();
    }
}