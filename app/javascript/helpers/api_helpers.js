export function getCsrfToken() {
  return document.querySelector('meta[name="csrf-token"]').content;
}

export function syncResource(courseId, endpoint, successMessage, errorMessage) {
  const token = getCsrfToken();
  
  return fetch(`/courses/${courseId}/${endpoint}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": token,
    },
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error(errorMessage || `Failed to sync ${endpoint}.`);
      }
      return response.json();
    })
    .then((data) => {
      window.flash("notice", data.message || successMessage || `${endpoint} synced successfully.`);
      location.reload();
    })
    .catch((error) => {
      window.flash("alert", error.message || `An error occurred while syncing ${endpoint}.`);
      location.reload();
    });
} 