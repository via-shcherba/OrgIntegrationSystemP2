global class ScheduledSynchronization implements Schedulable {
	global void execute(SchedulableContext sc) {
        Database.executeBatch(new ProductChecker(), 2000);
    } 
}