import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  
  connect() {
    setTimeout(() => {
        window.location.href = "http://localhost:3000";
    }, 5000);
  }
  
}
