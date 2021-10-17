import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getBuses from '@salesforce/apex/BusController.getBuses';

export default class FleetManagement extends LightningElement {

    @track buses = [];
    selectedBus;

    connectedCallback(){
        getBuses()
        .then(data => {
            this.buses = data;
        }).catch(error => {
            const toast = new ShowToastEvent({
                title: 'error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(toast);
        });
    }
    selectBus(event){
        this.selectedBus = event.detail.busId;
    }
}