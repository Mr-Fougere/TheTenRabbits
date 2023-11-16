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