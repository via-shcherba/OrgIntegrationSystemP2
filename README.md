# OrgIntegrationSystemP2

1. Created a new org https://login.salesforce.com/?un=orgintegration@part2.com&pw=29051983Slash
2. Created apex classes:
	- IntegrationWebService
	- ProductChecker
	- ScheduledSynchronization
	- WebServiceConnection
5. Created unit tests:
	- IntegrationWebServiceTest
	- ScheduledSynchronizationTest

## For start batch use this code in anonimys window:

	Database.executeBatch(new ProductChecker(), 2000);
