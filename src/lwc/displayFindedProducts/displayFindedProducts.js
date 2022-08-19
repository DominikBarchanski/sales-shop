/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import searchProduct from '@salesforce/apex/LWC_dmlOperation.searchProduct'

export default class DisplayFindedProducts extends NavigationMixin(LightningElement) {
    @track details ='';
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
    typeCar
    @track displayPageRecord = 10;
    @track currentPage = 1;
    @track disableNextLast;
    @track disablePreviousFirst;
    @track displayPagination ;
    @track filteredList=[];

    onerrorHandler() {
        return this.errorImage;
    }

    connectedCallback() {
        if (sessionStorage.getItem('searchValue')) {
            this.details = sessionStorage.getItem('searchValue')
            // sessionStorage.clear();
        } else {
            this.details = '';
        }
        if (sessionStorage.getItem('filterSet')) {
            this.typeCar = sessionStorage.getItem('filterSet')
            console.log(this.typeCar)
        }
        if (sessionStorage.getItem('searchValue') || sessionStorage.getItem('filterSet')) {
            sessionStorage.clear()
        }

        searchProduct({findBy: this.details}).then((result) => {

            let test = JSON.parse(JSON.stringify(result));

            for (const itemElement of test) {
                let item =parseInt( itemElement.price);
                let itemdisc =parseInt( itemElement.priceWithDiscount);
                if (itemElement.price !== itemElement.priceWithDiscount) {
                    itemElement.isDiscount = true;

                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = 'discountPrice';
                } else {

                    itemElement.isDiscount = false;
                    itemElement.discountStyle = 'price';
                    itemElement.discountPrice = ''
                }
                 itemElement.price = item.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
                 itemElement.priceWithDiscount = itemdisc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");


            }


            this.tempProduct = test;
            this.displayPagination = test.length > this.displayPageRecord;
            this.changePage(1);
            // this.productToDisplay = test;
            if (this.typeCar) {

                this.productToDisplay = test.filter(el => {
                    return (this.typeCar !== '' ? el.type === this.typeCar : true)

                })
            }
        }).catch((error) => {
            console.log(error);
        })
        registerListener('searchDetails', this.setUpDetails, this)
        registerListener('filterDetails', this.setUpFilter, this)
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }


     numPages(){
        return Math.ceil(this.tempProduct.length / this.displayPageRecord);
    }
    changePage(page){
        if (page < 1) page = 1;
        if (page > this.numPages()) page = this.numPages();
        this.productToDisplay=[]
        for (let i = (page-1) * this.displayPageRecord; i < (page * this.displayPageRecord); i++) {
            console.log(this.tempProduct[i])
            if(!(this.filteredList.length >0)){

            if(this.tempProduct[i]!==undefined)
            this.productToDisplay.push( this.tempProduct[i])
            }else{
                if(this.filteredList[i]!==undefined)
                    this.productToDisplay.push( this.filteredList[i])

            }
        }
        page===1? this.disablePreviousFirst = true:this.disablePreviousFirst = false
        page===this.numPages()? this.disableNextLast = true:this.disableNextLast = false
    }
    firstPage(){
        this.currentPage=1
        this.changePage(1)
    }
    prevPage()
    {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.changePage(this.currentPage);
        }
    }

    nextPage()
    {
        console.log(this.numPages())
        if (this.currentPage < this.numPages()) {
            this.currentPage++;
            this.changePage(this.currentPage);
        }
    }
    lastPage(){
        this.changePage(this.numPages())
    }

    setUpFilter(filterValue) {
        // Object.filter = (obj, predicate) =>
        //     Object.fromEntries(Object.entries(obj).filter(predicate));


        console.log(filterValue);
        if (filterValue === 'toClear') {
            console.log('weszło')
            this.filteredList =[];
            this.changePage(1);
            this.displayPagination = this.tempProduct.length > this.displayPageRecord;

            // this.productToDisplay = this.tempProduct;
        } else if (typeof filterValue === "object") {
            for (const item of this.tempProduct) {
                if (filterValue.position.lan !== undefined) {

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
                    console.log(R * c);
                    item.distance = R * c
                } else {
                    item.distance = ''
                }
            }
            this.filteredList = this.tempProduct.filter(el => {
                return (filterValue.type !== '' ? el.type === filterValue.type : true) &&
                    (filterValue.brand !== '' ? el.brand === filterValue.brand : true) &&
                    (filterValue.hpMin !== '' && filterValue.hpMin !== null ? el.hp >= filterValue.hpMin : true) &&
                    (filterValue.hpMax !== '' && filterValue.hpMax !== null ? el.hp <= filterValue.hpMax : true) &&
                    ((filterValue.priceMin !== '' && filterValue.priceMin !== null ? el.price >= parseInt(filterValue.priceMin) : true) || (filterValue.priceMin !== '' && filterValue.priceMin !== null ? el.priceWithDiscount >= parseInt(filterValue.priceMin) : false)) &&
                    ((filterValue.priceMax !== '' && filterValue.priceMax !== null ? el.price <= parseInt(filterValue.priceMax) : true) || (filterValue.priceMax !== '' && filterValue.priceMax !== null ? el.priceWithDiscount <= parseInt(filterValue.priceMax) : false)) &&
                    (filterValue.startYear !== '' && filterValue.startYear !== null ? el.prodYear >= parseInt(filterValue.startYear) : true) &&
                    (filterValue.endYear !== '' && filterValue.endYear !== null ? el.prodYear <= parseInt(filterValue.endYear) : true) &&
                    (filterValue.distance !== '' && filterValue.distance !== null && filterValue.distance !== NaN ? el.distance < parseInt(filterValue.distance) : true)

            })
            this.displayPagination = this.filteredList.length > this.displayPageRecord;
            this.changePage(1);
        }


    }



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
            this.filteredList =[];
            this.tempProduct = test;
            this.displayPagination = test.length > this.displayPageRecord;
            this.changePage(1);

        }).catch((error) => {
            console.log(error);
        })

    }

    handleProductClick(event) {
        this.recordId = event.currentTarget.dataset.id;
        this.recordName = event.currentTarget.dataset.value;
        console.log(this.recordName)
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/product/' + this.recordName + '/' + this.recordId
            }
        })

    }



}