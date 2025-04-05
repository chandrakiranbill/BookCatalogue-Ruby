document.addEventListener('DOMContentLoaded', function() {
  // Handle success notification
  const successNotification = document.querySelector('.success-notification');
  
  if (successNotification) {
    // Auto hide notification after 3 seconds
    setTimeout(() => {
      successNotification.style.opacity = '0';
      successNotification.style.transform = 'translateX(100%)';
      setTimeout(() => {
        successNotification.remove();
      }, 300);
    }, 3000);
  }

  // Make table rows clickable
  const rows = document.querySelectorAll('tbody tr');
  rows.forEach(row => {
    row.addEventListener('click', (e) => {
      // Skip if clicked on remove button
      if (e.target.classList.contains('remove-btn') || e.target.closest('.remove-btn')) {
        return;
      }
      
      // TODO: Implement row click action if needed
    });
  });
});
