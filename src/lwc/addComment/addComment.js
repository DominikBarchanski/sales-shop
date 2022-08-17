/**
 * Created by dominikbarchanski on 22/07/2022.
 */

import {LightningElement, track,api} from 'lwc';
import Id from '@salesforce/user/Id';
import addComment from '@salesforce/apex/LWC_dmlOperation.AddCommentAndRate'
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class AddComment extends LightningElement {
    @api productId;
    @api currentComm;
    @track ComTitle = '';
    @track ComBody = '';
    @track overallStar ;
    @track priceStar ;
    @track designStar ;
    @track safetyStar ;
    listOfComment =[];
    userId = Id;

    connectedCallback() {
        console.log(this.currentComm.Rating__c)
        console.log(JSON.stringify( this.currentComm))
        if(this.currentComm !==undefined){
            this.ComTitle = this.currentComm.Name;
            this.ComBody = this.currentComm.Comment__c;
            this.overallStar =this.currentComm.Rating__c
            this.designStar =this.currentComm.Rate_Design__c
            this.safetyStar =this.currentComm.Rate_Safety__c
            this.priceStar =this.currentComm.Rate_Price__c
        }else{
            this.overallStar =0
            this.designStar =0
            this.safetyStar =0
            this.priceStar =0
        }
    }

    handleTitleChange(event) {
        this.ComTitle = event.target.value
        console.log(event.target.value)
    }

    handleBodyChange(event) {
        this.ComBody = event.target.value
    }
    handleChangePriceStar(event){
        this.priceStar = event.detail.rating
        this.checkOverall()

    }
    handleChangeDesignStar(event){
        this.designStar = event.detail.rating
        this.checkOverall()
    }
    handleChangeSafetyStar(event){
        this.safetyStar = event.detail.rating
        this.checkOverall()
    }
    checkOverall(){
        if(this.priceStar !== 0 &&this.designStar !== 0 &&this.safetyStar !== 0 ){
            this.overallStar = parseFloat ((this.priceStar + this.designStar+this.safetyStar )/3).toFixed(2);
            console.log(this.overallStar);

        }else {
            this.overallStar =0;
        }
    }
    handleAddComment(){
        if(this.ComTitle.length === 0){
            alert('Type Comment Title ')
        }else if ( this.ComBody.length === 0){
            alert('Type comment')
        }else if ( this.overallStar ===0){
            alert('Set all stars')

        }else{
            let commentId =this.currentComm !== undefined ? this.currentComm.Id:'';
            console.log(commentId);
            addComment({commentId:commentId,userId:this.userId,productId:this.productId,rate:this.overallStar,title:this.ComTitle,body:this.ComBody,rateSafe:this.safetyStar,ratePrice:this.priceStar,rateDesign:this.designStar}).then(result=>{
                this.listOfComment = result;
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Comment Created",
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                const refreshAddEvent = new CustomEvent("resultlist",{
                    detail:result
                });
                this.dispatchEvent(refreshAddEvent);
                console.log('po')
                // console.log(result);
                // if (result === 'Added'){
                //     alert('dodało')
                // }else if (result ==='Exist'){
                //     alert('istnieje');
                // }
            }).catch(e=>{
                console.log(e)
            })

        }
    }

}