/**
 * Created by dominikbarchanski on 13/06/2022.
 */

import {api, LightningElement} from 'lwc';
import USER_ID from  '@salesforce/user/Id'
export default class DeleteCommentButton extends LightningElement {
@api displayButton;
    @api indexData;
disabledCal = false //this.displayButton.CreatedById !== USER_ID
    connectedCallback(){
        this.disabledCal = this.displayButton.value.CreatedById !== USER_ID;
    }


    callDelete(event){
        let param = {Id:this.displayButton.value.Id};
        let ev = new CustomEvent('deletecomment',{detail:param});
        this.dispatchEvent(ev);
    }
    callEdit(event){
        console.log(this.indexData);
        let param = {Id:this.displayButton.value.Id,indexRow: this.indexData};
        let ev = new CustomEvent('editcomment',{detail:param});
        this.dispatchEvent(ev);
    }

}