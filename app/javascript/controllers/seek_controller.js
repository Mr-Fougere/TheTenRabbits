import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./application";

export default class extends Controller {
  
  connect() {
    this.sessionUUID = this.element.dataset.session
    window.debbie = () => {
      console.log("{\\__/}\n( •.•)\n/ >< \\");
      console.log("You found me !");
      seekRabbit(this.element);
    };
  }
  
}
