import { LightningElement,api } from 'lwc';

export default class BusDisplay extends LightningElement {
    @api busData;
    @api selectedBusId;

    get imageSrc(){
        return this.busData && this.busData.contentUrls ? '/sfc/servlet.shepherd/version/download/' + this.busData.contentUrls[0] : '';
    }

    get tileBorderClass(){
        return this.selectedBusId === this.busData.busRecord.Id ? 'selectedTileClass' : 'tileClass';
    }
    
    selectBus(){
        //this.selectedBusId = this.busData.busRecord.Id;
        const busSelect = new CustomEvent('busselect', {
            detail: {
                busId: this.busData.busRecord.Id
            }
        });
        this.dispatchEvent(busSelect);
    }
}