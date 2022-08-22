/**
 * Created by dominikbarchanski on 07/06/2022.
 */

import {LightningElement, track, wire, api} from 'lwc';
import wrappedCustomObject from '@salesforce/apex/LWC_apiCalls.wrappedCustomObject';
import searchSongTest from '@salesforce/apex/LWC_apiCalls.searchSongTest'
import Id from "@salesforce/user/Id";
import getBlockedItems from '@salesforce/apex/LWC_apiCalls.getBlockedItems';
import {refreshApex} from "@salesforce/apex";

export default class MusicAppFinder extends LightningElement {
    records;
    apidata;
    searchType = 'track';
    boolDisplayArtist;
    customObjectsSoql;
    boolDisplayTrack = true;
    value = 'track'
    valueLimit = '20';
    offsetValue = 0;
    showModalArtist = false;
    showModalTrack = false;
    displayButtons = false;
    blockedItemList;
    findedCustom;
    modalTest = false;

    get options() {
        return [
            {label: 'Track', value: 'track'},
            {label: 'Artist', value: 'artist'},
        ];
    }

    get limitList() {
        return [
            {label: '20', value: '20'},
            {label: '40', value: '40'}
        ]
    }


    @api songName;

    handleChange(event) {
        let input = this.template.querySelectorAll("lightning-input");
        input.forEach(function (elem) {
            if (elem.name === "songNameInput") {
                this.songName = elem.value;
            }
        }, this);
        wrappedCustomObject({name: this.songName}).then(result => {
            this.customObjectsSoql = JSON.parse(result);
            this.findedCustom = this.customObjectsSoql.length;
        })
        this.displayButtons = true

    }

    refreshBlockedList(event) {

        if (event.detail) {
            this.blockedItemList = event.detail;
        }

        // <!-- map artists -->
        const mapitemArtist = new Map(this.apidata.artists.items.map(object => {
            return [object.id, object]
        }))

        for (const musicFavoriteBlacklistC of this.blockedItemList) {
            if (mapitemArtist.has(musicFavoriteBlacklistC.Item_Id__c)) {
                mapitemArtist.delete(musicFavoriteBlacklistC.Item_Id__c)
            }
        }
        this.apidata.artists.items = Array.from(mapitemArtist.values());

        // <!-- map track -->
        const mapitemTrack = new Map(this.apidata.tracks.items.map(object => {
            return [object.id, object]
        }))


        for (const musicFavoriteBlacklistC of this.blockedItemList) {
            if (mapitemTrack.has(musicFavoriteBlacklistC.Item_Id__c)) {
                mapitemTrack.delete(musicFavoriteBlacklistC.Item_Id__c)
            }
        }
        this.apidata.tracks.items = Array.from(mapitemTrack.values());
        this.records = null;
        this.records = this.searchType == 'track' ? this.apidata.tracks.items : this.searchType == 'artist' ? this.apidata.artists.items : null;

        this.showModalTrack = false;
        this.showModalArtist = false;
        refreshApex(this.records);
        refreshApex(this.blockedItemList);
        // this.allItemsData = null;
        refreshApex(this.allItemsData);
        // this.boolDisplayTrack = false;
        // this.boolDisplayArtist = false;
        // if (this.searchType == 'track') {
        //     this.boolDisplayTrack = true;
        //     this.boolDisplayArtist = false;
        //
        // } else if (this.searchType == 'artist') {
        //     this.boolDisplayTrack = false;
        //     this.boolDisplayArtist = true;
        // }
        this.modalTest = true
    }

    connectedCallback() {
        getBlockedItems({id: Id}).then(result => {
            this.blockedItemList = result;
            console.log(this.blockedItemList)
        }).catch(error => {
            console.log(error)
        })

    }
    renderedCallback() {
        getBlockedItems({id: Id}).then(result => {
            this.blockedItemList = result;
        }).catch(error => {
            console.log(error)
        })
    }

    allItemsData;

    @wire(searchSongTest, {name: '$songName', type: '$searchType', limitItems: '$valueLimit', offset: '$offsetValue'})
    findSong(result) {
        this.allItemsData = result;
        if (result.data) {
            let resParse = JSON.parse(result.data);
            this.apidata = resParse;
            if (this.customObjectsSoql.tracks) {
                if (this.customObjectsSoql.tracks.length < this.valueLimit && this.offsetValue === 0) {
                    this.apidata.tracks.items = this.customObjectsSoql.tracks.concat(this.apidata.tracks.items);
                    this.apidata.tracks.items.length = this.valueLimit;
                }
            }
            if (this.customObjectsSoql.artists) {
                if (this.customObjectsSoql.artists.length < this.valueLimit && this.offsetValue === 0) {
                    this.apidata.artists.items = this.customObjectsSoql.artists.concat(this.apidata.artists.items);
                    this.apidata.artists.items.length = this.valueLimit;
                }
            }

            // <!-- map artists -->
            const mapitemArtist = new Map(this.apidata.artists.items.map(object => {
                return [object.id, object]
            }))

            for (const musicFavoriteBlacklistC of this.blockedItemList) {
                if (mapitemArtist.has(musicFavoriteBlacklistC.Item_Id__c)) {
                    mapitemArtist.delete(musicFavoriteBlacklistC.Item_Id__c)
                }
            }
            this.apidata.artists.items = Array.from(mapitemArtist.values());

            // <!-- map track -->
            const mapitemTrack = new Map(this.apidata.tracks.items.map(object => {
                return [object.id, object]
            }))


            for (const musicFavoriteBlacklistC of this.blockedItemList) {
                if (mapitemTrack.has(musicFavoriteBlacklistC.Item_Id__c)) {
                    mapitemTrack.delete(musicFavoriteBlacklistC.Item_Id__c)
                }
            }
            this.apidata.tracks.items = Array.from(mapitemTrack.values());

            this.records = this.searchType == 'track' ? this.apidata.tracks.items : this.searchType == 'artist' ? this.apidata.artists.items : null;
        } else if (result.error) {
            console.log(result.error);
        }
    }

    hideModalDetails(event) {
        this.showModalArtist = event.detail;
    }

    hideModalTrack(event) {
        this.showModalTrack = event.detail;
    }

    handleChangeCbBox(event) {
        this.searchType = event.detail.value;
        if (this.searchType == 'track') {
            this.offsetValue = 0;
            this.boolDisplayTrack = true;
            this.boolDisplayArtist = false;
            this.records = this.apidata.tracks.items;
        } else if (this.searchType == 'artist') {
            this.offsetValue = 0;
            this.boolDisplayTrack = false;
            this.boolDisplayArtist = true;
            this.records = this.apidata.artists.items;
        }

    }

    handleChangeCbBoxLimits(event) {
        this.valueLimit = event.detail.value;
        this.offsetValue = 0;
    }

    createArtist() {
        this.showModalArtist = true;
    }

    createTrack() {
        this.showModalTrack = true;
    }

    handleFirst() {
        this.offsetValue = 0;
    }

    handlePrev() {
        if (this.offsetValue >= this.valueLimit) {
            this.offsetValue -= parseInt(this.valueLimit);
            console.log(this.offsetValue);
        }
    }

    handleNext() {
        if (this.offsetValue < 1000 - parseInt(this.valueLimit)) {
            this.offsetValue = parseInt(this.offsetValue) + parseInt(this.valueLimit);
            console.log(this.offsetValue);
        }
    }

    handleLast() {
        this.offsetValue = 1000 - parseInt(this.valueLimit);
    }


}