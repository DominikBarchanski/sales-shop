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
    errorImage = "https://britenet7-dev-ed--c.documentforce.com/sfc/dist/version/download/?oid=00D7Q000004Qv7A&ids=0687Q00000357uZ&d=%2Fa%2F7Q000000TP5r%2FaE5dsVi0EWBYWF_ZFYE_VCQlp_0s.DYJzUsekfPN92k&asPdf=false"
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

                if(itemElement.price !== itemElement.priceWithDiscount){
                    itemElement.isDiscount = true;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = 'discountPrice';

                }else{
                    itemElement.isDiscount = false;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = ''


                }

            }

            this.tempProduct = test;
            this.productToDisplay = test;
            console.log(typeof this.productToDisplay);
            console.log(result)
        }).catch((error) => {
            console.log(error);
        })
        registerListener('searchDetails', this.setUpDetails, this)
        registerListener('filterDetails', this.setUpFilter, this)
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    setUpFilter(filterValue) {
        // Object.filter = (obj, predicate) =>
        //     Object.fromEntries(Object.entries(obj).filter(predicate));
        if (filterValue === 'toClear') {
            this.productToDisplay = this.tempProduct;
        } else if (typeof filterValue === "object") {
            this.productToDisplay = this.tempProduct.filter(el => {
                return (filterValue.type !== '' ? el.type === filterValue.type : true) &&
                    (filterValue.brand !== '' ? el.brand === filterValue.brand : true) &&
                    (filterValue.hpMin !== '' && filterValue.hpMin !== null ? el.hp >= filterValue.hpMin : true) &&
                    (filterValue.hpMax !== '' && filterValue.hpMax !== null ? el.hp <= filterValue.hpMax : true) &&
                    ((filterValue.priceMin !== '' && filterValue.priceMin !== null ? el.price >= parseInt(filterValue.priceMin) : true)|| (filterValue.priceMin !== '' && filterValue.priceMin !== null ? el.priceWithDiscount >= parseInt(filterValue.priceMin) : false))&&
                    ((filterValue.priceMax !== '' && filterValue.priceMax !== null ? el.price <= parseInt(filterValue.priceMax) : true)|| (filterValue.priceMax !== '' && filterValue.priceMax !== null ? el.priceWithDiscount <= parseInt(filterValue.priceMax) : false)) &&
                    (filterValue.startYear !== '' && filterValue.startYear !== null ? el.prodYear >= parseInt(filterValue.startYear) : true) &&
                    (filterValue.endYear !== '' && filterValue.endYear !== null ? el.prodYear <= parseInt(filterValue.endYear) : true)
            })
        }

        // console.log(filtered);

    }

    setUpDetails(searchValue) {
        this.details = searchValue
        searchProduct({findBy: this.details}).then((result) => {
            let test = JSON.parse(JSON.stringify(result));

            for (const itemElement of test) {

                if(itemElement.price !== itemElement.priceWithDiscount){
                    itemElement.isDiscount = true;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = 'discountPrice';

                }else{
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
