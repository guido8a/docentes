<div class="row-fluid" style="width: 99.7%;height: 450px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1060px; height: 450px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${prof}" var="profesor" status="j">
                    <tr data-id="${profesor.id}">
                        <td style="width: 20%">${profesor?.nombre + " " + profesor?.apellido}</td>
                        <td style="width: 20%">${profesor?.apellido}</td>
                        <td style="width: 5%; font-size: 11px">prll</td>
                        <td style="width: 55%; text-align: center">
                            <div class="chart-container grafico" id="chart-area">
                                <div id="graf">
                                    <canvas id="clases_${j}" style="margin-top: 30px"></canvas>
                                </div>
                            </div>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    graficar()

    var canvas = $("#clases_0");
    var myChart;

    function graficar() {

//        $("#titulo").html(json.facultad)
//        $("#clases").remove();

        /* se crea dinámicamente el canvas y la función "click" */
//        $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

        canvas = $("#clases_0");

        var chartData = {
            type: 'radar',
            data: {
                labels: ['Evaluación Total', 'Potenciadores', 'Factores de Éxito', 'Cuellos de Botella', 'Recomendaciones'],
                datasets: [
                    {
                        label: ["Porcentajes"],
                        backgroundColor: "rgba(255,255,255,0.05)",
                        borderWidth: 1,
                        data: [100, 100, 100, 100, 100]
                    },
/*
                    {
                        label: ["Potenciadores"],
                        backgroundColor: "rgba(120,255,120,0.4)",
                        borderColor: "rgba(60,160,120, 0.5)",
                        borderWidth: 4,
                        data: [json.promedio, json.ptnv, json.fcex, 0, 0]
                    },
                    {
                        label: ["Limitantes"],
                        backgroundColor: "rgba(255,120,0,0.4)",
                        borderColor: "rgba(255,120,0, 0.5)",
                        borderWidth: 4,
                        data: [json.promedio, 0, 0, json.ccbb, json.rcmn]
                    },
                    {
                        label: ["Mínimo"],
                        backgroundColor: "rgba(255,240,240,0.2)",
                        borderColor: "rgba(200,40,40, 0.3)",
                        borderWidth: 2,
                        data: [40, 40, 40, 40, 40]
                    },
*/
                    {
                        label: ["Óptimo"],
                        backgroundColor: "rgba(240,240,255,0.2)",
                        borderColor: "rgba(0,0,200, 0.2)",
                        borderWidth: 2,
                        data: [80, 80, 80, 80, 80]
                    }
                ]

            },
            options: {
                legend: {
                    display: false,
                    labels: {
                        fontColor: 'rgb(20, 80, 100)',
                        fontSize: 14,

                    }
                }

            }
        }

        myChart = new Chart(canvas, chartData, 1);
    }

</script>