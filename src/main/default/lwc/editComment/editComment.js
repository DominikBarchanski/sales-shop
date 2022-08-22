/**
 * Created by dominikbarchanski on 13/06/2022.
 */

import {api, LightningElement} from 'lwc';

export default class EditComment extends LightningElement {
    @api commentBody;
    newRate;
    newComment;
    rating(event) {
        this.newRate= event.target.value;
    }
    valueFromTestBox(event) {
        this.newComment = event.target.value;
    }
    handleClick(event){
        console.log('odpalone'+JSON.stringify(this.commentBody));
        let param = {Id:this.commentBody.Id,rate:this.newRate,comment:this.newComment };
        console.log(param);
        let ev = new CustomEvent('editcommentitem',{detail:param});
        this.dispatchEvent(ev);
    }
}