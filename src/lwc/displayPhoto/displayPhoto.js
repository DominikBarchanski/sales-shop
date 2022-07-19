/**
 * Created by dominikbarchanski on 19/07/2022.
 */

import {LightningElement, api, track} from 'lwc';

export default class DisplayPhoto extends LightningElement {
    @api mainPhoto;
    @track displayPhoto
    interval

// @api photoList ;

    connectedCallback() {
        this.displayPhoto = this.mainPhoto.photoUrl;
    }

//     get displayImg(){
//     if (this.mainPhoto){
//         console.log(this.mainPhoto);
//         return  this.mainPhoto.photoUrl;
//     }
// }
    handleDefaultPhoto() {
        this.displayPhoto = this.mainPhoto.photoUrl;
        clearInterval(this.interval);
    }

    handleChangePhoto(event) {
        if (this.mainPhoto.photoList) {

            let photoListSize = this.mainPhoto.photoList.length;
            let counter = 0;
            this.displayPhoto = this.mainPhoto.photoList[counter];
            if (photoListSize > 1) {
                this.interval = setInterval(() => {
                    if (counter < photoListSize - 1) {
                        counter += 1;
                    } else {
                        counter = 0
                    }
                    this.displayPhoto = this.mainPhoto.photoList[counter];

                }, 2000);
            }
        }

    }

}