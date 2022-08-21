/**
 * Created by dominikbarchanski on 19/07/2022.
 */

import {LightningElement, wire, track, api} from 'lwc';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {fireEvent} from 'c/pubsub';
import getBrands from '@salesforce/apex/Aura_dmlOperations.getBrands'

export default class FilterComponent extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @track brandOption = [];
    @track optionListYear = [];
    @track optionListPrice = [];
    @track isDisplay = true
    @track hpMin = ''
    @track hpMax = ''
    @api filterType;
    @track  value = '';
    @track  brandValue = '';
    @track startYearValue = '';
    @track  endYearValue = '';
    @track minPrice = '';
    @track maxPrice = '';
    @track country = '';
    @track city = '';
    @track street = '';
    @track searchDistance = '';
    @track hpMinVal = 0;
    @track priceMinVal = 0;
    @track hpMaxVal = 1000;
    @track priceMaxVal = 2500000;
    @track lat;
    @track lng;
    @track TextResponse
    get optionBra() {
        if (this.brandOption) {
            return [...this.brandOption];
        }
    }

    get options() {
        return [{label: 'Chose Type', value: ''}, {label: 'SUV', value: 'SUV'}, {
            label: 'Hatchback', value: 'Hatchback'
        }, {label: 'Crossover', value: 'Crossover'}, {label: 'Sports Car', value: 'Sports Car'}, {
            label: 'Coupe', value: 'Coupe'
        }, {label: 'Pickup Truck', value: 'Pickup Truck'},];
    }

    get optionProdYearStart() {
        if (this.endYearValue === '') {
            return [...this.optionListYear];
        } else {
            return [...this.handleStartYear(this.endYearValue)]
        }
    }

    get optionProdYearEnd() {
        if (this.startYearValue === '') {
            return [...this.optionListYear];
        } else {
            return [...this.handleEndYear(this.startYearValue)]
        }
    }

    get optionPriceMin() {
        if (this.maxPrice === '') {
            return [...this.optionListPrice];
        } else {
            return [...this.handlePriceMin(this.maxPrice)]
        }
    }

    get optionPriceMax() {
        if (this.minPrice === '') {
            return [...this.optionListPrice];
        } else {
            return [...this.handlePriceMax(this.minPrice)]
        }
    }

    get optionKm() {
        let pushOpt = [];
        pushOpt.push({label: 'Select Radius', value: ''})
        for (let i = 0; i < 10; i++) {

            pushOpt.push({label: (((i + 1) * 5).toString()) + ' Km', value: ((i + 1) * 5).toString()})

        }
        return pushOpt

    }


    connectedCallback() {

        getBrands().then(result => {
            this.brandOption.push({

                label: "Chose Brand", value: ""
            })
            for (var i = 0; i < result.length; i++) {
                this.brandOption.push({label: result[i], value: result[i]});
            }
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
        if(this.filterType){
            this.value=this.filterType

            // let passObject = {
            //     type: this.filterType,
            // }
            // sessionStorage.setItem('searchValue', this.searchValue);
            // fireEvent(this.pageRef, "filterDetails", passObject)
        }
    }

    handleStartYear(end) {
        let listOfYears = [];
        listOfYears.push({label: 'Select Year', value: ''})
        for (let i = end; i > 1900; i--) {

            listOfYears.push({label: i.toString(), value: i.toString()});
        }
        return listOfYears;
    }

    handleEndYear(start) {

        let listOfYears = [];
        listOfYears.push({label: 'Select Year', value: ''})
        for (let i = new Date().getFullYear(); i >= start; i--) {

            listOfYears.push({label: i.toString(), value: i.toString()});
        }
        return listOfYears;
    }

    handlePriceMin(max) {
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

    handlePriceMax(min) {
        let value = parseInt(min);
        let priceList = []

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

        this.startYearValue = event.detail.value.toString();
    }

    handleChangeEndYear(event) {

        this.endYearValue = event.detail.value.toString();
    }

    handleChangeMinPrice(event) {
        this.minPrice = event.detail.value;
    }

    handleChangeMaxPrice(event) {
        this.maxPrice = event.detail.value;
    }

    handleChangeCountry(event) {
        this.country = event.detail.value;
    }

    handleChangeCity(event) {
        this.city = event.detail.value;
    }

    handleChangeStreet(event) {
        this.street = event.detail.value;
    }

    handleChangeRadius(event) {
        this.searchDistance = event.detail.value;
    }

    async HandleFilter(event) {
        let hpMax = sessionStorage.getItem('hp-max');
        let hpMin = sessionStorage.getItem('hp-min');
        // let priceMax = sessionStorage.getItem('price-max');
        // let priceMin = sessionStorage.getItem('price-min');
        let position = {};
        let positionOF ={} ;
        let pos ;
        if (this.city !=='' || this.country !== '' || this.street !=='') {
            position = this.positionLatitude()
            positionOF = await position;
            pos = positionOF
        }
            // bool = true
        let toSend = positionOF.hasOwnProperty('lat') ? pos:'';

        // }



        let passObject = {
            type: this.value,
            brand: this.brandValue,
            startYear: this.startYearValue,
            endYear: this.endYearValue,
            hpMin: hpMin,
            hpMax: hpMax == this.hpMaxVal ? '' : hpMax,
            priceMin: this.minPrice,
            priceMax: (parseInt(this.maxPrice) === this.priceMaxVal) ? '' : this.maxPrice,
            distance: this.searchDistance,
            position: toSend
        }
        sessionStorage.setItem('searchValue', this.searchValue);
        fireEvent(this.pageRef, "filterDetails", passObject)
    }

    async positionLatitude() {
        let address = this.country + '+' + this.city + '+' + this.street
        let api_key = 'AIzaSyC6TeiRM56HgxvqR7ncLeZST7Sid6Pky2s';
        let addres = ("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + '&key=' + api_key).replace(' ', '+')
        const response = await fetch(addres);
        const json = await response.json();
        this.TextResponse = JSON.stringify(json);
        const latitude = json.results[0].geometry.location.lat;
        const longitude = json.results[0].geometry.location.lng;
        let position = {
            lat: latitude,
            lan: longitude
        }

        return position
    }

    HandleClearFilter(event) {
        this.brandValue = '';
        this.value = '';
        this.startYearValue = '';
        this.endYearValue = '';
        this.minPrice = '';
        this.maxPrice = '';
        this.country = '';
        this.city = '';
        this.street = '';
        this.searchDistance = '';


        this.isDisplay = false;
        setTimeout(() => {
            this.isDisplay = true
        }, 0)
        sessionStorage.clear();
        fireEvent(this.pageRef, "filterDetails", 'toClear')
    }
}