$(document).ready(function () {
  if ($('#dashboard').length) {

    $('#enrolled-header').click(function () {
      $('#enrolled-content').toggle();
      $('.enrolled-collapse').toggleClass('hidden');
      $('#enrolled-header').toggleClass('bottom-radii');
    })

    $('#screened-header').click(function () {
      $('#screened-content').toggle();
      $('.screened-collapse').toggleClass('hidden');
      $('#screened-header').toggleClass('bottom-radii');
    })

    $('#summary-header').click(function () {
      $('#summary-content').toggle();
      $('.summary-collapse').toggleClass('hidden');
      $('#summary-header').toggleClass('bottom-radii');
    })

    var chartData = $('#dashboard').data('chart');
    console.log(chartData);
    var color = Chart.helpers.color;
    var gray = color(window.chartColors.gray).alpha(0.15).rgbString();
    var darkGray = color(window.chartColors.gray).alpha(0.5).rgbString();
    var chartConfig = {
      type: 'line',
      data: {
        datasets: [
          {
            label: 'Enrolled participants',
            lineTension: 0,
            backgroundColor: gray,
            borderColor: gray,
            fill: true,
            pointBackgroundColor: gray,
            pointBorderColor: gray,
            pointRadius: '4',
            data: chartData.series1
          }
        ]
      },
      options: {
        responsive: true,
        aspectRatio: 1.5,
        title: {
          display: true,
          text: 'Participant Accrual',
          fontSize: '22'
        },
        legend: {
          display: false,
        },
        scales: {
          xAxes: [{
            type: 'time',
            time: {
              unit: 'day'
            },
            display: true,
            ticks: {
              fontSize: '13'
            }
          }],
          yAxes: [{
            display: true,
            scaleLabel: {
              display: true,
              labelString: 'Total Enrolled',
              fontSize: '20',
            },
            ticks: {
              fontSize: '16'
            }

          }]
        }
      }
    };
    var accrualChart = $('#accrual-chart');
    window.accrual = new Chart(accrualChart, chartConfig);

  };

});
