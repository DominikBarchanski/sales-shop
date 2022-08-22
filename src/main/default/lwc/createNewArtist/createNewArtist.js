/**
 * Created by dominikbarchanski on 15/06/2022.
 */

import {LightningElement} from 'lwc';
import genres__c from '@salesforce/schema/Artist__c.genres__c';
import name__c from '@salesforce/schema/Artist__c.name__c';
import images__c from '@salesforce/schema/Artist__c.images__c';
import type__c from '@salesforce/schema/Artist__c.type__c';
import followers__c from '@salesforce/schema/Artist__c.followers__c';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class CreateNewArtist extends LightningElement {
    objectApiName = 'Artist__c';
    fields = [name__c, images__c,
        followers__c, genres__c
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
        const closeEvent = new CustomEvent("closedetailsmodal", {
            detail: this.modalDetails
        })
        console.log(this.modalDetails);
        this.dispatchEvent(closeEvent)
    }

}