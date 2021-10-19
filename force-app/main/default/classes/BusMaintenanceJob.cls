global with sharing class BusMaintenanceJob implements Schedulable,Database.Batchable<sobject>,Database.Stateful {
    List<Garage__c> garages;
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new BusMaintenanceJob());
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        this.garages = [select id,Location__c from Garage__c WITH SECURITY_ENFORCED];
        return Database.getQueryLocator([select id,Location__c,Odometer_Reading__c from Bus__c where Miles_Since_Last_Maintenance__c > 5000 and Maximum_Capacity__c = '60' and Current_Status__c = 'Ready For Use' WITH SECURITY_ENFORCED]);
    }

    global void execute(Database.BatchableContext BC, List<Bus__c> scope){
        List<Bus_Maintenance__c> maintenanceList = new List<Bus_Maintenance__c>();
        Map<Id,Bus__c> busGarageMap = new Map<Id,Bus__c>();
        for(Bus__c bus: scope){
            Double minimumDistance;
            Id minimumDistanceGarage;
            for(Garage__c garage: this.garages){
                if(bus.Location__c == null){
                    continue;
                }
                Double distance = bus.Location__c.getDistance(garage.Location__c,'mi');
                if(minimumDistance == null || distance < minimumDistance){
                    minimumDistance = distance;
                    minimumDistanceGarage = garage.Id;
                }
            }
            busGarageMap.put(minimumDistanceGarage, bus);
            bus.Current_Status__c = 'Maintenance';
            bus.Last_Maintenance_Odometer_Reading__c = bus.Odometer_Reading__c;
        }
        for(Id garageId : busGarageMap.keySet()){
            maintenanceList.add(
                new Bus_Maintenance__c(
                    Bus__c = busGarageMap.get(garageId).Id,
                    Recorded_odometer__c = busGarageMap.get(garageId).Odometer_Reading__c,
                    Garage__c = garageId,
                    Schedule_reason__c = 'Scheduled Maintenance'
                )
            );
        }
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, maintenanceList);
        insert securityDecision.getRecords();
        SObjectAccessDecision securityDecisionBus = Security.stripInaccessible(AccessType.UPDATABLE, scope);
        update securityDecisionBus.getRecords();
    } 

    global void finish(Database.BatchableContext BC){
    }
}