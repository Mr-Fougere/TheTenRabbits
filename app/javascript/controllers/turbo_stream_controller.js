import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const observer = new MutationObserver((e) => {
        const connection_state = e[0].target.attributes["connected"] !== undefined 
        if (connection_state) {
          this.hideCache()
        } else {
          this.showCache()
        }
      })
      
      const element = document.querySelector("turbo-cable-stream-source")
      observer.observe(element, { attributeFilter: ["connected"] })
  }

  hideCache() {
    this.element.classList.add("connected");
  }

  showCache() {
    this.element.classList.remove("connected");
  }
}
