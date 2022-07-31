/**
 * Created by dominikbarchanski on 25/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import id from "@salesforce/user/Id";
import allProductsFormCart from  '@salesforce/apex/LWC_dmlOperation.allProductsFormCart'
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import {fireEvent} from 'c/pubsub';
import deleteFromCart from  '@salesforce/apex/LWC_dmlOperation.deleteFromCart'
import {CurrentPageReference} from "lightning/navigation";
import { NavigationMixin } from 'lightning/navigation';
import CompareIcon from '@salesforce/resourceUrl/compareIcon';
export default class ShoppingCart extends NavigationMixin(LightningElement) {
    userId = id
    @wire(CurrentPageReference) pageRef;
    @track itemInCart
    @track cartToDisplay
    @track sumPrice =0;
    connectedCallback() {
        this.getCart()
        registerListener('addRemoveFromCart', this.setUpFilter, this)
    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    setUpFilter(filterValue) {
        this.getCart()
    }
    getCart(){
        allProductsFormCart({userId:this.userId}).then(result=>{
            console.log(result)
            this.itemInCart = result.length
            this.cartToDisplay = result
            let sum=0
            // this.sumPrice =
                result.forEach(e=> {sum= sum+ parseFloat( e.price)});
            this.sumPrice = sum;
            console.log(this.sumPrice)
            console.log(sum)
        }).catch(e=>{
            console.log(e)
        })
    }
    handleDeleteFromCart(event) {
        let deleteItemId = event.currentTarget.dataset.value

        deleteFromCart({cartId: deleteItemId}).then(result => {
            this.getCart();
            fireEvent(this.pageRef,'itemFromCartDeleted',result)
        }).catch(e => {
            console.log(e)
        })
    }
    handleMoveToCart(){
        let parseitem = JSON.stringify(this.cartToDisplay)
        console.log(parseitem)
        sessionStorage.setItem('itemInCart',parseitem);
        this[NavigationMixin.Navigate]({
            type:'comm__namedPage',
            attributes:{
                name:'shoppingCart__c'
            }
        })
    }

}