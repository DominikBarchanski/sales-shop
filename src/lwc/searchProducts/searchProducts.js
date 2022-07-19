/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";
import {fireEvent} from 'c/pubsub';
import { NavigationMixin } from 'lightning/navigation';

export default class SearchProducts extends NavigationMixin(LightningElement) {
    @track searchValue;
    @wire(CurrentPageReference) pageRef
    passData(event) {
        if (event.keyCode === 13) {
            this.searchValue = event.target.value;
            sessionStorage.setItem('searchValue',this.searchValue);
            fireEvent(this.pageRef,"searchDetails",this.searchValue)
            console.log(this.searchValue);
            this[NavigationMixin.Navigate]({
                type:'comm__namedPage',
                attributes:{
                    name:'searchProducts__c'
                }
            })
        }
    }
}