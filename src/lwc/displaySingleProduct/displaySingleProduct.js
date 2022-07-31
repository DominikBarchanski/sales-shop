/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getProduct from '@salesforce/apex/LWC_dmlOperation.getSingleProduct'
import deleteComment from  '@salesforce/apex/LWC_dmlOperation.removeAddedComment'
import addToCart from  '@salesforce/apex/LWC_dmlOperation.addProductToCart'
import deleteFromCart from  '@salesforce/apex/LWC_dmlOperation.deleteFromCart'
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import {fireEvent} from 'c/pubsub';
import Id from '@salesforce/user/Id';
import {CurrentPageReference} from "lightning/navigation";
export default class DisplaySingleProduct extends LightningElement {
    @api recordId;
    @wire(CurrentPageReference) pageRef
    @track allProductInfo;
    @track listOfPhoto;
    @track isCommentSection;
    @track isDisplayAddComment = false;
    @track markersMap;
    @track isCommentAdded;
    @track zoomLevel = 13;
    @track commentList ;
    @track addOrEdit ;
    @track addedByCurrentUser
    @track isInCart
    @track starProductRate
    cartProd
    idOfAddedComm;
    userId = Id;
    displayItem = true


    connectedCallback() {

        getProduct({ProdId: this.recordId,UserId:this.userId}).then((response) => {
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

            this.commentList = this.allProductInfo.prodRatings
            this.makeCommentListForDisplay(this.commentList)
            let shoppingcart = this.allProductInfo.prodCart;
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
        registerListener('itemFromCartDeleted',this.refreshProduct,this)
    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    refreshProduct(item){
        let findedInCart = item.find(elem=> elem.id === this.recordId)
        this.isInCart = findedInCart !== undefined
    }
findInCart(inList){
    let findinCart = inList.find(elem => elem.Product_Id__c === this.recordId)
    this.cartProd = findinCart;
    this.isInCart = findinCart !== undefined
}
    makeCommentListForDisplay(commentlist){
        let findedElem =0;
        for (const responseElement of commentlist) {

            const itemDate = new Date(responseElement.LastModifiedDate)
            responseElement.LastModifiedDate = (itemDate.toLocaleTimeString() + " " + itemDate.toLocaleDateString())
            if(responseElement.Product_Id__c === this.recordId && responseElement.CreatedById === this.userId){
                this.idOfAddedComm = responseElement.Id;
                // console.log(responseElement.Id)
            }

            if (responseElement.CreatedById == this.userId ){
                responseElement.todelete = true
                findedElem+= 1;
                this.addedByCurrentUser = responseElement;
            }else {
                responseElement.todelete = false
            }
            let sumForAvg =0;
            commentlist.forEach(i=> {sumForAvg+=i.Rating__c})
            this.starProductRate=sumForAvg/commentlist.length
            // findedElem += responseElement.CreatedById == this.userId ? 1:0
        // console.log( this.addOrEdit = responseElement.includes(this.userId));

        }
        if (findedElem > 0){
            this.addOrEdit = true
        }else{

            this.addOrEdit = false
            this.addedByCurrentUser = []
        }

        this.commentList = commentlist;
        // this.isCommentSection = commentlist>0;
    }

    handleCommentEditAdd(event) {
        this.isCommentSection = event.detail.length > 0;
        this.makeCommentListForDisplay(event.detail)

        this.isDisplayAddComment =false;
    }

    handleDisplayComment() {
        this.isDisplayAddComment = true
    }
    handleDeleteComment(){
        let toDel = confirm('Are you sure you want Delete Your opinion')
        if(toDel){
            deleteComment({commentId:this.addedByCurrentUser.Id,currentProduct:this.recordId}).then(result=>{
                this.makeCommentListForDisplay(result)
                this.isCommentSection = result.length>0
            }).catch(e=>{
                console.log(e);
            })

        }
    }

    handleCartAdd(){
        let prod = {
            userId: this.userId,
            prodId:this.recordId
        }
        addToCart({productWrapper:prod}).then(result=>{
            this.findInCart(result)
            fireEvent(this.pageRef,"addRemoveFromCart",result)
        }).catch(e=>{
            console.log(e)
        })
    } handleCartRemove(){

        deleteFromCart({cartId:this.cartProd.Id}).then(result=>{
            this.findInCart(result)
            fireEvent(this.pageRef,"addRemoveFromCart",result)
        }).catch(e=>{
            console.log(e)
        })
    }
}