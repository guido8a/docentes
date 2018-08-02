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
        text-align: center;
        width: 70%;
        height: auto;
        border-radius: 8px;
        margin: 10px;
        margin-right: auto;
        margin-left: auto;
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
<div align="center">
    <h1>Desempeño por Tipo de Encuesta</h1>
</div>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">

    <div class="col-md-1"></div>
    <div class="col-md-2">Seleccione el periodo de evaluaciones:</div>

    <div class="col-sm-1"><g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                    class="form-control" style="width: 90px"
                                    from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
    </div>

    <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

    <div class="col-md-2">
        <div class="btn btn-info tipoEncuesta" id="tpenBarras">
            <i class="fa fa-bar-chart"></i> Diagrama de Barras
        </div>
    </div>

    <div class="col-md-2">
        <div class="btn btn-info tipoEncuesta" id="tpenPila" style="margin-left: 20px">
            <i class="fa fa-bar-chart"></i> Barras apiladas
        </div>
    </div>

</div>

<div style="width: 100%; text-align: center">
<div class="chart-container grafico" id="chart-area" hidden>

   <div id="graf" align="center">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

</div>
</div>

<script type="text/javascript">

    var canvas = $("#clases");
    var myChart;

    $(".tipoEncuesta").click(function () {
        var id = this.id
//        console.log("id:", id)
        var prdo = $("#periodoId").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'tipoEncuestaData')}',
            data: {prdo: prdo},
            success: function (mnsj) {
                var resp = mnsj.split('||')  /* se envia facultades y el JSON */
                var facl = resp[0].split('_')
                var json = $.parseJSON(resp[1])
//                console.log("json:", json)

                $("#clases").remove();
                $("#chart-area").removeAttr('hidden')
                $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

                canvas = $("#clases")
                var colores = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9"]
                var datos = []
                var facultades = "<ul>"
                var leyenda = []
                var vlor
                var indice = 0
                $.each(json, function (key, val) {
//                    console.log("key:", key, "val:", val)
                    vlor = val.valor.split("_")
//                    console.log("valor:", vlor)
                    datos.push({
                        label: val.tpen,
                        backgroundColor: colores[indice],
                        borderWidth: 2,
                        data: vlor
                    })
                    indice++
                });
                $.each(facl, function (key, val) {
//                    console.log("val:", val)
                    facultades += "<li>Facult. " + key + ": " + val + "</li>"
                    leyenda.push("Facult. " + key)
                });
                facultades += "</ul>"

//                console.log("facultades:", facultades)
                var optionsBarra = {
                    leyend: { display: true},
                }

                var optionsPila = {
                    leyend: { display: true},
                    scales: {
                        xAxes: [{ stacked: true }],
                        yAxes: [{ stacked: true }]
                    }
                }

                if(id === 'tpenBarras') {
                    grafica('bar', leyenda, datos, optionsBarra, canvas)
                } else {
                    grafica('bar', leyenda, datos, optionsPila, canvas)
                }

                $("#divFacl").remove();
                $('#chart-area').append('<div id="divFacl" style="margin-top: 30px; text-align: left">' + facultades + '</div>');
            }
        });
    });

    function grafica(tipo, leyenda, datos, options, canvas) {
        var chartData = {
            type: tipo,
            data: {
                labels: leyenda,
                datasets: datos
            },
            options: options
        };
        myChart = new Chart(canvas, chartData, 1);
    }

</script>


</body>
</html>