/**
 * Created by dominikbarchanski on 21/07/2022.
 */

import {api, LightningElement, track} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";
import jQuary from '@salesforce/resourceUrl/jQuaryLib'
import slickJs from '@salesforce/resourceUrl/slickjs'
import slickCss from '@salesforce/resourceUrl/slickcss'
import slickTheme from '@salesforce/resourceUrl/slicktheme'

export default class DisplayProductPhoto extends LightningElement {
    // @api photoList;
    @api wholeObject;
    // @api mainPhoto
    @track expandingPhoto;
    @track displayPhoto
    @track currenPhoto
    @track noPhoto;

    connectedCallback() {
        this.expandingPhoto = this.wholeObject.photoUrl;
        this.photoList = this.wholeObject.photoList;

        // this.noPhoto = this.photoList !== null;
        // console.log(this.noPhoto)
        if (this.photoList) {
            this.currenPhoto = this.photoList.indexOf(this.expandingPhoto);
        }
    }


    myFunction(event) {
        this.expandingPhoto = event.currentTarget.dataset.value;
        let imgExp = this.template.querySelector('[data-id="expandedImg"]')
        this.displayPhoto = "width:100%; display:block"
        this.currenPhoto = this.photoList.indexOf(this.expandingPhoto);
    }

    prevPhoto() {
        let photoListSize = this.photoList.length;
        if (this.currenPhoto - 1 < 0) {
            this.expandingPhoto = this.photoList[this.photoList.length - 1]
            this.currenPhoto = photoListSize - 1;
        } else {
            this.expandingPhoto = this.photoList[this.currenPhoto - 1]
            this.currenPhoto = this.currenPhoto - 1;
        }
    }

    nextPhoto() {
        let photoListSize = this.photoList.length;
        if (this.currenPhoto + 1 > photoListSize - 1) {
            this.expandingPhoto = this.photoList[0]
            this.currenPhoto = 0;
        } else {
            this.expandingPhoto = this.photoList[this.currenPhoto + 1]
            this.currenPhoto = this.currenPhoto + 1;
        }
    }


}