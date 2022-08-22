/**
 * Created by dominikbarchanski on 09/06/2022.
 */

import {api, LightningElement, track, wire} from 'lwc';
import {refreshApex} from '@salesforce/apex';
import {createRecord, deleteRecord} from 'lightning/uiRecordApi';
import getComments from '@salesforce/apex/LWC_apiCalls.getAllComments';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getArtistAlbum from '@salesforce/apex/LWC_apiCalls.getArtistAlbum';
import getAlbumTrack from '@salesforce/apex/LWC_apiCalls.getAlbumTrack';
import getAllAlbumArtist from '@salesforce/apex/LWC_apiCalls.getAllAlbumArtist';
import getTrackByAlbumId from '@salesforce/apex/LWC_apiCalls.getTrackByAlbumId';
import getArtistById from '@salesforce/apex/LWC_apiCalls.getArtistById';
import getFavBan from '@salesforce/apex/LWC_apiCalls.getFavBlacklist';
import getBlockedItems from '@salesforce/apex/LWC_apiCalls.getBlockedItems';
import {fireEvent} from 'c/pubsub'
import {CurrentPageReference} from 'lightning/navigation';
import Id from "@salesforce/user/Id";

export default class DetailsModalItem extends LightningElement {
    addComments = false;
    commentBody;
    ratingNote;
    rateAvg;
    allAlbums;
    favId;
    refreshDataFav;
    favItemId;
    modalToClose = false;
    @track disableFav;
    @track disableBan;
    @track favState = false;
    @track banState = false;
    @api songId;
    @api modalDetails;
    @api modalDetailsArtist;
    @api favBanList;
    @track  durationTime;
    refreshData;
    allComments;
    wholeAlbum;
    recordId;
    @wire(CurrentPageReference) objpageReference;

    @wire(getComments, {id: '$songId'})
    allComment(result) {
        this.refreshData = result;
        if (result.data) {
            this.allComments = result.data;
            this.allComments = [...Array(result.data.length).keys()].map(key => ({
                key,
                readOnly: true,
                value: result.data[key]
            }))
            let sum = 0;
            let len = result.data.length
            for (let resultKey of result.data) {
                if (resultKey.Rate__c !== undefined) {
                    sum += resultKey.Rate__c;
                } else {
                    len -= 1;
                }
            }
            this.rateAvg = (sum / len).toFixed(2);
        } else if (result.error) {
            console.log(result.error);
        }

    }


    hideModalDetails() {
        this.modalDetails = false;
        const closeEvent = new CustomEvent("closedetailsmodal", {
            detail: this.modalDetails
        })
        this.dispatchEvent(closeEvent)

    }

    connectedCallback() {
        getBlockedItems( {id: Id}).then(result=>
        {
            this.banedItem = result
        });




        if (this.modalDetails !== undefined) {

            if (this.modalDetails.album) {
                this.favId = this.modalDetails.id;
                this.getAllTrackInAlbum();

            }


        } else if (this.modalDetailsArtist !== undefined) {

            this.favId = this.modalDetailsArtist.id;
            this.getAllArtistAlbum();

        }


    }

    getAllArtistAlbum() {
        for (const favBanListElement of this.favBanList) {
            if (favBanListElement.Item_Id__c === this.modalDetailsArtist.id) {
                this.checkFavBanType(favBanListElement.Favourite_Blacklist__c)

                this.favItemId = favBanListElement.Id;
                break
            } else {
                this.favState = false;
                this.banState = false;
            }
        }
        getAllAlbumArtist({artistId: this.modalDetailsArtist.id}).then(result => {
            let item = JSON.parse(result);
            this.allAlbums = item.items;

        }).catch(error => {
            console.log(error);
        })
    }
    checkFavBanType(type) {
        if (type === 'blocked') {
            this.favState = false;
            this.banState = true;
            this.disableFav = true;
            this.disableBan = false;
        } else if (type === 'favourite') {
            this.favState = true;
            this.banState = false;
            this.disableFav = false;
            this.disableBan = true;
        }

    }

    getAllTrackInAlbum() {
        for (const favBanListElement of this.favBanList) {
            if (favBanListElement.Item_Id__c === this.modalDetails.id) {
                this.checkFavBanType(favBanListElement.Favourite_Blacklist__c)
                this.favItemId = favBanListElement.Id;
                break
            } else {
                this.favState = false;
                this.banState = false;
            }
        }
        let seconds = ((this.modalDetails.duration_ms % 60000) / 1000).toFixed(0)
        this.durationTime = (Math.floor(this.modalDetails.duration_ms / 60000)).toString() + ':' + (seconds < 10 ? '0' + seconds.toString() : seconds.toString());

        getArtistAlbum({artistId: this.modalDetails.album.id}).then(result => {
            this.wholeAlbum = JSON.parse(result);
            for (const wholeAlbumElement of this.wholeAlbum.tracks.items) {
                wholeAlbumElement['selectedItem'] = wholeAlbumElement.id === this.modalDetails.id;
            }


        }).catch(error => {
            console.log(error);
        })

    }



    valueFromTestBox(event) {
        this.commentBody = event.target.value;
    }

    displayCommentSection() {
        this.addComments = true;
    }

    rating(event) {
        this.ratingNote = event.target.value;
    }

    onSubmit(event) {

        if (this.modalDetails) {
            let fields = {
                'Rate__c': this.ratingNote,
                'Item_Id__c': this.modalDetails.id,
                'Comment__c': this.commentBody
            }
            if (fields.Rate__c != null) {
                const createRecordFields = {apiName: 'Music_Comments__c', fields};
                createRecord(createRecordFields).then(result => {
                    this.allComments = null;
                    refreshApex(this.refreshData);

                }).catch(error => {
                    console.log(error);
                })
            }
        } else if (this.modalDetailsArtist) {
            let fields = {
                'Rate__c': this.ratingNote,
                'Item_Id__c': this.modalDetailsArtist.id,
                'Comment__c': this.commentBody
            }
            if (fields.Rate__c != null) {
                const createRecordFields = {apiName: 'Music_Comments__c', fields};
                createRecord(createRecordFields).then(result => {
                    this.allComments = null;
                    refreshApex(this.refreshData);

                }).catch(error => {
                    console.log(error);
                })
            }
        }
        this.addComments = false
        this.commentBody = null;
    }

    deleteComment(event) {
        deleteRecord(event.detail.Id).then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Record deleted',
                variant: 'success'
            }));
            this.allComments = null;
            refreshApex(this.refreshData);

        }).catch(error => {
            console.log(error)
        })
    }

    handleSubmit() {

    }

    handleSuccess() {
        new ShowToastEvent({
            title: 'Success',
            message: 'Record deleted',
            variant: 'success'
        });

        refreshApex(this.refreshData);
    }

    handleEdit(event) {
        for (const allComment1 of this.allComments) {
            allComment1.readOnly = true;
        }
        this.allComments[event.detail.indexRow].readOnly = false;
        this.allComments = [...this.allComments];
        this.recordId = event.detail.Id;

    }

    swapTrack(event) {
        const itemIndex = event.currentTarget.dataset.index;
        getAlbumTrack({trackId: this.wholeAlbum.tracks.items[itemIndex].id})
            .then(result => {
                let res = JSON.parse(result)
                this.modalDetails = res;
                this.songId = res.id;
                this.favId = res.id;
                this.disableBan = false;
                this.disableFav = false;
                let seconds = ((this.modalDetails.duration_ms % 60000) / 1000).toFixed(0)
                this.durationTime = (Math.floor(this.modalDetails.duration_ms / 60000)).toString() + ':' + (seconds < 10 ? '0' + seconds.toString() : seconds.toString());
                this.getAllTrackInAlbum();
                refreshApex(this.modalDetails)
                refreshApex(this.refreshData)
            }).catch(error => {
            console.log(error);
        })
    }

    swapAlbum(event) {
        const itemIndex = event.currentTarget.dataset.index;
        getTrackByAlbumId({albumID: this.allAlbums[itemIndex].id}).then(result => {
            let res = JSON.parse(result)
            this.modalDetailsArtist = false;
            this.modalDetails = res.items[0];
            this.modalDetails['album'] = this.allAlbums[itemIndex];
            this.disableBan = false;
            this.disableFav = false;
            this.getAllTrackInAlbum()

            this.allComments = null;
            this.songId = res.items[0].id;
            this.favId = res.items[0].id;
            refreshApex(this.modalDetailsArtist)
            refreshApex(this.modalDetails)
            refreshApex(this.refreshData)
            refreshApex(this.wholeAlbum)
        }).catch(error => {
            console.log(error);
        })
    }

    handleArtistClick(event) {
        let index = event.currentTarget.dataset.index;
        getArtistById({artistId: this.modalDetails.artists[index].id}).then(result => {
            let res = JSON.parse(result);
            this.modalDetails = null;
            this.modalDetailsArtist = res;
            this.allComments = null;
            this.songId = res.id;
            this.favId = res.id;
            this.disableFav = false;
            this.disableBan = false;
            this.getAllArtistAlbum();
            refreshApex(this.modalDetailsArtist)
            refreshApex(this.modalDetails)
            refreshApex(this.refreshData)
            refreshApex(this.wholeAlbum)
        }).catch(error => {
            console.log(error);
        })
    }

    handleFavState() {


        if (!this.favState) {
            let type;
            let name;

            if (this.modalDetails !== undefined && this.modalDetails) {
                type = 'track';
                name = this.modalDetails.name;
            } else if (this.modalDetailsArtist !== undefined && this.modalDetailsArtist) {
                type = 'artist';
                name = this.modalDetailsArtist.name;
            }
            let fields = {
                'Item_Id__c': this.favId,
                'Favourite_Blacklist__c': 'favourite',
                'Type_Of_Object__c': type,
                'Name__c': name
            }

            const createRecordFields = {apiName: 'Music_Favorite_Blacklist__c', fields};
            createRecord(createRecordFields).then(result => {
                this.favState = !this.favState;
                this.favItemId = result.id;
                this.disableFav = false;
                this.disableBan = true;
                refreshApex(this.refreshDataFav)
            }).catch(error => {
                console.log(error)
            })
        } else {
            deleteRecord(this.favItemId).then(() => {
                this.favState = !this.favState;
                this.disableFav = false;
                this.disableBan = false;
                refreshApex(this.refreshDataFav);

            }).catch(error => {
                console.log(error)
            })
        }
    }

    @wire(getFavBan, {userId: Id})
    refreshDataFavItem(result) {
        this.refreshDataFav = result;
        if (result.data) {
            this.favBanList = result.data;

        }
    }

    banedItem;
    bannedDataItem
    @wire(getBlockedItems, {id: Id})
    refreshDataForBlacklist(result) {
        this.banedItem = result;
        if (result.data) {
            this.bannedDataItem = result.data

            this.handleParentBanList();
        }
    }

    handleParentBanList() {
        refreshApex(this.banedItem);
        setTimeout(() => {
            const closeEvent = new CustomEvent("refreshblocked", {
                detail: this.banedItem.data
            })
            this.dispatchEvent(closeEvent)

        }, 0);
    }
    async handleBanState() {
        if (!this.banState) {
            let type;
            let name;
            if (this.modalDetails !== undefined && this.modalDetails) {
                type = 'track';
                name = this.modalDetails.name;
                this.favId = this.modalDetails.id

            } else if (this.modalDetailsArtist !== undefined && this.modalDetailsArtist) {
                type = 'artist';
                name = this.modalDetailsArtist.name;
                this.favId = this.modalDetailsArtist.id
            }
            let fields = {
                'Item_Id__c': this.favId,
                'Favourite_Blacklist__c': 'blocked',
                'Type_Of_Object__c': type,
                'Name__c': name
            }

            const createRecordFields = {apiName: 'Music_Favorite_Blacklist__c', fields};
            await createRecord(createRecordFields).then(result => {
                this.banState = !this.banState;
                this.disableBan = false;
                this.disableFav = true;
                this.favItemId = result.id
                this.modalDetails = false;
                this.modalToClose = false;
                this.banedItem = null;
                refreshApex(this.banedItem);
                refreshApex(this.refreshData);
                refreshApex(this.refreshDataFav)
                fireEvent(this.objpageReference, 'sendModalClose', this.modalToClose);

            });



        } else {
             await deleteRecord(this.favItemId).then(() => {
                this.banState = !this.banState;
                this.disableBan = false;
                this.disableFav = false;
                 this.banedItem = null;
                 refreshApex(this.banedItem);
                 refreshApex(this.refreshData);
                 refreshApex(this.refreshDataFav);


            });


        }
        refreshApex(this.banedItem);
        this.handleParentBanList();


    }
}