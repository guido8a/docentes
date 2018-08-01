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
        height: 700px;
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
    <div class="col-md-1"></div>
    <div class="col-md-2">Seleccione el periodo de evaluaciones:</div>

    <div class="col-sm-1"><g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                    class="form-control" style="width: 90px"
                                    from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
    </div>

    <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

    <div class="col-md-2">
        <div class="btn btn-info" id="variables">
            <i class="fa fa-bar-chart"></i> Promedios por variables
        </div>
    </div>

    <div class="col-md-2">
        <div class="btn btn-info" id="tpen" style="margin-left: 20px">
            <i class="fa fa-line-chart"></i> Promedios por tipo de evaluación
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

    $("#variables").click(function () {
        var prdo = $("#periodoId").val();
//        console.log("carrga gráfico");
        %{--location.href = "${createLink(controller: 'reportesGraf', action: 'clasificar')}?periodo=" + prdo + "&facultad=" + facl;--}%
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'resultadosData')}',
            data: {prdo: prdo},
            success: function (json) {
                console.log("json:", json)
                console.log("json:", json)

                $("#titulo").html(json.facultad)
                $("#clases").remove();
                $("#chart-area").removeAttr('hidden')

                /* se crea dinámicamente el canvas y la función "click" */
                $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');
                $('#graf2').append('<canvas id="clases2" style="margin-top: 30px"></canvas>');

                canvas = $("#clases")
                var i = json.cnta
                var facl = json.facl.split("_")

                /* cambiar el tipo de gráfico a stack */
                var chartData = {
                    type: 'bar',
                    data: {
                        labels: ["facl1", "facl2", "facl3", "facl4", "facl5", "facl6"],
                        datasets: [
                            {   label: "variable 1",
                                backgroundColor: "#3e95cd",
                                borderWidth: 2,
                                data: [100,10,30,100,10, 10] },
                            {   label: "variable 2",
                                backgroundColor: "#8e5ea2",
                                borderWidth: 2,
                                data: [12,25,10,23,26,45] },
                            {   label: "variable 3",
                                backgroundColor: "#3cba9f",
                                borderWidth: 2,
                                data: [12,25,15,23,26,45] },
                            {   label: "variable 4",
                                backgroundColor: "#e8c3b9",
                                borderWidth: 2,
                                data: [12,25,30,23,26,45] },
                            {   label: "variable 5",
                                backgroundColor: "#c45850",
                                borderWidth: 2,
                                data: [12,22,13,23,26,45] },
                            {   label: "variable 6",
                                backgroundColor: "#3e9540",
                                borderWidth: 2,
                                data: [12,21,18,23,26,45] }
                        ]

                    },
                    options: {
                        legend: { display: true },
/*
                        scales: {
                            xAxes: [{ stacked: true }],
                            yAxes: [{ stacked: true }]
                        }
*/

                    }
                };

                /* pasar esto desde el grails con JSON para hacer datasets: data_enviada */
                var datos = [
                    {   label: "variable 1",
                        backgroundColor: "#3e95cd",
                        borderWidth: 2,
                        data: [100,10,30,100,10, 10] },
                    {   label: "variable 2",
                        backgroundColor: "#8e5ea2",
                        borderWidth: 2,
                        data: [12,25,10,23,26,45] },
                    {   label: "variable 3",
                        backgroundColor: "#3cba9f",
                        borderWidth: 2,
                        data: [12,25,15,23,26,45] },
                    {   label: "variable 4",
                        backgroundColor: "#e8c3b9",
                        borderWidth: 2,
                        data: [12,25,30,23,26,45] },
                    {   label: "variable 5",
                        backgroundColor: "#c45850",
                        borderWidth: 2,
                        data: [12,22,13,23,26,45] },
                    {   label: "variable 6",
                        backgroundColor: "#3e9540",
                        borderWidth: 2,
                        data: [12,21,18,23,26,45] }
                ]


                console.log("dataset:", datos)
                myChart = new Chart(canvas, chartData, 1);
            }
        });
    });


</script>


</body>
</html>