/**
 * Created by dominikbarchanski on 22/07/2022.
 */

import {LightningElement, track,api} from 'lwc';
import Id from '@salesforce/user/Id';
import addComment from '@salesforce/apex/LWC_dmlOperation.AddCommentAndRate'

export default class AddComment extends LightningElement {
    @track ComTitle = '';
    @track ComBody = '';
    @track priceStar = 0;
    @track designStar =0;
    @track safetyStar = 0;
    @track overallStar =0;
    listOfComment =[];
    @api productId
    userId = Id;

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
            addComment({commentId:'',userId:this.userId,productId:this.productId,rate:this.overallStar,title:this.ComTitle,body:this.ComBody}).then(result=>{
                this.listOfComment = result;
                console.log('przed')
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