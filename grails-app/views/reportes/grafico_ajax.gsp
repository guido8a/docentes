<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 21/12/18
  Time: 10:11
--%>

<div class="chart-container grafico" id="chart-area">
    <div id="graf">
        <canvas id="nuevoGrafico" ></canvas>
        <script type="text/javascript">
            graficar($("#nuevoGrafico"), "${prof[0]}", "${prof[1]}", ${minimo}, ${optimo}, false);
        </script>
    </div>
</div>

<script type="text/javascript">

    function graficar(area, serie1, serie2, vlmn, vlop, etqt) {
        var canvas = area;
        var myChart;
        var data1 = serie1.split("_");
        var data2 = serie2.split("_");
        var vl = parseInt(vlmn)
        var op = parseInt(vlop)
        var minimo = [vl, vl, vl, vl, vl, vl]
        var optimo = [op, op, op, op, op, op]
//        console.log("mn", minimo, 'op:', optimo)
        var chartData = {
            type: 'radar',
            data: {
                labels: ['IC', 'DAC', 'DHA', 'IF', 'NI', 'EA'],
                datasets: [
                    {
                        label: ["Autoevaluación"],
                        fill: true,
                        backgroundColor: "rgba(80,140,198,0.2)",
                        borderColor: "rgba(60,120,198,1)",
                        pointBorderColor: "#fff",
                        pointBackgroundColor: "rgba(179,181,198,1)",
                        data: data2
                    },
                    {
                        label: ["Heteroevaluación"],
                        backgroundColor: "rgba(255,99,132,0.2)",
                        borderColor: "rgba(255,99,132,1)",
                        pointBorderColor: "#fff",
                        pointBackgroundColor: "rgba(255,99,132,1)",
                        pointBorderColor: "#fff",
//                        data: [68.77,75.61,90.69,96.62,86.82, 95]
                        data: data1
                    },
                    {   label: ["Mínimo"],
                        backgroundColor: "rgba(255,240,240,0.2)",
                        borderColor: "rgba(200,40,40, 0.3)",
                        borderWidth: 2,
                        data: minimo},
                    {   label: ["Óptimo"],
                        backgroundColor: "rgba(240,240,255,0.2)",
                        borderColor: "rgba(0,0,200, 0.2)",
                        borderWidth: 2,
                        data: optimo}
                ]

            },
            options: {
                legend: {
                    display: etqt,
                    labels: {
                        fontColor: 'rgb(20, 80, 100)',
                        fontSize: 14
                    }
                },
                scale: {
                    ticks: {
                        beginAtZero: true,
                        min: 0,
                        max: 100,
                        stepSize: 20
                    }
                }

            }
        }

        myChart = new Chart(canvas, chartData, 1);
    }


</script>