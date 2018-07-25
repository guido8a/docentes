<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gráficos</title>
    <script src="${resource(dir: 'js', file: 'Chart.js')}"></script>
    <style type="text/css">

    .grafico{
        border-style: solid;
        border-color: #606060;
        border-width: 1px;
        width: 48%;
        float: left;
        text-align: center;
        height: 440px;
        border-radius: 8px;
        margin: 10px;
    }
    .bajo {
        margin-bottom: 20px;
    }

    </style>
</head>

<body>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">
    <div class="col-md-1"></div>
    <div class="col-md-2">Seleccione el periodo de evaluaciones:</div>

    <div class="col-sm-1"><g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                    class="form-control" style="width: 90px"
                                    from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
    </div>

    <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

    <div class="col-md-4">
        <g:select from="${docentes.Facultad.list([sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                  optionKey="id" name="facultad_name" id="facultad" class="form-control"
                  noSelection="${[0:'Todas ...']}"/>
    </div>
    <div class="col-md-2">
        <div class="btn btn-info" id="graficar">
            <i class="fa fa-pie-chart"></i> Aceptar
        </div>
    </div>

</div>

<div class="chart-container grafico" id="chart-area" hidden>
    <h3 id="titulo"></h3>
    <div id="graf">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

    <div style="margin-top: 20px">
        <g:link action="reportesGraf" class="btn btn-info">
            <i class="fa fa-line-chart"></i> Imprimir
        </g:link>
    </div>
</div>

<div class="chart-container grafico" id="chart-area2" hidden>
    <h3 id="titulo2"></h3>
    <div id="graf2">
        <canvas id="clases2" style="margin-top: 30px"></canvas>
    </div>

    <div style="margin-top: 20px">
        <g:link action="reportesGraf" class="btn btn-info">
            <i class="fa fa-line-chart"></i> Imprimir
        </g:link>
    </div>
</div>

<script type="text/javascript">

    var canvas = $("#clases");
    var myChart;

    $("#graficar").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        console.log("carrga gráfico")
        %{--location.href = "${createLink(controller: 'reportesGraf', action: 'clasificar')}?periodo=" + prdo + "&facultad=" + facl;--}%
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'clasificar')}',
            data: {facl: facl, prdo: prdo},
            success: function (msg) {
                var valores = msg.split("_")
                $("#titulo").html(valores[3])
                $("#titulo2").html(valores[6])
                $("#clases").remove();
                $("#clases2").remove();
                $("#chart-area").removeAttr('hidden')
                $("#chart-area2").removeAttr('hidden')

                /* se crea dinámicamente el canvas y la función "click" */
                $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');
                $('#graf2').append('<canvas id="clases2" style="margin-top: 30px"></canvas>');
                $("#clases").off();
                $('#clases').on('click', function(evt) {
                    var activePoint = myChart.getElementAtEvent(evt)[0];
                    var data = activePoint._chart.data;
                    var datasetIndex = activePoint._datasetIndex;
                    var label = data.datasets[datasetIndex].label[activePoint._index];
                    var value = data.datasets[datasetIndex].data[activePoint._index];
                    console.log("indice:", datasetIndex, "etiqueta:",label, "valor:", value);
                });

                canvas = $("#clases")
                console.log("ok", valores[0])
                var chartData = {
                    type: 'pie',
                    data: {
                        labels: ['Clase A', 'Clase B', 'Clase C'],
                        datasets: [
                            {
                                label: ["A", "B", "C"],
                                backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                borderWidth: [3,3,3],
                                data: [valores[0], valores[1], valores[2]]
                            }
                        ]
                    },
                    options: {
                        legend: { display: true }
                    }
                }
                var chartDataRc = {
                    type: 'pie',
                    data: {
                        labels: ['Con recomendaciones', 'Sin recomendaciones'],
                        datasets: [
                            {
                                label: ["R", "N"],
                                backgroundColor: ['#009608', '#cc2902'],
                                borderColor: ['#40d648', '#fc6942'],
                                borderWidth: [3,3],
                                data: [valores[4], valores[5]]
                            }
                        ]
                    },
                    options: {
                        legend: { display: true }
                    }
                }
                myChart = new Chart(canvas, chartData, 1);
                myChart2 = new Chart($("#clases2"), chartDataRc, 1);

            }
        });
    });

</script>


</body>
</html>