/**
 * Created by dominikbarchanski on 05/08/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import {getRecord} from "lightning/uiRecordApi";
import Id from "@salesforce/user/Id";
import UserNameFld from '@salesforce/schema/User.Name';
import userEmailFld from '@salesforce/schema/User.Email';
import userIsActiveFld from '@salesforce/schema/User.IsActive';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ComplainModal extends LightningElement {
    @api makeComplain
    @track productName
    complainDisplay = false;
    currentUserEmailId;

    @wire(getRecord, {recordId: Id, fields: [UserNameFld, userEmailFld, userIsActiveFld]})
    userDetails({error, data}) {
        if (data) {
            this.currentUserEmailId = data.fields.Email.value;

        } else if (error) {
            this.error = error;
        }
    }
    connectedCallback() {

    }

    handleComplain(){
        let data = JSON.parse(JSON.stringify( this.makeComplain))
        console.log(JSON.parse(JSON.stringify( this.makeComplain)))
        this.productName = data.productName
        this.complainDisplay = true

    }
    handleComplainClose(){
        this.complainDisplay = false
    }
    handleSubmit(event){
        event.preventDefault();
        let data = JSON.parse(JSON.stringify( this.makeComplain))
        const fields = event.detail.fields;

        fields.Order__c = data.Id;
        fields.ProductId =  data.orderItem[0].Product2.Id
        console.log(JSON.stringify( fields))
        this.template.querySelector('lightning-record-edit-form').submit(fields);

    }
    handleSuccess(){
        const evt = new ShowToastEvent({
            title: 'Success',
            message: "Complain Created",
            variant: 'success',
        });
        this.dispatchEvent(evt);
        this.complainDisplay = false
    }

}