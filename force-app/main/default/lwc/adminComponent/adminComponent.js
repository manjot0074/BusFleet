import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import checkForScheduledJob from '@salesforce/apex/AdminController.isScheduledEnabled';
import toggleScheduledJob from '@salesforce/apex/AdminController.toggleScheduledJob';

export default class AdminComponent extends LightningElement {
    
    jobScheduled = false;
    connectedCallback(){
        checkForScheduledJob()
        .then(data => {
            this.jobScheduled = data;
        }).catch(error => {
            const toast = new ShowToastEvent({
                title: 'error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(toast);
        });
    }

    handleChange(event){
        this.jobScheduled = event.target.checked
        toggleScheduledJob({
            createJob : this.jobScheduled
        }).then(data => {
            if(this.jobScheduled){
                const toast = new ShowToastEvent({
                    title: 'Success',
                    variant: 'success',
                    message: 'Job Scheduled Successfully'
                });
                this.dispatchEvent(toast);
            } else {
                const toast = new ShowToastEvent({
                    title: 'Success',
                    variant: 'success',
                    message: 'Job Deleted Successfully'
                });
                this.dispatchEvent(toast);
            }
        }).catch(error => {
            const toast = new ShowToastEvent({
                title: 'error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(toast);
        });

    }
}