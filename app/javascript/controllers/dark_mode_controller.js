import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./seek_controller";

export default class extends Controller {
    
  toggle(event){
    seekRabbit(event.currentTarget);
  }

}
