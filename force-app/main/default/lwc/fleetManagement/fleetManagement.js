import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getNextBuses from '@salesforce/apex/BusController.getNextBuses';
import getPrevBuses from '@salesforce/apex/BusController.getPrevBuses';
import getTotalCount from '@salesforce/apex/BusController.getTotalCount';

export default class FleetManagement extends LightningElement {

    @track buses = [];
    selectedBus;
    totalCount = 0;
    pageNumber = 1;
    pageSize = 20;
    lastBus;
    isLoading = true;

    connectedCallback(){
        getTotalCount()
        .then(data => {
            this.totalCount = data;
        }).catch(error => {
            const toast = new ShowToastEvent({
                title: 'error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(toast);
        });

        this.getNextBusList();
    }
    selectBus(event){
        this.selectedBus = event.detail.busId;
    }

    get isPreviousDisabled(){
        return this.pageNumber === 1;
    }

    get isNextDisabled(){
        return this.pageNumber === (this.totalCount%this.pageSize == 0 ? this.totalCount/this.pageSize : Math.floor(this.totalCount/this.pageSize) +1) ;
    }

    get totalPages(){
        return (this.totalCount%this.pageSize == 0 ? this.totalCount/this.pageSize : Math.floor(this.totalCount/this.pageSize) +1);
    }

    get recordStart(){
        return ((this.pageNumber - 1) * this.pageSize) + 1;
    }

    get recordEnd(){
        return this.pageNumber * this.pageSize;
    }

    handlePrev(){
        this.isLoading = true;
        this.getPrevBusList(this.buses[0].busRecord.Name,this.buses[0].busRecord.Id);
        this.pageNumber = this.pageNumber - 1;
    }

    handleNext(){
        this.isLoading = true;
        this.getNextBusList(this.lastBus.Name,this.lastBus.Id);
        this.pageNumber = this.pageNumber + 1;
    }

    getNextBusList(busName, busId){
        getNextBuses({
            lastBusName : busName,
            lastBusId : busId
        })
        .then(data => {
            this.isLoading = false;
            this.buses = data;
            if(data && data.length){
                this.lastBus = data[data.length - 1].busRecord;
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

    getPrevBusList(busName, busId){
        getPrevBuses({
            lastBusName : busName,
            lastBusId : busId
        })
        .then(data => {
            this.isLoading = false;
            data = data.reverse();
            this.buses = data;
            if(data && data.length){
                this.lastBus = data[data.length - 1].busRecord;
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