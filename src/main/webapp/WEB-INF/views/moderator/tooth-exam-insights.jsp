<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tooth Examination Insights</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h1>Tooth Examination Insights (Test)</h1>
    <pre id="jsonDebug">${mostCommonToothConditionsJson}</pre>
    <canvas id="toothConditionChart" width="400" height="200"></canvas>
    <script>
        // Confirm script is running
        console.log('Script loaded');

        // Get the JSON string from the <pre> block
        const rawJson = document.getElementById('jsonDebug').textContent;
        console.log('Raw JSON:', rawJson);

        let mostCommonToothConditions;
        try {
            mostCommonToothConditions = JSON.parse(rawJson);
            console.log('Parsed:', mostCommonToothConditions);
        } catch (e) {
            console.error('JSON parse error:', e);
        }

        if (Array.isArray(mostCommonToothConditions)) {
            const labels = mostCommonToothConditions.map(e => e.key);
            const data = mostCommonToothConditions.map(e => e.value);

            new Chart(document.getElementById('toothConditionChart'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Count',
                        data: data,
                        backgroundColor: '#6366f1'
                    }]
                },
                options: {
                    plugins: { legend: { display: false } },
                    responsive: true
                }
            });
        }
    </script>
</body>
</html>
