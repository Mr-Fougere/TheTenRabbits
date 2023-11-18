// Modifiez votre fichier Stimulus
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "previewImage","filePreview"];

  connect() {
    this.element.addEventListener("dragover", this.handleDragOver.bind(this));
    this.element.addEventListener("drop", this.handleDrop.bind(this));
  }

  handleDragOver(event) {
    event.preventDefault();
  }

  handleDrop(event) {
    if(event.currentTarget != this.filePreviewTarget) return;
    
    event.preventDefault();

    const files = event.dataTransfer.files;
    if (files.length > 0) {
      this.showPreview(files[0]);
      this.uploadFile(files[0]);
    }
  }

  showPreview(file) {
    const reader = new FileReader();

    reader.onload = (e) => {
      this.previewImageTarget.src = e.target.result;
    };

    reader.readAsDataURL(file);
  }

  uploadFile(file) {
    const formData = new FormData();
    formData.append("session_uuid", this.element.dataset.sessionUuid);
    formData.append("file", file);

    fetch("/carrot_recognizer", {
      method: "POST",
      body: formData,
    })
  }
}
