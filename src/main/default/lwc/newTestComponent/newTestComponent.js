import { LightningElement } from 'lwc';

export default class NewTestComponent extends LightningElement {
    greeting = 'World';
changeHandler(event) {
  this.greeting = event.target.value;
}}