import { LightningElement,api } from 'lwc';

export default class BusDisplay extends LightningElement {
    @api busData;

    get imageSrc(){
        return this.busData && this.busData.contentUrls ? '/sfc/servlet.shepherd/version/download/' + this.busData.contentUrls[0] : '';
    }
}