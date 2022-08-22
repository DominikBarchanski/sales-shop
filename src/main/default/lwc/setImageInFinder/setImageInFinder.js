/**
 * Created by dominikbarchanski on 08/06/2022.
 */

import {api, LightningElement} from 'lwc';

export default class SetImageInFinder extends LightningElement {
    @api songImage;
    get imgUrl () {
        if(this.songImage) {
            if(this.songImage.images instanceof String){
                console.log('true');
            }

            if (this.songImage.images != null ) {
                for (const songImageElement of this.songImage.images) {
                    if (songImageElement.height == 160 || songImageElement.height == 300) {
                        return songImageElement.url;
                    }
                }
            }
        }
    }


}