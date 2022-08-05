/**
 * Created by dominikbarchanski on 28/07/2022.
 */

import {LightningElement, track} from 'lwc';
import id from "@salesforce/user/Id";
import orderHistory from '@salesforce/apex/LWC_dmlOrder.userOrderHistory'

export default class OrderHistoryPage extends LightningElement {
    userId = id;
    @track orderHistory
    @track priceForAllProduct =0;
    makeComplain = false;
    connectedCallback() {
        orderHistory({userID: this.userId}).then(result => {
            console.log(result)
            for (const resultElement of result) {
                this.priceForAllProduct += resultElement.price;
                let itemDate = new Date(resultElement.createDate);
                resultElement.createDate = (itemDate.toLocaleTimeString() + " " + itemDate.toLocaleDateString());
                if (sessionStorage.getItem('orderedProduct')) {
                    resultElement._isOpen = resultElement.Id == sessionStorage.getItem('orderedProduct');
                } else {
                    resultElement._isOpen = false;
                }

            }

            this.orderHistory = result
            sessionStorage.clear();
        }).catch(e => {
            console.log(e);
        })
    }

    handleClick(event) {
        this.orderHistory.map(item => {
            item._isOpen = false;
        });
        this.orderHistory[parseInt(event.currentTarget.dataset.index, 10)]._isOpen = true;
    }

}