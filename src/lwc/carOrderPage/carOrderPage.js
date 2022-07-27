/**
 * Created by dominikbarchanski on 26/07/2022.
 */

import {LightningElement, track} from 'lwc';
import getProduct from '@salesforce/apex/LWC_dmlOperation.displayProductToBuy'
export default class CarOrderPage extends LightningElement {
    @track cartItems
    @track productId;
    connectedCallback() {

        if(sessionStorage.getItem('orderItem')){
            this.productId = sessionStorage.getItem('orderItem')
            sessionStorage.clear();
        }
        getProduct({productId:this.productId}).then(result=>{
            console.log(result)
        }).catch(e=>{
            console.log(e)})
    }
}