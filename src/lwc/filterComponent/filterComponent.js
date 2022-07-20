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
    @track isDisplay = true
    value = '';
    brandValue = '';
    @track hpMinVal = 0;
    @track priceMinVal = 0;
    @track hpMaxVal = 1000;
    @track priceMaxVal = 1000000;

    get optionBra() {
        if (this.brandOption) {
            return [...this.brandOption];
        }
    }

    get options() {
        return [
            {label: 'Chose Type', value: ''},
            {label: 'SUV', value: 'new'},
            {label: 'Hatchback', value: 'Hatchback'},
            {label: 'Crossover', value: 'Crossover'},
            {label: 'Sports Car', value: 'Sports Car'},
            {label: 'Coupe', value: 'Coupe'},
            {label: 'Pickup Truck', value: 'Pickup Truck'},
        ];
    }
    get optionProdYear(){
        let optionList = [];
        optionList.push({label:'Select Year' ,value:''})
        for (let i = new Date().getFullYear(); i > 1900 ; i--) {
            optionList.push({label:i,value:i});
        }
        return optionList;
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
        let hpMax = sessionStorage.getItem('hp-max');
        let hpMin = sessionStorage.getItem('hp-min');
        let priceMax = sessionStorage.getItem('price-max');
        let priceMin = sessionStorage.getItem('price-min');
        console.log(hpMin + ' ' + hpMax);
        console.log(priceMin + ' ' + priceMax);
        let passObject = {
            type: this.value,
            brand: this.brandValue,
            hpMin: hpMin,
            hpMax: hpMax == this.hpMaxVal ? '' : hpMax,
            priceMin: priceMin,
            priceMax: priceMax == this.priceMaxVal ? '' : priceMax,
        }
        console.log(passObject);
        sessionStorage.setItem('searchValue', this.searchValue);
        fireEvent(this.pageRef, "filterDetails", passObject)
    }

    HandleClearFilter(event) {
        this.brandValue = '';
        this.value = '';
        this.isDisplay = false;
        setTimeout(()=>{this.isDisplay = true},0)
        sessionStorage.clear();
        fireEvent(this.pageRef, "filterDetails", 'toClear')
    }
}