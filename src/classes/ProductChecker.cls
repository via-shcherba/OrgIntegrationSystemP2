global class ProductChecker implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
	    
    private List<Product2> productsForSend = new List<Product2>();  
            
    global Database.QueryLocator start(Database.BatchableContext BC) {         
        String dateSearch = (Test.isRunningTest()) ? 'TODAY' : 'YESTERDAY';
        System.debug(dateSearch);
        return Database.getQueryLocator(
            ' SELECT Id, Name, Description, ExtId__c, Family, ProductCode, ' + 
            ' StockKeepingUnit, isDeleted, LastModifiedDate, CreatedDate, DisplayUrl FROM Product2 ' +
            ' WHERE LastModifiedDate = ' + dateSearch + ' LIMIT 50000000 ALL ROWS '
        );
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {                      
        for (Product2 product : (List<Product2>)scope) {                     	
            if (product.ExtId__c != null) {
            	product.Id = product.ExtId__c;
            }       
            productsForSend.add(product);                                                                                     
        }         
    }
    
    global void finish(Database.BatchableContext BC) {           
    	if(!productsForSend.isEmpty()) {
        	String json = JSON.serialize(productsForSend);
        	WebServiceConnection.sendData(json);           
        }        			               
    }
    
}