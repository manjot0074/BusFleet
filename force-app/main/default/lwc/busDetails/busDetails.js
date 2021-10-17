import { LightningElement, api } from 'lwc';

import RESALE_FIELD from '@salesforce/schema/Bus__c.Resale_Value__c';

import headingLabel from '@salesforce/label/c.Bus_Details';
import selectRecord from '@salesforce/label/c.Select_Record';

export default class BusDetails extends LightningElement {
    @api recordId;
    resaleField = RESALE_FIELD;

    label={
        headingLabel,
        selectRecord
    }
}