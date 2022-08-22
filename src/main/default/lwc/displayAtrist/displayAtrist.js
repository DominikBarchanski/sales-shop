/**
 * Created by dominikbarchanski on 08/06/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import Id from '@salesforce/user/Id';
import getFavBan from  '@salesforce/apex/LWC_apiCalls.getFavBlacklist';

import {refreshApex} from "@salesforce/apex";
export default class DisplayAtrist extends LightningElement {
    @api artistData
    @api modalDetails
    @api showModal = false;
    @track showLoading = false;
    favBanList;

    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        registerListener('sendModalClose', this.setCapturedText, this);

        getFavBan({userId:Id}).then(result=>{
        this.favBanList = result
        }).catch(error=>{
            console.log(error);
        })
    }
    disconnectedCallback(){
        unregisterAllListeners(this);
    }
    setCapturedText(objPayload){
        this.showLoading = true;
        setTimeout(()=>{
            this.showLoading = false;
            this.showModal = objPayload;
        },500)
    }
    showModalDetails(event) {
        const itemIndex = event.currentTarget.dataset.index;
        this.modalDetails = this.artistData[itemIndex];
        console.log(this.modalDetails);
        this.showModal = true;
    }

    hideModalDetails(event) {
        this.showModal = event.detail;
    }
    item;
    refreshBlocked(event){

        const closeEvent = new CustomEvent("refreshblockedlist", {
            detail : event.detail
        })
        this.dispatchEvent(closeEvent)
    }

}