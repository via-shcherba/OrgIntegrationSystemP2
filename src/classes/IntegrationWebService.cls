@RestResource(urlMapping='/IntegrationWebService/*')
global class IntegrationWebService {
	@HttpPost
    global static void getExternalData() {

            RestRequest request = RestContext.request;
            Blob body = request.requestBody;        
            Map<String, List<Product2>> newRecords = 
                (Map<String, List<Product2>>)JSON.deserialize(body.toString(), Map<String, List<Product2>>.class);        
            String key = new List<String>(newRecords.keySet())[0];
            switch on key {
                when 'insert' {	 
                    Map<Id, Product2> products = new Map<Id, Product2>(newRecords.values()[0]);  
                	Map<Id, Product2> existProducts = new Map<Id, Product2>(
                        [SELECT Id, Name, ExtId__c FROM Product2 WHERE ExtId__c IN :products.keySet()]
                    );                    
                    List<Product2> newRecordsForInsert = new List<Product2>();  
                    List<Product2> updateExistProducts = new List<Product2>(); 
                    for (Product2 product : products.values()) {
                        if (!existProducts.containsKey(product.Id)) {
                    		Product2 newProduct = new Product2();
                        	newProduct.ExtId__c = product.Id;  
                        	newProduct.Description = product.Description;
                        	newProduct.DisplayUrl = product.DisplayUrl;
                        	newProduct.Family = product.Family;
                        	newProduct.Name = product.Name;
                        	newProduct.ProductCode = product.ProductCode;
                        	newProduct.StockKeepingUnit = product.StockKeepingUnit;
                        	newRecordsForInsert.add(newProduct);
                        } else {
                            Product2 existProduct = existProducts.get(product.Id);
                            existProduct.ExtId__c = existProduct.Id;
                            updateExistProducts.add(existProduct);
                        }
                    }
                    if (!newRecordsForInsert.isEmpty()) {
                        insert newRecordsForInsert;
                    }
                    if (!updateExistProducts.isEmpty()) {
                        update updateExistProducts;
                    }  					
                }	
                when 'update' {	                     
                    Map<Id, Product2> newRecordsMap = new Map<Id, Product2>(
                        newRecords.values()[0]
                    );                          
                    List<Product2> products = new List<Product2>(
                   		[
                            SELECT Id, ExtId__c, Description, DisplayUrl, 
                            Family, Name, ProductCode, StockKeepingUnit
                            FROM Product2
                            WHERE ExtId__c IN :newRecordsMap.keySet()
                            OR Id IN :newRecordsMap.keySet()
                            LIMIT 10000
                        ]
                    );
                    
                    if (!products.isEmpty()) {
                        for (Product2 product : products) {                                                        
                            if (newRecordsMap.containsKey(product.Id)) {
                                Product2 newRecord = newRecordsMap.get(product.Id);
                                product.Description = newRecord.Description;
                                product.DisplayUrl = newRecord.DisplayUrl;
                                product.Family = newRecord.Family;
                                product.Name = newRecord.Name;
                                product.ProductCode = newRecord.ProductCode;
                                product.StockKeepingUnit = newRecord.StockKeepingUnit;
                            }
                            
                            if (newRecordsMap.containsKey(product.ExtId__c)) {
                                Product2 newRecord = newRecordsMap.get(product.ExtId__c);
                                product.Description = newRecord.Description;
                                product.DisplayUrl = newRecord.DisplayUrl;
                                product.Family = newRecord.Family;
                                product.Name = newRecord.Name;
                                product.ProductCode = newRecord.ProductCode;
                                product.StockKeepingUnit = newRecord.StockKeepingUnit;
                            }
                        }                        
                        update products;
                    } 
                    
                }
                when 'delete' {		
                    Map<Id, Product2> newRecordsMap = new Map<Id, Product2>(
                        newRecords.values()[0]
                    );
                    List<Product2> products = new List<Product2>(
                   		[
                            SELECT Id
                            FROM Product2
                            WHERE ExtId__c IN :newRecordsMap.keySet()
                            OR Id IN :newRecordsMap.keySet()
                            LIMIT 10000
                        ]
                    );
                    if (!products.isEmpty()) {
                        delete products;
                    }
                }
                when 'undelete' {		
                    Map<Id, Product2> newRecordsMap = new Map<Id, Product2>(
                        newRecords.values()[0]
                    );
                    List<Product2> products = new List<Product2>(
                   		[
                            SELECT Id
                            FROM Product2
                            WHERE ExtId__c IN :newRecordsMap.keySet()
                            OR Id IN :newRecordsMap.keySet()
                            LIMIT 10000
                            All Rows
                        ]
                    );
                    if (!products.isEmpty()) {
                        undelete products;
                    }
                }               
            }
    }
    
}