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
    @track optionListYear = [];
    @track optionListPrice = [];
    @track isDisplay = true
    @track  value = '';
    @track  brandValue = '';
    @track startYearValue = '';
    @track  endYearValue = '';
    @track minPrice = '';
    @track maxPrice = '';
    @track hpMinVal = 0;
    @track priceMinVal = 0;
    @track hpMaxVal = 1000;
    @track priceMaxVal = 2500000;

    get optionBra() {
        if (this.brandOption) {
            return [...this.brandOption];
        }
    }

    get options() {
        return [{label: 'Chose Type', value: ''}, {label: 'SUV', value: 'new'}, {
            label: 'Hatchback', value: 'Hatchback'
        }, {label: 'Crossover', value: 'Crossover'}, {label: 'Sports Car', value: 'Sports Car'}, {
            label: 'Coupe', value: 'Coupe'
        }, {label: 'Pickup Truck', value: 'Pickup Truck'},];
    }

    get optionProdYearStart() {
        if (this.endYearValue === '') {
            return [...this.optionListYear];
        }else {
            return [...this.handleStartYear(this.endYearValue)]
        }
    }

    get optionProdYearEnd() {
        if (this.startYearValue === '') {
            return [...this.optionListYear];
        }else{
            return [...this.handleEndYear(this.startYearValue)]
        }
    }

    get optionPriceMin() {
        if (this.maxPrice ===''){
        return [...this.optionListPrice];
        }else {
            return [...this.handlePriceMin(this.maxPrice)]
        }
    }
    get optionPriceMax() {
        if (this.minPrice ===''){
            return [...this.optionListPrice];
        }else {
            return [...this.handlePriceMax(this.minPrice)]
        }
    }



    connectedCallback() {
        getBrands().then(result => {
            this.brandOption.push({

                label: "Chose Brand", value: ""
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

        this.optionListYear.push({label: 'Select Year', value: ''})
        for (let i = new Date().getFullYear(); i > 1900; i--) {
            this.optionListYear.push({label: i.toString(), value: i.toString()});
        }

        let value = 2500;
        this.optionListPrice.push({label: 'Select Price', value: ''})
        for (let i = 2; value < 7500000; i++) {
            this.optionListPrice.push({label: value.toString() + "€", value: value.toString()});
            if (i <= 10) {
                value += value
            } else {
                value *= i
            }
        }
        this.optionListPrice.push({label: '2500000€ And More', value: '2500000'})

    }
    handleStartYear(end){
        console.log(end);
        let listOfYears=[];
        listOfYears.push({label: 'Select Year', value: ''})
        for (let i =end ; i > 1900; i--) {
            console.log(i)
            listOfYears.push({label: i.toString(), value: i.toString()});
        }
        console.log(listOfYears)
        return listOfYears;
    }
    handleEndYear(start){
        console.log(start);
        let listOfYears=[];
        listOfYears.push({label: 'Select Year', value: ''})
        for (let i =new Date().getFullYear() ; i >= start; i--) {
            console.log(i)
            listOfYears.push({label: i.toString(), value: i.toString()});
        }
        console.log(listOfYears)
        return listOfYears;
    }
    handlePriceMin(max){
        let priceList = []
        let value = 2500;
        priceList.push({label: 'Select Price', value: ''})
        for (let i = 2; value < max; i++) {
            priceList.push({label: value.toString() + "€", value: value.toString()});
                value += value

        }
        return priceList;
        // this.optionListPrice.push({label: '2500000€ And More', value: '2500000'})
    }
    handlePriceMax(min){
        let value = parseInt(min);
        let priceList = []
        console.log(min)
        priceList.push({label: 'Select Price', value: ''})
        for (let i = 2; value < 7500000; i++) {

            priceList.push({label: value.toString() + "€", value: value.toString()});
            value += value
        }
        priceList.push({label: '2500000€ And More', value: '2500000'})
        return priceList
    }
    handleChangeType(event) {
        this.value = event.detail.value.toString();
    }

    handleChangeBrand(event) {
        this.brandValue = event.detail.value.toString();
    }

    handleChangeStartYear(event) {
        console.log(event.detail.value)
        this.startYearValue = event.detail.value.toString();
    }

    handleChangeEndYear(event) {
        console.log(event.detail.value)
        this.endYearValue = event.detail.value.toString();
    }

    handleChangeMinPrice(event) {
        console.log(event.detail.value)
        this.minPrice = event.detail.value;
    }

    handleChangeMaxPrice(event) {
        console.log(event.detail.value)
        this.maxPrice = event.detail.value;
        console.log(this.maxPrice)
    }

    HandleFilter(event) {
        let hpMax = sessionStorage.getItem('hp-max');
        let hpMin = sessionStorage.getItem('hp-min');
        let priceMax = sessionStorage.getItem('price-max');
        let priceMin = sessionStorage.getItem('price-min');
        console.log(hpMin + ' ' + hpMax);
        console.log(priceMin + ' ' + priceMax);
        console.log(this.minPrice + ' ' + this.maxPrice);
        let passObject = {
            type: this.value,
            brand: this.brandValue,
            startYear: this.startYearValue,
            endYear: this.endYearValue,
            hpMin: hpMin,
            hpMax: hpMax == this.hpMaxVal ? '' : hpMax,
            priceMin: this.minPrice,
            priceMax: (parseInt(this.maxPrice) === this.priceMaxVal) ? '' : this.maxPrice,
        }
        console.log(passObject);
        sessionStorage.setItem('searchValue', this.searchValue);
        fireEvent(this.pageRef, "filterDetails", passObject)
    }

    HandleClearFilter(event) {
        this.brandValue = '';
        this.value = '';
        this.startYearValue = '';
        this.endYearValue = '';
        this.minPrice = '';
        this.maxPrice = '';
        this.isDisplay = false;
        setTimeout(() => {
            this.isDisplay = true
        }, 0)
        sessionStorage.clear();
        fireEvent(this.pageRef, "filterDetails", 'toClear')
    }
}