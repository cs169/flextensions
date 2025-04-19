document.addEventListener("DOMContentLoaded", () => {
    const switches = document.querySelectorAll(".assignment-enabled-switch");
  
    switches.forEach((checkbox) => {
      checkbox.addEventListener("change", async (event) => {
        const assignmentId = checkbox.dataset.assignmentId;
        const url = checkbox.dataset.url;
        const enabled = checkbox.checked;
  
        try {
          const token = document.querySelector('meta[name="csrf-token"]').content;
  
          const response = await fetch(url, {
            method: "PATCH",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": token,
            },
            body: JSON.stringify({ enabled: enabled }),
          });
          
          const data = await response.json();
          
          if (!response.ok) {
            // If the server returned a redirect URL, navigate to it to display the flash message
            if (data.redirect_to) {
              window.location.href = data.redirect_to;
              return;
            }
            throw new Error(data.error || 'Error updating assignment');
          }
  
          console.log(`Assignment ${assignmentId} enabled: ${enabled}`);
        } catch (error) {
          console.error("Error updating assignment:", error);
          checkbox.checked = !enabled; // rollback checkbox if error
        }
      });
    });
  });
  