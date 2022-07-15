/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {LightningElement, track, wire,api} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import searchProduct from '@salesforce/apex/LWC_dmlOperation.searchProduct'

export default class DisplayFindedProducts extends LightningElement {
    @track details;
    @wire(CurrentPageReference) pageRef;
    @track productToDisplay;
    errorImage = "https://britenet7-dev-ed--c.documentforce.com/sfc/dist/version/download/?oid=00D7Q000004Qv7A&ids=0687Q00000357uZ&d=%2Fa%2F7Q000000TP5r%2FaE5dsVi0EWBYWF_ZFYE_VCQlp_0s.DYJzUsekfPN92k&asPdf=false"
    onerrorHandler (){
       return  this.errorImage;
    }
    connectedCallback() {
        searchProduct({findBy : ''}).then((result)=>{
            this.productToDisplay = result;
        }).catch((error)=>{
            console.log(error);
        })
        registerListener('searchDetails', this.setUpDetails, this)
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    setUpDetails(searchValue) {
        this.details = searchValue
        searchProduct({findBy : this.details}).then((result)=>{
            this.productToDisplay = result;
        }).catch((error)=>{
            console.log(error);
        })

    }



}
