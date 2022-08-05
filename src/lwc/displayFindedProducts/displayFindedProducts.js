/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import searchProduct from '@salesforce/apex/LWC_dmlOperation.searchProduct'

export default class DisplayFindedProducts extends NavigationMixin(LightningElement) {
    @track details;
    @wire(CurrentPageReference) pageRef;
    @track productToDisplay;
    tempProduct;
    @track recordId;
    @track recordName;
    @track isFilter = true;
    hideClass = "slds-size_1-of-4"
    itemDisplay = "slds-size_3-of-4"
    errorImage = "https://britenet7-dev-ed--c.documentforce.com/sfc/dist/version/download/?oid=00D7Q000004Qv7A&ids=0687Q00000357uZ&d=%2Fa%2F7Q000000TP5r%2FaE5dsVi0EWBYWF_ZFYE_VCQlp_0s.DYJzUsekfPN92k&asPdf=false";
    setDiscount

    onerrorHandler() {
        return this.errorImage;
    }

    connectedCallback() {
        if (sessionStorage.getItem('searchValue')) {
            this.details = sessionStorage.getItem('searchValue')
            sessionStorage.clear();
        } else {
            this.details = '';
        }
        searchProduct({findBy: this.details}).then((result) => {

            let test = JSON.parse(JSON.stringify(result));

            for (const itemElement of test) {

                if (itemElement.price !== itemElement.priceWithDiscount) {
                    itemElement.isDiscount = true;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = 'discountPrice';

                } else {
                    itemElement.isDiscount = false;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = ''


                }

            }
            // for (const testElement of test) {
            //     let address = testElement.country + '+' + testElement.city + '+' + testElement.street
            //     let api_key = 'AIzaSyC6TeiRM56HgxvqR7ncLeZST7Sid6Pky2s';
            //     let addres = ("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + '&key=' + api_key).replace(' ', '+')
            //
            //     fetch(addres)
            //         .then(response => {
            //         let data =response.json();
            //             console.log(data);
            //             if(data.status === 'OK'){
            //
            //             const latitude = data.results[0].geometry.location.lat;
            //             const longitude = data.results[0].geometry.location.lng;
            //              let post = {
            //                 lat:latitude,
            //                 lan:longitude
            //             }
            //                 console.log(post)
            //                 // testElement.pos
            //             }
            //             console.log(testElement);
            //         })
            //
            // }
            console.log(test)
            this.tempProduct = test;
            this.productToDisplay = test;
        }).catch((error) => {
            console.log(error);
        })
        registerListener('searchDetails', this.setUpDetails, this)
        registerListener('filterDetails', this.setUpFilter, this)
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }



    getLatLoanFromAddress(country, city, street) {


    }

    setUpFilter(filterValue) {
        // Object.filter = (obj, predicate) =>
        //     Object.fromEntries(Object.entries(obj).filter(predicate));



        console.log(filterValue);
        if (filterValue === 'toClear') {
            console.log('weszło')
            this.productToDisplay = this.tempProduct;
        } else if (typeof filterValue === "object") {
            for (const item of this.tempProduct) {
                if(filterValue.position.lan !== undefined){

                    console.log('tutaj')
                    console.log(item)

                    const lat2 = parseFloat(item.lat) * Math.PI / 180;
                    const lat1 = filterValue.position.lat * Math.PI / 180;
                    const R = 6371; // km
                    const dLat = (lat2 - lat1) * Math.PI / 180;
                    const dLon = (parseFloat(item.lng) - filterValue.position.lan) * Math.PI / 180

                    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                        Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
                    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                    console.log(R*c);
                    item.distance = R*c
                }else {item.distance=''}
            }
            this.productToDisplay = this.tempProduct.filter(el => {
                return (filterValue.type !== '' ? el.type === filterValue.type : true) &&
                    (filterValue.brand !== '' ? el.brand === filterValue.brand : true) &&
                    (filterValue.hpMin !== '' && filterValue.hpMin !== null ? el.hp >= filterValue.hpMin : true) &&
                    (filterValue.hpMax !== '' && filterValue.hpMax !== null ? el.hp <= filterValue.hpMax : true) &&
                    ((filterValue.priceMin !== '' && filterValue.priceMin !== null ? el.price >= parseInt(filterValue.priceMin) : true) || (filterValue.priceMin !== '' && filterValue.priceMin !== null ? el.priceWithDiscount >= parseInt(filterValue.priceMin) : false)) &&
                    ((filterValue.priceMax !== '' && filterValue.priceMax !== null ? el.price <= parseInt(filterValue.priceMax) : true) || (filterValue.priceMax !== '' && filterValue.priceMax !== null ? el.priceWithDiscount <= parseInt(filterValue.priceMax) : false)) &&
                    (filterValue.startYear !== '' && filterValue.startYear !== null ? el.prodYear >= parseInt(filterValue.startYear) : true) &&
                    (filterValue.endYear !== '' && filterValue.endYear !== null ? el.prodYear <= parseInt(filterValue.endYear) : true)&&
                    (filterValue.distance !== '' && filterValue.distance !== null && filterValue.distance !== NaN  ?  el.distance < parseInt(filterValue.distance):true)

            })
        }

        // console.log(filtered);

    }
    // calcCrow(lat11, lon1, lat21, lon2)
    // {
    //     console.log('tutaj')
    //     const lat2 = lat21 * Math.PI / 180;
    //     const lat1 = lat11 * Math.PI / 180;
    //     const R = 6371; // km
    //     const dLat = (lat2 - lat1) * Math.PI / 180;
    //     const dLon = (lon2 - lon1) * Math.PI / 180;
    //
    //     const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    //         Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
    //     const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    //     console.log(R*c);
    //     return R * c;
    // }

    // Converts numeric degrees to radians

    handleHide() {
        this.hideClass = this.hideClass + ' slds-hide'
        this.itemDisplay = 'slds-size_4-of-4'
        this.isFilter = !this.isFilter
    }

    handleShow() {
        console.log(this.hideClass)
        this.hideClass = this.hideClass.replace('slds-hide', '');
        this.itemDisplay = 'slds-size_3-of-4'
        this.isFilter = !this.isFilter
    }

    setUpDetails(searchValue) {
        this.details = searchValue
        searchProduct({findBy: this.details}).then((result) => {
            let test = JSON.parse(JSON.stringify(result));

            for (const itemElement of test) {

                if (itemElement.price !== itemElement.priceWithDiscount) {
                    itemElement.isDiscount = true;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = 'discountPrice';

                } else {
                    itemElement.isDiscount = false;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = ''


                }

            }
            console.log(test);
            this.productToDisplay = test;

        }).catch((error) => {
            console.log(error);
        })

    }

    handleProductClick(event) {
        this.recordId = event.currentTarget.dataset.id;
        this.recordName = event.currentTarget.dataset.value;
        // let urlString = '/product/' +this.recordName +'/' + this.recordId;
        // eval("var urlEvent = $A.get('e.force:navigateToURL');urlEvent.setParams({'url': '" + urlString + "'});urlEvent.fire();");
        console.log(this.recordName)
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/product/' + this.recordName + '/' + this.recordId
            }
        })

    }

    // handleSwapPhoto(event){
    //     let test = event.currentTarget.dataset.index
    //
    //     console.log(JSON.stringify(this.productToDisplay[test].photoList))
    //
    //
    // }


}
