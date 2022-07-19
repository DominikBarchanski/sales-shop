/**
 * Created by dominikbarchanski on 19/07/2022.
 */

import {LightningElement, wire, track} from 'lwc';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {fireEvent} from 'c/pubsub';
import getBrands from '@salesforce/apex/Aura_dmlOperations.getBrands'

export default class FilterComponent extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @track brandOption = [];
    value;
    brandValue;

    get optionBra() {
        if (this.brandOption) {
            return [...this.brandOption];
        }
    }

    get options() {
        return [
            {label: 'SUV', value: 'new'},
            {label: 'Hatchback', value: 'Hatchback'},
            {label: 'Crossover', value: 'Crossover'},
            {label: 'Sports Car', value: 'Sports Car'},
            {label: 'Coupe', value: 'Coupe'},
            {label: 'Pickup Truck', value: 'Pickup Truck'},
        ];
    }

    connectedCallback() {
        getBrands().then(result => {
            this.brandOption.push({

                label: "Chose Brand",
                value: ""
            })
            console.log(result)
            for (var i = 0; i < result.length; i++) {
                console.log(result[i])
                this.brandOption.push({label: result[i], value: result[i]});
            }
            console.log(this.brandOption)
        }).catch(e => {
            console.log(e)
        })
    }

    handleChangeType(event) {
        this.value = event.detail.value;


    }
    handleChangeBrand(event) {
        this.brandValue = event.detail.value;


    }

    HandleFilter(event) {
        let passObject = {
            type:this.value,
            brand:this.brandValue
        }
        console.log(passObject);
        sessionStorage.setItem('searchValue', this.searchValue);
        fireEvent(this.pageRef, "filterDetails", passObject)
    }
    HandleClearFilter(event){
        this.brandValue = '';
        this.value = '';
        fireEvent(this.pageRef, "filterDetails", 'toClear')
    }
}