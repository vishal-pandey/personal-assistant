document.addEventListener('DOMContentLoaded', () => {
  const infoBtn = document.getElementById('infoBtn');
  const modal = document.getElementById('modal');
  const closeModalBtn = document.getElementById('closeModalBtn');
  const saveModalBtn = document.getElementById('saveModalBtn');
  const queryInput = document.getElementById('queryInput');
  const submitQueryBtn = document.getElementById('submitQueryBtn');
  const queryResponse = document.getElementById('queryResponse');
  const summaryBtns = document.querySelectorAll('.summary-btn');
  const summaryText = document.getElementById('summaryText');

  // Open modal
  infoBtn.addEventListener('click', () => {
    modal.style.display = 'flex';
  });

  // Close modal
  closeModalBtn.addEventListener('click', () => {
    modal.style.display = 'none';
  });

  // Save customization
  saveModalBtn.addEventListener('click', () => {
    const customPrompt = document.getElementById('customPrompt').value;
    alert(`Customization saved: ${customPrompt}`);
    modal.style.display = 'none';
  });

  // Handle summary range selection
  summaryBtns.forEach((btn) => {
    btn.addEventListener('click', () => {
      summaryBtns.forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');

      const range = btn.getAttribute('data-range');
      switch (range) {
        case '3':
          summaryText.textContent = 'Last 3 days: 25 emails received.';
          break;
        case '7':
          summaryText.textContent = 'Last 1 week: 50 emails received.';
          break;
        case '30':
          summaryText.textContent = 'Last 1 month: 150 emails received.';
          break;
      }
    });
  });

  // Submit query
  submitQueryBtn.addEventListener('click', () => {
    const query = queryInput.value.trim();
    if (query) {
      queryResponse.textContent = `You asked: "${query}" - Processing response...`;
    } else {
      queryResponse.textContent = "Please enter a query.";
    }
  });
});
