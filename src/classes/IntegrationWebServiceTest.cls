@isTest
private class IntegrationWebServiceTest {
    @testSetup
    private static void dataFactory() {
        List<Product2> products = new List<Product2>();
        Product2 pr1 = new Product2(Name='test1');
        products.add(pr1);
        Product2 pr2 = new Product2(Name='test2');
        products.add(pr2);
        Product2 pr3 = new Product2(Name='test3');
        products.add(pr3);
        insert products;
        System.debug(products);
    }
    
	@isTest
    private static void insertTest() {
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');        
        String json = '{"insert":[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/01t2v00000CiCWXAA3"},"Id":"01t2v00000CiCWXAA3","Name":"Product20"}]}';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        test.startTest();
        IntegrationWebService.getExternalData();
        test.stopTest();
		Product2 actual = [SELECT id, Name FROM Product2 WHERE Name = 'Product20' LIMIT 1];
		System.assertEquals('Product20', actual.Name);
    }
    
    @isTest
    private static void updateTest() {
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');  
        Product2 pr = [SELECT Id, Name FROM Product2 LIMIT 1];
        String json = '{"update":[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/'+pr.Id+'"},"Id":"'+pr.Id+'","Name":"Product20"}]}';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        test.startTest();
        IntegrationWebService.getExternalData();
        test.stopTest();
		Product2 actual = [SELECT id, Name FROM Product2 WHERE Name = 'Product20' LIMIT 1];
		System.assertEquals('Product20', actual.Name);
    }
    
    @isTest
    private static void deleteTest() {
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');  
        Product2 pr = [SELECT Id, Name FROM Product2 WHERE Name='test1'];
        String json = '{"delete":[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/'+pr.Id+'"},"Id":"'+pr.Id+'","Name":"'+pr.Name+'"}]}';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        test.startTest();
        IntegrationWebService.getExternalData();
        test.stopTest();
		Integer actual = [SELECT COUNT() FROM Product2 WHERE Name = 'Product20'];
		System.assertEquals(0, actual);
    }
    
    @isTest
    private static void undeleteTest() {
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');  
        Product2 pr = [SELECT Id, Name FROM Product2 WHERE Name='test1'];
        delete pr;
        String json = '{"undelete":[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/'+pr.Id+'"},"Id":"'+pr.Id+'","Name":"'+pr.Name+'"}]}';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        test.startTest();
        IntegrationWebService.getExternalData();
        test.stopTest();
		Integer actual = [SELECT COUNT() FROM Product2 WHERE Name = 'test1'];
		System.assertEquals(1, actual);
    }
}