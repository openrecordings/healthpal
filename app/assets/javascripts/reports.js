$(document).ready(function () {
  if ($('#reports-page').length) {

    $('.table-title').click(function () {
      let table = $(this).closest('.table-type-container').find('.expandable').first();
      let icons = $(this).closest('.table-type-container').find('.expand-icon').slice(0, 2);
      table.toggleClass('hidden');
      icons.toggleClass('hidden');
    })

    var recruitmentData = $('#reports-page').data('recruitment');
    console.log(recruitmentData);
    var orgData;
    var orgName;
    var chartData;
    var chartConfig;
    var color = Chart.helpers.color;
    var gray = color(window.chartColors.gray).alpha(0.15).rgbString();
    [1, 2, 3, 4].forEach(function (orgId) {
      orgData = recruitmentData[orgId - 1];
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
          aspectRatio: 1.7,
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
                max: orgId == 1 ? 90 : 30,
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
      } else if (orgId == 3){
        window.chart3 = new Chart('chart-3', chartConfig);
      } else {
        window.chart4 = new Chart('chart-4', chartConfig);
      }
    })

  };

});

    //   $('#enrolled-header').click(function () {
    //     $('#enrolled-content').toggle();
    //     $('.enrolled-collapse').toggleClass('hidden');
    //     $('#enrolled-header').toggleClass('bottom-radii');
    //   })