$(document).ready(function () {
  if ($('#reports-page').length) {
    var recruitmentData = $('#reports-page').data('recruitment');
    console.log(recruitmentData);
    var orgData;
    var orgName;
    var chartData;
    var chartConfig;
    var color = Chart.helpers.color;
    var gray = color(window.chartColors.gray).alpha(0.15).rgbString();
    [1, 2, 3].forEach(function (orgId) {
      orgData = recruitmentData[orgId - 1];
      console.log(orgData);
      orgName = orgData['org_name'];
      chartData = orgData['chart_data'];
      chartConfig = {
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
              data: chartData
            }
          ]
        },
        options: {
          responsive: true,
          aspectRatio: 1.5,
          title: {
            display: true,
            text: orgName,
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
                max: Date(),
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
                max: 30,
                fontSize: '16'
              }

            }]
          }
        }
      };
      if (orgId == 1) {
        window.chart1 = new Chart('chart-1', chartConfig);
      } else if (orgId == 2){
        window.chart2 = new Chart('chart-2', chartConfig);
      } else {
        window.chart3 = new Chart('chart-3', chartConfig);
      }
    })

  };

});

    //   $('#enrolled-header').click(function () {
    //     $('#enrolled-content').toggle();
    //     $('.enrolled-collapse').toggleClass('hidden');
    //     $('#enrolled-header').toggleClass('bottom-radii');
    //   })