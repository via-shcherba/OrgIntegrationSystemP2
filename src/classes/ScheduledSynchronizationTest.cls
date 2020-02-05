@isTest
private class ScheduledSynchronizationTest {
    @testSetup
    private static void setup() {
        Org1Data__c data = new Org1Data__c();
        data.password__c = '29051983s';
        data.clientId__c = '3MVG9G9pzCUSkzZs0u0lD3RheLVZVYiaxkMdrW0FBCBGm.Ov4VT1ugA4141bPdmL3MsKfpMdUe5x3Wi7JOeBR';
        data.authUrl__c = 'https://login.salesforce.com/services/oauth2/token';
        data.clientSecret__c = '7F7E38D814D0C88144448936A40BAF4162DC61F6E4CC2B68EFF2DABC89895332';
        data.operateUrl__c = 'https://ap15.salesforce.com/services/apexrest/IntegrationWebService/';
        data.securityToken__c = 'uh4RtYACTWNgFUr2d7AMAujv';
        data.userName__c = 'sync@user.com';
        insert data;  
        Product2 newProd = new Product2(name='test1');       
        insert newProd; 
        Product2 newProd2 = new Product2(name='test2');       
        insert newProd2; 
    }
    
	@isTest
    private static void scheduleInsertTest() {        
        delete [SELECT Id FROM Product2 WHERE Name = 'test2'];
        Product2 existProduct = [SELECT Id, Name FROM Product2 WHERE Name = 'test1'];
        existProduct.Name = 'test2';
        update existProduct;                
        Test.startTest();           
		ScheduledSynchronization ss = new ScheduledSynchronization();        
		String sch = '0 0 17 * * ?';
		System.schedule('Test', sch, ss);		
		Test.stopTest();
        Product2 actual = [SELECT Id, Name FROM Product2 WHERE Name = 'test2'];
        System.assertEquals('test2', actual.Name);
    }
    
}