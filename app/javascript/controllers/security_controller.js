import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  
  connect() {
    setTimeout(() => {
        window.location.href = "https://the-ten-rabbits-770a3f6488e7.herokuapp.com";
    }, 5000);
  }
  
}
