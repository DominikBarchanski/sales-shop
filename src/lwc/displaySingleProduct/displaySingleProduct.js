/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getProduct from '@salesforce/apex/LWC_dmlOperation.getSingleProduct'
import deleteComment from '@salesforce/apex/LWC_dmlOperation.removeAddedComment'
import addToCart from '@salesforce/apex/LWC_dmlOperation.addProductToCart'
import deleteFromCart from '@salesforce/apex/LWC_dmlOperation.deleteFromCart'
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import {fireEvent} from 'c/pubsub';
import Id from '@salesforce/user/Id';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";

export default class DisplaySingleProduct extends NavigationMixin(LightningElement) {
    @api recordId;
    @wire(CurrentPageReference) pageRef
    @track allProductInfo;
    @track listOfPhoto;
    @track isCommentSection;
    @track isDisplayAddComment = false;
    @track markersMap;
    @track isCommentAdded;
    @track zoomLevel = 13;
    @track commentList;
    @track addOrEdit;
    @track addedByCurrentUser
    @track isInCart
    @track starProductRate;
    @track maxCart

    cartProd
    idOfAddedComm;
    userId = Id;
    displayItem = true


    connectedCallback() {

        getProduct({ProdId: this.recordId, UserId: this.userId}).then((response) => {
            this.allProductInfo = JSON.parse(JSON.stringify(response));
            this.listOfPhoto = response.photoList;
            this.isCommentSection = response.prodRatings.length > 0;

            if (response.street !== undefined && response.city !== undefined && response.country !== undefined) {

                this.markersMap = [{
                    location: {
                        Street: response.street,
                        City: response.city,
                        Country: response.country,
                    },
                    title: '',
                    description: '',
                },];
            }
            this.allProductInfo.prodRatings.map(item => {
                item._isApproved = item.Approval__c == 'approve' || (item.Approval__c != 'approve' && this.userId == item.CreatedById);
                item._isYourApproved = (item.Approval__c != 'approve' && this.userId == item.CreatedById)
            })
            this.commentList = this.allProductInfo.prodRatings
            console.log(this.allProductInfo.prodRatings)
            this.makeCommentListForDisplay(this.commentList)
            let shoppingcart = this.allProductInfo.prodCart;
            console.log((response))
            this.findInCart(shoppingcart)

            if (this.allProductInfo.price !== this.allProductInfo.priceWithDiscount) {
                this.allProductInfo.isDiscount = true;
                this.allProductInfo.discountStyle = 'price';
                this.allProductInfo.discountPrice = 'discountPrice';

            } else {
                this.allProductInfo.isDiscount = false;
                this.allProductInfo.discountStyle = 'price';
                this.allProductInfo.discountPrice = ''
            }
        }).catch(e => {
            console.log(e);
        })
        registerListener('itemFromCartDeleted', this.refreshProduct, this)
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    refreshProduct(item) {
        let findedInCart = item.find(elem => elem.id === this.recordId)
        let val = 0;
        item.forEach(item =>{ item.CreatedById === this.userId ? val++:val})
        this.isInCart = findedInCart !== undefined
        this.maxCart = !(val >=3);
        console.log(this.maxCart)


    }

    findInCart(inList) {
        let findinCart = inList.find(elem => elem.Product_Id__c === this.recordId)
        console.log(inList);
        let val = 0;
        inList.forEach(item =>{ item.CreatedById === this.userId ? val++:val})
        console.log(val)
        this.cartProd = findinCart;
        this.maxCart = !(val >=3);
        this.isInCart = findinCart !== undefined
        console.log(this.maxCart)
    }

    makeCommentListForDisplay(commentlist) {
        let findedElem = 0;
        for (const responseElement of commentlist) {

            const itemDate = new Date(responseElement.LastModifiedDate)
            responseElement.LastModifiedDate = (itemDate.toLocaleTimeString() + " " + itemDate.toLocaleDateString())
            if (responseElement.Product_Id__c === this.recordId && responseElement.CreatedById === this.userId) {
                this.idOfAddedComm = responseElement.Id;
                // console.log(responseElement.Id)
            }

            if (responseElement.CreatedById == this.userId) {
                responseElement.todelete = true
                findedElem += 1;
                this.addedByCurrentUser = responseElement;
            } else {
                responseElement.todelete = false
            }
            let sumForAvg = 0;
            commentlist.forEach(i => {
                sumForAvg += i.Rating__c
            })
            this.starProductRate = sumForAvg / commentlist.length
            // findedElem += responseElement.CreatedById == this.userId ? 1:0
            // console.log( this.addOrEdit = responseElement.includes(this.userId));

        }
        if (findedElem > 0) {
            this.addOrEdit = true
        } else {

            this.addOrEdit = false
            this.addedByCurrentUser = []
        }
        commentlist.map(item => {
            item._isApproved = item.Approval__c == 'approve' || (item.Approval__c != 'approve' && this.userId == item.CreatedById);
            item._isYourApproved = (item.Approval__c != 'approve' && this.userId == item.CreatedById)
        })
        this.commentList = commentlist;
        // this.isCommentSection = commentlist>0;
    }

    handleCommentEditAdd(event) {
        this.isCommentSection = event.detail.length > 0;
        this.makeCommentListForDisplay(event.detail)

        this.isDisplayAddComment = false;
    }

    handleDisplayComment() {
        this.isDisplayAddComment = true
    }

    handleDeleteComment() {
        let toDel = confirm('Are you sure you want Delete Your opinion')
        if (toDel) {
            deleteComment({commentId: this.addedByCurrentUser.Id, currentProduct: this.recordId}).then(result => {
                this.makeCommentListForDisplay(result)
                this.isCommentSection = result.length > 0
            }).catch(e => {
                console.log(e);
            })

        }
    }

    handleCartAdd() {
        let prod = {
            userId: this.userId,
            prodId: this.recordId
        }
        console.log(prod)
        console.log(this.maxCart)
        if(this.maxCart){

        addToCart({productWrapper: prod}).then(result => {
            console.log(result)
            this.findInCart(result)
            fireEvent(this.pageRef, "addRemoveFromCart", result)
        }).catch(e => {
            console.log(e)
        })
        }else{
            alert('Already 3 items in Compare. Remove Item From Compare To Add Another')
        }
    }

    handleCartRemove() {

        deleteFromCart({cartId: this.cartProd.Id}).then(result => {
            this.findInCart(result)
            fireEvent(this.pageRef, "addRemoveFromCart", result)
        }).catch(e => {
            console.log(e)
        })
    }

    handleBuyThisItem() {
        console.log('test')
        console.log(this.recordId)
        let productId = this.recordId;

        sessionStorage.setItem('orderItem', productId);
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'orderPage__c'
            }
        })
    }
}