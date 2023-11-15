import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./application";

export default class extends Controller {
    
  toggle(event){
    seekRabbit(event.currentTarget);
  }

}
