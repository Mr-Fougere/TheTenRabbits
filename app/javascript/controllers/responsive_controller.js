import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./seek";

export default class extends Controller {

  toggle(){
    seekRabbit(this.element);
  }
}
