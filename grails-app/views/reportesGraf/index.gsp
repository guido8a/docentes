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
        width: 49%;
        float: left;
        text-align: center;
        height: 440px;
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

<div class="chart-container grafico">
    <h3 id="titulo"></h3>
    <canvas id="clases" style="margin-top: 30px"></canvas>
    <div style="margin-top: 20px">
        <g:link action="reportesGraf" class="btn btn-info">
            <i class="fa fa-line-chart"></i> Imprimir
        </g:link>
    </div>
</div>

<script type="text/javascript">

    var canvas = document.getElementById('clases');
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
                console.log("ok", valores[0])
                var chartData = {
                    type: 'pie',
                    data: {
                        labels: ['Clase A:' + valores[0], 'Clase B:' + valores[1], 'Clase C:' + valores[2]],
                        datasets: [
                            {
                                label: ["P1", "psss", "ooo"],
                                backgroundColor: ['#009608', '#ffa900', '#cc2902'],
//                    borderColor: ['#006600', '#cf7900', '#8c0000'],
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
                myChart = new Chart(canvas, chartData);
            }
        });
    });



    canvas.onclick = function(evt) {
        var activePoint = myChart.getElementAtEvent(evt)[0];
        var data = activePoint._chart.data;
        var datasetIndex = activePoint._datasetIndex;
        var label = data.datasets[datasetIndex].label;
        var value = data.datasets[datasetIndex].data[activePoint._index];
        console.log("indice", datasetIndex, "etiqueta",label, value);
    };

</script>


</body>
</html>