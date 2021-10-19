public with sharing class AdminController {
    public static String MAINTENACE_JOB_NAME = 'Bus Maintenance Job';

    @AuraEnabled
    public static Boolean isScheduledEnabled(){
        try {
            return checkForScheduledJob(MAINTENACE_JOB_NAME) != null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void toggleScheduledJob(boolean createJob){
        try {
            CronTrigger existingJob = checkForScheduledJob(MAINTENACE_JOB_NAME);
            if(createJob){
                if(existingJob != null){
                    throw new CustomException('Job Already Present');
                }
                System.schedule(MAINTENACE_JOB_NAME, '0 0 1 1/1 * ?', new BusMaintenanceJob());
            } else {
                if(existingJob == null){
                    throw new CustomException('Job is Not Present');
                }
                System.abortJob(existingJob.id);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static CronTrigger checkForScheduledJob(String jobName){
        List<String> stateNames = new List<String>{'COMPLETE','DELETED'};
        List<CronTrigger> cronJob = [SELECT Id, CronJobDetail.Name from Crontrigger where CronJobDetail.Name = :jobName AND  State !=: stateNames];
        if(cronJob.isEmpty()){
            return null;
        } else {
            return cronJob[0];
        }
    }
}