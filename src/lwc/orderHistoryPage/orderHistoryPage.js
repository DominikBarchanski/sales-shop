/**
 * Created by dominikbarchanski on 28/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import id from "@salesforce/user/Id";
import orderHistory from '@salesforce/apex/LWC_dmlOrder.userOrderHistory'
import {fireEvent} from 'c/pubsub';
import {CurrentPageReference} from "lightning/navigation";

export default class OrderHistoryPage extends LightningElement {
    userId = id;
    @wire(CurrentPageReference) pageRef;
    @track orderHistory
    @track priceForAllProduct =0;
    @track displayPageRecord = 8;
    @track currentPage = 1;
    @track disableNextLast;
    @track disablePreviousFirst;
    @track displayPagination ;
    @track displayOrderList
    @track orderDisplayPage = 1;
    connectedCallback() {
        orderHistory({userID: this.userId}).then(result => {
            console.log(result)
            for (const resultElement of result) {
                this.priceForAllProduct += resultElement.price;
                let itemDate = new Date(resultElement.createDate);
                resultElement.createDate = (itemDate.toLocaleTimeString() + " " + itemDate.toLocaleDateString());
                if (sessionStorage.getItem('orderedProduct')) {
                    resultElement._isOpen = resultElement.Id == sessionStorage.getItem('orderedProduct');
                    let itemIndex = result.findIndex(item=> item.Id ===sessionStorage.getItem('orderedProduct'));
                    this.orderDisplayPage =(Math.round( itemIndex / this.displayPageRecord))+1
                    console.log(this.orderDisplayPage)
                    console.log(itemIndex)
                } else {
                    resultElement._isOpen = false;
                }
                // resultElement._wasComplain = resultElement.numberCase !== ''
                if(resultElement.numberCase !== ''){
                    resultElement._wasComplain =true;
                    let itemDateCase = new Date(resultElement.createdDateCase);
                    resultElement.createdDateCase = (itemDateCase.toLocaleTimeString() + " " + itemDateCase.toLocaleDateString());
                }else{
                    resultElement._wasComplain =false;

                }
            }
            let dataSet = []
            console.log(result);
            fireEvent(this.pageRef, "addRemoveFromCart", dataSet)
            this.orderHistory = result
            this.displayPagination = result.length > this.displayPageRecord;
            this.changePage(this.orderDisplayPage)
            this.currentPage = this.orderDisplayPage
            sessionStorage.clear();

        }).catch(e => {
            console.log(e);
        })
    }
    numPages(){
        return Math.ceil(this.orderHistory.length / this.displayPageRecord);
    }

    changePage(page){
        if (page < 1) page = 1;
        if (page > this.numPages()) page = this.numPages();
        this.displayOrderList=[]

        for (let i = (page-1) * this.displayPageRecord; i < (page * this.displayPageRecord); i++) {

                if(this.orderHistory[i]!==undefined)
                    this.displayOrderList.push( this.orderHistory[i])

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

        if (this.currentPage < this.numPages()) {
            this.currentPage++;
            this.changePage(this.currentPage);
        }
    }
    lastPage(){
        this.changePage(this.numPages())
    }
    handleClick(event) {

        this.displayOrderList.map(item => {
            if(!item._isOpen)
            item._isOpen = false;
        });
        this.displayOrderList[parseInt(event.currentTarget.dataset.index, 10)]._isOpen = !this.displayOrderList[parseInt(event.currentTarget.dataset.index, 10)]._isOpen;
    }

}