document.addEventListener("DOMContentLoaded", () => {
    const switches = document.querySelectorAll(".toggle-enabled-switch");
  
    switches.forEach((checkbox) => {
      checkbox.addEventListener("change", async (event) => {
        const assignmentId = checkbox.dataset.assignmentId;
        const url = checkbox.dataset.url;
        const enabled = checkbox.checked;
  
        try {
          const token = document.querySelector('meta[name="csrf-token"]').content;
  
          await fetch(url, {
            method: "PATCH",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": token,
            },
            body: JSON.stringify({ enabled: enabled }),
          });
  
          console.log(`Assignment ${assignmentId} enabled: ${enabled}`);
        } catch (error) {
          console.error("Error updating assignment:", error);
          checkbox.checked = !enabled; // rollback checkbox if error
        }
      });
    });
  });
  