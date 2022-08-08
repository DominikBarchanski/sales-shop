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
        value:'suv'
    }, {
        Label: 'Hatchback',
        photo: this.picture + '/Hatchback.jpeg',
        value:'hatchback'
    }, {
        Label: 'Crossover',
        photo: this.picture + '/Crossover.jpeg',
        value:'crossover'
    }, {
        Label: 'Sports Car',
        photo: this.picture + '/SportsCar.jpeg',
        value:'sports'
    }, {
        Label: 'Coupe',
        photo: this.picture + '/Coupe.jpeg',
        value:'coupe'
    }, {
        Label: 'Pickup Truck',
        photo: this.picture + '/PickupTruck.jpeg',
        value:'pickup'
    }]
    handleSearchType(event){
        console.log(event.currentTarget.dataset.value)
        this[NavigationMixin.Navigate]({
            type:'comm__namedPage',
            attributes:{
                name:'searchProducts__c'
            }
        })
    }
}