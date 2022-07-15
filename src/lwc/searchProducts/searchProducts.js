/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";
import {fireEvent} from 'c/pubsub';


export default class SearchProducts extends LightningElement {
    @track searchValue;
    @wire(CurrentPageReference) pageRef
    passData(event) {
        if (event.keyCode === 13) {
            this.searchValue = event.target.value;
            fireEvent(this.pageRef,"searchDetails",this.searchValue)
            console.log(this.searchValue);
        }
    }
}