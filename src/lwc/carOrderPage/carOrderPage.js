/**
 * Created by dominikbarchanski on 26/07/2022.
 */

import {LightningElement, track, wire} from 'lwc';
import getProduct from '@salesforce/apex/LWC_dmlOperation.displayProductToBuy'
import createOrder from '@salesforce/apex/LWC_dmlOrder.createOrder'
import {NavigationMixin} from "lightning/navigation";
import {getRecord} from 'lightning/uiRecordApi';
import bankLogos from '@salesforce/resourceUrl/bankLogos'
import wallet from '@salesforce/resourceUrl/wallet'
import Id from '@salesforce/user/Id';
import UserNameFld from '@salesforce/schema/User.Name';
import userEmailFld from '@salesforce/schema/User.Email';
import userIsActiveFld from '@salesforce/schema/User.IsActive';

export default class CarOrderPage extends NavigationMixin(LightningElement) {
    @track cartItems
    @track productId;
    @track deliver = false;
    @track payCard = false;
    @track payCash = false;
    @track payTransfer = false;
    @track payDigital = false;
    @track selectedPayment
    @track selectedPaymentMethod
    @track cardNumber =''
    @track cardPlaceholder=''
    @track cardCvv =''
    wallet = wallet;
    walletLogo = [this.wallet + '/google.png', this.wallet + '/apple.png', this.wallet + '/paypal.png'];
    bank = bankLogos
    logo = [this.bank + '/ing.png', this.bank + '/ca.png', this.bank + '/santander.png', this.bank + '/getin.png', this.bank + '/mbank.png'];

    userId = Id;
    currentUserName;
    currentUserEmailId;
    currentIsActive;

    value = 'collect';
    paymentValue = '';
    error;

    get options() {
        return [
            {label: 'Delivery', value: 'delivery'},
            {label: 'Collect in Shop', value: 'collect'},
        ];
    }

    get paymentOption() {
        return [{label: 'Chose Type', value: ''},
            {label: 'Card', value: 'card'},
            {label: 'Cash', value: 'cash'},
            {label: 'Bank Transfer', value: 'bank'},
        ];
    }

    @wire(getRecord, {recordId: Id, fields: [UserNameFld, userEmailFld, userIsActiveFld]})
    userDetails({error, data}) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
            this.currentUserEmailId = data.fields.Email.value;
            this.currentIsActive = data.fields.IsActive.value;
        } else if (error) {
            this.error = error;
        }
    }

    connectedCallback() {
        // console.log(this.currentUserName)
        if (sessionStorage.getItem('orderItem')) {
            this.productId = sessionStorage.getItem('orderItem')
            sessionStorage.clear();
        } else {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'shoppingCart__c'
                }
            })
        }
        getProduct({productId: this.productId}).then(result => {
            this.cartItems = result;
            console.log(result)
        }).catch(e => {
            console.log(e)
        })
    }

    handleDeliverySelect(event) {
        console.log(event.target.value)
        this.deliver = event.target.value == 'delivery';

    }

    handleDisplayPaymentMethod(event) {
        let clickedValue = event.currentTarget.dataset.value
        console.log(clickedValue)
        this.selectedPaymentMethod = clickedValue=='card'?"Credit Card": clickedValue=='cash'?'Cash': clickedValue=='transfer'?'Bank Transfer':clickedValue=='digital'?'Digital Wallet':null ;
        this.selectedPayment = null;
        this.payCard = clickedValue == 'card' && !this.payCard;
        this.payCash = clickedValue == 'cash' && !this.payCash;
        this.payTransfer = clickedValue == 'transfer' && !this.payTransfer;
        this.payDigital = clickedValue == 'digital' && !this.payDigital;
    }
    handleCardNumber(event){

        console.log(event.target.value)
        this.cardNumber = event.target.value;
    }
    handleCardHolder(event){
        this.cardPlaceholder=event.target.value
    }
    handleCardCvv(event){
        this.cardCvv=event.target.value
    }

    handleMakeOrder() {
        console.log(this.selectedPayment)
        if ((this.payCard &&  this.cardNumber != '' && this.cardNumber.length==16&& this.cardCvv !='' && this.cardPlaceholder != '') || (this.payCash) || (this.payTransfer && this.selectedPayment !== null) || (this.payDigital && this.selectedPayment !== null)) {


            let orderToSend = {
                prodId: this.productId,
                unitPrice: this.cartItems.price
            }
            createOrder({orderItem: orderToSend}).then(response => {

                console.log('added')
            }).catch(e => {
                console.log(e)
            })
        } else {
            alert('Select Payment Method And Check Data')
        }

    }

    handleSelectedMethod(event) {
        this.selectedPayment = event.currentTarget.dataset.value;
        console.log(event.currentTarget.dataset.value)
    }

}