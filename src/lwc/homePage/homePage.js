/**
 * Created by dominikbarchanski on 08/08/2022.
 */

import {LightningElement} from 'lwc';
import homePage from '@salesforce/resourceUrl/homePage'
import { NavigationMixin } from 'lightning/navigation';

export default class HomePage extends NavigationMixin(LightningElement) {
    picture = homePage;
    carType = [{
        Label: 'SUV',
        photo: this.picture + '/SUV.jpeg',
        value:'SUV'
    }, {
        Label: 'Hatchback',
        photo: this.picture + '/Hatchback.jpeg',
        value:'Hatchback'
    }, {
        Label: 'Crossover',
        photo: this.picture + '/Crossover.jpeg',
        value:'Crossover'
    }, {
        Label: 'Sports Car',
        photo: this.picture + '/SportsCar.jpeg',
        value:'Sports Car'
    }, {
        Label: 'Coupe',
        photo: this.picture + '/Coupe.jpeg',
        value:'Coupe'
    }, {
        Label: 'Pickup Truck',
        photo: this.picture + '/PickupTruck.jpeg',
        value:'Pickup Truck'
    }]
    connectedCallback() {
        sessionStorage.clear()
    }

    handleSearchType(event){
        console.log(event.currentTarget.dataset.value)
        let send = event.currentTarget.dataset.value;
        sessionStorage.setItem('filterSet',send)
        this[NavigationMixin.Navigate]({
            type:'comm__namedPage',
            attributes:{
                name:'searchProducts__c'
            }
        })
    }
}