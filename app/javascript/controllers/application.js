import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

window.ondragstart = function () {
  return false;
};

export function seekRabbit(element) {
  if (!element.dataset.key && !element.dataset.uuid) return;
  const requestData = {
    rabbit_key: element.dataset.key,
    rabbit_uuid: element.dataset.uuid,
  };

  return fetch("/seek_rabbit", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestData),
  });
}
