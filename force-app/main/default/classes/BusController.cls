public with sharing class BusController {
    @AuraEnabled
    public static List<Bus> getNextBuses(String lastBusName, String lastBusId){
        try {
            Map<Id,Bus__c> busRecords = new Map<Id,Bus__c>();
            if(String.isBlank(lastBusName)){
                busRecords = new Map<Id,Bus__c>([select id,Name from Bus__c WITH SECURITY_ENFORCED order by Name,Id limit 20]);
            } else {
                busRecords = new Map<Id,Bus__c>([select id,Name from Bus__c where Name > :lastBusName or (Name = :lastBusName and Id > : lastBusId) WITH SECURITY_ENFORCED order by Name,Id limit 20]);
            }
            if(busRecords.isEmpty()){
                return new List<Bus>();
            }
            Map<Id,List<String>> contentUrlMap = ContentUtility.getParentIdContentUrlMap(busRecords.keySet());
            
            List<Bus> buses = new List<Bus>(); 
            for(Id busId : busRecords.keySet()){
                buses.add(new Bus(
                    busRecords.get(busId),
                    contentUrlMap.get(busId)
                ));
            }
            return buses;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Bus> getPrevBuses(String lastBusName, String lastBusId){
        try {
            Map<Id,Bus__c> busRecords = new Map<Id,Bus__c>();
            if(String.isBlank(lastBusId)){
                throw new CustomException('Bus Id is not available');
            } else {
                busRecords = new Map<Id,Bus__c>([select id,Name from Bus__c where Name < :lastBusName or (Name = :lastBusName and Id < : lastBusId) WITH SECURITY_ENFORCED order by Name desc ,Id desc limit 20]);
            }
            if(busRecords.isEmpty()){
                return new List<Bus>();
            }
            Map<Id,List<String>> contentUrlMap = ContentUtility.getParentIdContentUrlMap(busRecords.keySet());
            
            List<Bus> buses = new List<Bus>(); 
            for(Id busId : busRecords.keySet()){
                buses.add(new Bus(
                    busRecords.get(busId),
                    contentUrlMap.get(busId)
                ));
            }
            return buses;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer getTotalCount(){
        try {
            return [select count() from bus__c WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class Bus{
        @AuraEnabled
        public Bus__c busRecord;
        @AuraEnabled
        public List<String> contentUrls;
        public Bus(Bus__c bus,List<String> contentUrls){
            this.busRecord = bus;
            this.contentUrls = contentUrls;
        }
    }

}