/**
 * Created by dominikbarchanski on 13/07/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getProduct from '@salesforce/apex/LWC_dmlOperation.getSingleProduct'
import Id from '@salesforce/user/Id';
export default class DisplaySingleProduct extends LightningElement {
    @api recordId;
    @track allProductInfo;
    @track listOfPhoto;
    @track isCommentSection;
    @track isDisplayAddComment = false;
    @track markersMap;
    @track isCommentAdded;
    @track zoomLevel = 13;
    @track commentList ;
    idOfAddedComm;
    userId = Id;
    displayItem = true


    connectedCallback(parentRecordId, relatedListId) {
        getProduct({ProdId: this.recordId}).then((response) => {
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

            if (this.allProductInfo.price !== this.allProductInfo.priceWithDiscount) {
                this.allProductInfo.isDiscount = true;
                this.allProductInfo.discountStyle = 'price';
                this.allProductInfo.discountPrice = 'discountPrice';

            } else {
                this.allProductInfo.isDiscount = false;
                this.allProductInfo.discountStyle = 'price';
                this.allProductInfo.discountPrice = ''
            }
            console.log(this.allProductInfo);
        }).catch(e => {
            console.log(e);
        })

    }

    makeCommentListForDisplay(commentlist){
        for (const responseElement of commentlist) {
            const itemDate = new Date(responseElement.LastModifiedDate)
            responseElement.LastModifiedDate = (itemDate.toLocaleTimeString() + " " + itemDate.toLocaleDateString())
            console.log('tutaj')
            if(responseElement.Product_Id__c === this.recordId && responseElement.CreatedById === this.userId){
                this.idOfAddedComm = responseElement.Id;
                // console.log(responseElement.Id)
            }

        }
        this.commentList = commentlist;
    }

    handleCommentEditAdd(event) {
        this.isCommentSection = event.detail.length > 0;
        this.makeCommentListForDisplay(event.detail)

    }

    handleDisplayComment() {
        this.isDisplayAddComment = true
    }
}