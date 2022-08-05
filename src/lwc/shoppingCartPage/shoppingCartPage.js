/**
 * Created by dominikbarchanski on 26/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import id from "@salesforce/user/Id";
import allProductsFormCart from '@salesforce/apex/LWC_dmlOperation.allProductsFormCart'
import deleteFromCart from  '@salesforce/apex/LWC_dmlOperation.deleteFromCart'
import {fireEvent} from 'c/pubsub';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
export default class ShoppingCartPage extends NavigationMixin(LightningElement) {
    @track WholeCart;
    @track fullPrice;
    @track numberOfItem;
    @track refresh=true;
    @track wonTable={
        "avgConsumption": 0,
        "capacity": 0,
        "cityConsumption": 0,
        "doors": 0,
        "places": 0,
        "price": 0,
        "speed": 0,

    };
    @wire(CurrentPageReference) pageRef;
    userId = id;

    connectedCallback() {

            this.getCart()

    }

    getCart(){
        allProductsFormCart({userId: this.userId}).then(result => {
            // this.wonTable =
            for (const item of result) {
                for(const [key,value] of Object.entries(item)){
                    switch(key){
                        case "avgConsumption":
                            value < this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                        case "capacity":
                            value > this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                        case "cityConsumption":
                            value < this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                        case "doors":
                            value > this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                        case "places":
                            value > this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                        case "speed":
                            value > this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                        case "price":
                            value < this.wonTable[key] || this.wonTable[key]===0 ? this.wonTable[key]=value:null;
                            break;
                    }
                }

            }
            this.WholeCart = result
            this.sumPrice( result)
            this.numberOfItem = result.length;
            for (const wholeCartElement of this.WholeCart) {
                this.makeTableColumn(wholeCartElement)
            }
        }).catch(e => {
            console.log(e)
        })

    }
    sumPrice(sumList){
        let sum=0;
        sumList.forEach(item => sum+= parseFloat(item.price));
        this.fullPrice = sum;
    }
    handleDeleteFromCart(event){
        let deleteItemId = event.currentTarget.dataset.value

        deleteFromCart({cartId: deleteItemId}).then(result => {
            this.getCart();
            fireEvent(this.pageRef,"addRemoveFromCart",result)
        }).catch(e => {
            console.log(e)
        })
    }
    removeColumn(event){
        let toDelete=event.target.closest('td').cellIndex;
        let toDelete11=event.target.value;
        console.log('działa i się nie wyjebało')
        console.log(this.template.querySelector('.table_selector'))
        deleteFromCart({cartId: toDelete11}).then(result => {
            fireEvent(this.pageRef,"addRemoveFromCart",result)
        }).catch(e => {
            console.log(e)
        })

        let tble = this.template.querySelector('.table_selector');
        var row = tble.rows;
        for (let j = 0; j < row.length; j++) {
            row[j].deleteCell(toDelete);
        }

    }
    buyProduct(event){
        let productId=event.target.value;

        sessionStorage.setItem('orderItem',productId);
        this[NavigationMixin.Navigate]({
            type:'comm__namedPage',
            attributes:{
                name:'orderPage__c'
            }
        })
    }

    makeTableColumn(item){
        const display ={
            0:'action',
            1:'photoUrl',
            2:'name',
            3:'price',
            4:'fullAddress',
            5:'cityConsumption',
            6:'avgConsumption',
            7:'doors',
            8:'places',
            9:'capacity',
            10:'speed',
            11:'id'
        };

        [...this.template.querySelectorAll('.table_selector tr')].forEach((row,i)=>{
            const input = document.createElement('div')
            if(i===0){
                const removeButton = document.createElement('button')
                removeButton.setAttribute('value',item[display[11]])
                removeButton.setAttribute('class',"slds-button slds-button_brand")
                removeButton.setAttribute('style',"height:30px")
                removeButton.addEventListener("click", this.removeColumn.bind(this));
                removeButton.innerHTML = '<svg class="slds-button__icon" focusable="false" data-key="delete" aria-hidden="true" viewBox="0 0 52 52"><g><g><path d="M45.5 10H33V6c0-2.2-1.8-4-4-4h-6c-2.2 0-4 1.8-4 4v4H6.5c-.8 0-1.5.7-1.5 1.5v3c0 .8.7 1.5 1.5 1.5h39c.8 0 1.5-.7 1.5-1.5v-3c0-.8-.7-1.5-1.5-1.5zM23 7c0-.6.4-1 1-1h4c.6 0 1 .4 1 1v3h-6V7zM41.5 20h-31c-.8 0-1.5.7-1.5 1.5V45c0 2.8 2.2 5 5 5h24c2.8 0 5-2.2 5-5V21.5c0-.8-.7-1.5-1.5-1.5zM23 42c0 .6-.4 1-1 1h-2c-.6 0-1-.4-1-1V28c0-.6.4-1 1-1h2c.6 0 1 .4 1 1v14zm10 0c0 .6-.4 1-1 1h-2c-.6 0-1-.4-1-1V28c0-.6.4-1 1-1h2c.6 0 1 .4 1 1v14z"></path></g></g></svg>'
                input.appendChild(removeButton)
            }
            else if(i===1){
            const photo = document.createElement('img')
                input.setAttribute('style','width:50%')
                photo.setAttribute('src',item[display[i]])
                input.appendChild(photo);
            }else if(i===11){

                const selectButton = document.createElement('button')
                selectButton.setAttribute('value',item['prodId'])
                selectButton.setAttribute('class',"slds-button slds-button_brand")
                selectButton.addEventListener("click", this.buyProduct.bind(this));
                selectButton.innerHTML = "Buy This One"
                input.appendChild(selectButton)
            }else{
                if(this.wonTable[display[i]]===item[display[i]]){
                    input.setAttribute('style','font-weight:bold;color:lightseagreen')
                }
                input.textContent = ( item[display[i]]);
            }
            const cell = document.createElement('td')
            let widthTd = 'width:calc(((100%-200px)/'+3+'));text-align: -webkit-center;';
            cell.setAttribute('style',widthTd);
            // console.log(widthTd);
            cell.appendChild(input);
            row.appendChild(cell);
        })
    }
}