global with sharing class BusMaintenanceJob implements Database.Batchable<sobject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        List<Garage__c> garages = [select id from Garage__c];
        return Database.getQueryLocator([select id from Bus__c where Miles_Since_Last_Maintenance__c > 5000 and Maximum_Capacity__c = '60' WITH SECURITY_ENFORCED]);
    }

    global void execute(Database.BatchableContext BC, List<Bus__c> scope){
       List<Bus_Maintenance__c> maintenanceList = new List<Bus_Maintenance__c>();
       for(Bus__c bus: scope){

       }
    } 

    global void finish(Database.BatchableContext BC){
    }
}
