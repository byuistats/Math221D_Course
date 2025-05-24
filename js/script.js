// script.js

document.addEventListener('DOMContentLoaded', () => { // Wait for the DOM to load

  const inputElement = document.getElementById('numberInput'); // Assuming you have <input id="numberInput">
  const graphContainer = document.getElementById('graphContainer'); // Where the graph will go

  inputElement.addEventListener('input', () => { // React to input changes
    const inputValue = parseFloat(inputElement.value);

    if (!isNaN(inputValue)) {
      generateGraph(inputValue); // Call the function to create the graph
    } else {
      // Handle invalid input (e.g., clear the graph, display an error)
      graphContainer.innerHTML = "<p>Please enter a valid number.</p>";
    }
  });

  function generateGraph(number) {
    // Example using Chart.js (replace with your chosen library)

    // First, clear any existing chart (important for updates)
    if (window.myChart) { // Check if a chart instance exists
      window.myChart.destroy(); // Destroy the old chart
    }

    const ctx = graphContainer.getContext('2d'); // Get the canvas context

    // Sample Data (modify based on your desired graph)
    const labels = ['A', 'B', 'C', 'D'];
    const data = [number, number * 0.5, number * 0.8, number * 1.2]; // Example: data related to the input

    window.myChart = new Chart(ctx, {  // Assign to window.myChart to make it globally accessible
      type: 'bar', // Or 'line', 'pie', etc.
      data: {
        labels: labels,
        datasets: [{
          label: 'Data based on Input',
          data: data,
          backgroundColor: 'rgba(54, 162, 235, 0.5)', // Example color
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });
  }
});