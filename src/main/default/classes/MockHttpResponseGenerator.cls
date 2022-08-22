/**
 * Created by dominikbarchanski on 23/05/2022.
 */

@IsTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    public String mode ;
    public static String ADD_HOP = 'ADD_DOC';
    public static String SER_HOP = 'SER_DOC';
    public static String DEL_HOP = 'DEL_DOC';
    public static String UPD_HOP = 'UPD_DOC';
    public static String COU_HOP = 'COU_HOP';
//
    public MockHttpResponseGenerator(String mockMode) {
        this.mode = mockMode;
    }

    global HttpResponse respond(HttpRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        if(mode == ADD_HOP ){
            System.assertEquals('callout:RestHospital/services/apexrest/HospitalRafal/', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"hospitalId": "XD123","hospitalStreet": null,"hospitalPhone": "123321123","hospitalName": "481713520","hospitalEmail": null,"hospitalCountry": "Poland","hospitalCity": "Warszawa"}');
            res.setStatusCode(200);
            return res;
        }else if (mode == COU_HOP) {
            System.assertEquals('callout:RestHospital/services/apexrest/HospitalRafal/', req.getEndpoint());
            System.assertEquals('PUT', req.getMethod());

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('["Anglia","Polska"]');
            res.setStatusCode(200);
            return res;


        } else if (mode == UPD_HOP) {
            System.assertEquals('callout:RestHospital/services/apexrest/HospitalRafal/', req.getEndpoint());
            System.assertEquals('PATCH', req.getMethod());

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status":"OK"}');
            res.setStatusCode(200);
            return res;
        } else if (mode == DEL_HOP) {
            System.assertEquals('callout:RestHospital/services/apexrest/HospitalRafal/', req.getEndpoint());
            System.assertEquals('DELETE', req.getMethod());

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status":"OK"}');
            res.setStatusCode(200);
            return res;
        }
        else if (mode == SER_HOP) {
            System.assertEquals('callout:RestHospital/services/apexrest/HospitalRafal/?Name=test', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"hospitalStreet": null,"hospitalPhone": "123321123","hospitalName": "481713520","hospitalEmail": null,"hospitalCountry": "Poland","hospitalCity": "Warszawa"}');
            res.setStatusCode(200);
            return res;
        }

        return null;
    }
}