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
        width: 100%;
        float: left;
        text-align: center;
        height: 720px;
        border-radius: 8px;
        margin: 10px;
    }
    .bajo {
        margin-bottom: 20px;
    }
        .centrado{
            text-align: center;
        }

    </style>
</head>

<body>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">
    %{--<div class="col-md-1"></div>--}%
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
    <div class="col-md-3">
        <div class="btn btn-info" id="graficar">
            <i class="fa fa-pie-chart"></i> Polígono
        </div>
        <div class="btn btn-info" id="grafPolar" style="margin-left: 2px">
            <i class="fa fa-pie-chart"></i> Polar
        </div>
    </div>


</div>

<div class="chart-container grafico" id="chart-area" hidden>
    <h1>Desempeño General</h1>
    <h3 id="titulo"></h3>
    <div id="graf">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

</div>

%{--
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

--}%
<script type="text/javascript">

    var canvas = $("#clases");
    var myChart;

    $("#graficar").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
//        console.log("carrga gráfico");
        %{--location.href = "${createLink(controller: 'reportesGraf', action: 'clasificar')}?periodo=" + prdo + "&facultad=" + facl;--}%
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'estrategiaData')}',
            data: {facl: facl, prdo: prdo},
            success: function (json) {
//                console.log("json:", json)

                $("#titulo").html(json.facultad)
                $("#clases").remove();
                $("#chart-area").removeAttr('hidden')

                /* se crea dinámicamente el canvas y la función "click" */
                $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

                canvas = $("#clases")

                var chartData = {
                    type: 'radar',
                    data: {
                        labels: ['Evaluación Total', 'Potenciadores', 'Factores de Éxito', 'Cuellos de Botella', 'Recomendaciones'],
                        datasets: [
                            {   label: ["Porcentajes"],
                                backgroundColor: "rgba(255,150,0,0.3)",
                                borderWidth: 1,
                                data: [100,100,100,100,100] },
                            {   label: ["Desempeño porcentual"],
                                backgroundColor: "rgba(0,255,0,0.2)",
                                borderColor: "rgba(0,160,80, 0.3)",
                                borderWidth: 4,
                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] }
                        ]

                    },
                    options: {
                        legend: { display: true }
                    }
                };

                myChart = new Chart(canvas, chartData, 1);
            }
        });
    });

    $("#grafPolar").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
//        console.log("carrga gráfico");
        %{--location.href = "${createLink(controller: 'reportesGraf', action: 'clasificar')}?periodo=" + prdo + "&facultad=" + facl;--}%
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'estrategiaData')}',
            data: {facl: facl, prdo: prdo},
            success: function (json) {
//                console.log("json:", json)

                $("#titulo").html(json.facultad)
                $("#clases").remove();
                $("#chart-area").removeAttr('hidden')

                /* se crea dinámicamente el canvas y la función "click" */
                $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

                canvas = $("#clases")

                var chartData = {
                    type: 'polarArea',
                    data: {
                        labels: ['Evaluación Total', 'Potenciadores', 'Factores de Éxito', 'Cuellos de Botella', 'Recomendaciones'],
                        datasets: [
/*
                            {   label: ["Porcentajes"],
                                backgroundColor: "rgba(255,150,0,0.3)",
                                borderWidth: 1,
                                data: [100,100,100,100,100] },
*/
                            {   label: ["Desempeño porcentual"],
                                backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
//                                borderColor: "rgba(0,160,80, 0.3)",
//                                borderWidth: 4,
                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] }
                        ]

                    },
                    options: {
                        legend: { display: true }
                    }
                };

                myChart = new Chart(canvas, chartData, 1);
            }
        });
    });


</script>


</body>
</html>