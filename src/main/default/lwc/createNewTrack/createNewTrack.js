/**
 * Created by dominikbarchanski on 15/06/2022.
 */

import {LightningElement} from 'lwc';
import duration_ms__c from '@salesforce/schema/Track__c.duration_ms__c';
import images__c from '@salesforce/schema/Track__c.images__c';
import artists__c from '@salesforce/schema/Track__c.artists__c';
import name__c from '@salesforce/schema/Track__c.name__c';
import release_date__c from '@salesforce/schema/Track__c.release_date__c';
import Artist__c from '@salesforce/schema/Track__c.Artist__c'

import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class CreateNewTrack extends LightningElement {
    objectApiName = 'Track__c';
    fields = [name__c, images__c,
        duration_ms__c, artists__c,release_date__c,Artist__c
    ];


    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Account created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
    hideModalDetails() {
        console.log(this.modalDetails);
        this.modalDetails = false;
        const closeEvent = new CustomEvent("closemodaltrack", {
            detail: this.modalDetails
        })
        console.log(this.modalDetails);
        this.dispatchEvent(closeEvent)
    }
}