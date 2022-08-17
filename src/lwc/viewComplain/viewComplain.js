/**
 * Created by dominikbarchanski on 09/08/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import {getRecord} from "lightning/uiRecordApi";
import Id from "@salesforce/user/Id";
import UserNameFld from '@salesforce/schema/User.Name';
import userEmailFld from '@salesforce/schema/User.Email';
import userIsActiveFld from '@salesforce/schema/User.IsActive';

export default class ViewComplain extends LightningElement {
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
        // console.log(this.makeComplain.createdDateCase)
        // let itemDate = new Date(this.makeComplain.createdDateCase);
        // this.makeComplain.createdDateCase = (itemDate.toLocaleTimeString() + " " + itemDate.toLocaleDateString());
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
        this.complainDisplay = false
    }
}