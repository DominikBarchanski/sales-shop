/**
 * Created by dominikbarchanski on 08/06/2022.
 */

import {api, LightningElement, track,wire} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import Id from "@salesforce/user/Id";
import getFavBan from  '@salesforce/apex/LWC_apiCalls.getFavBlacklist';
import getBlockedItems from  '@salesforce/apex/LWC_apiCalls.getBlockedItems';
export default class DisplayTrack extends LightningElement {
    @api trackData
    @api modalDetails
    @api showModal = false;
    @track showLoading = false;
    favBanList;

    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        registerListener('sendModalClose', this.setCapturedText, this);
        getBlockedItems({id: Id}).then(result=>{
            console.log(result)
        }).catch(error=>{
            console.log(error)
        })
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
            this.showModal = objPayload;
            this.showLoading= false
        },500)
    }

    showModalDetails(event) {
        const itemIndex = event.currentTarget.dataset.index;
        this.modalDetails = this.trackData[itemIndex];
        this.showModal = true;
    }

    hideModalDetails(event) {
        this.showModal = event.detail;
    }
    refreshBlocked(event){
        const closeEvent = new CustomEvent("refreshblockedlist", {
            detail : event.detail
        })
        this.dispatchEvent(closeEvent)
    }

}