<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Variables</title>
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
    <h1>Desempeño por Variables</h1>
</div>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">

    <div class="col-md-1"></div>

    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-md-1">Universidad:</div>
        <div class="col-sm-3">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 280px"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
        <div class="col-md-1">Período:</div>
        <div class="col-sm-1" id="divPeriodos">

        </div>

        <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

        <div class="col-md-3" id="divFacultad">

        </div>
    </g:if>
    <g:else>
        <div class="col-md-1">Período:</div>
        <div class="col-sm-1">
            <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 90px"
                      from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>
        </div>

        <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

        <div class="col-md-4">
            <g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                      optionKey="id" name="facultad_name" id="facultad" class="form-control"
            />
        </div>
    </g:else>

</div>

<div class="col-md-4"></div>

<div class="col-md-2">
    <div class="btn btn-info grafFacultad" id="tpenBarras">
        <i class="fa fa-bar-chart"></i> Diagrama de Barras
    </div>
</div>

<div class="col-md-2">
    <div class="btn btn-info grafFacultad" id="tpenPila" style="margin-left: 20px">
        <i class="fa fa-bar-chart"></i> Barras apiladas
    </div>
</div>

<div style="width: 100%; text-align: center; margin-top: 70px">
<div class="chart-container grafico" id="chart-area" hidden>

   <div id="graf" align="center">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

</div>
</div>

<script type="text/javascript">

//    cargarPeriodo($("#universidadId").val());
//    cargarFacultad($("#universidadId").val());

    $(function () {
        $(document).ready(function () {
                var id = $("#universidadId option:selected").val();
                cargarPeriodo(id);
                cargarFacultad(id);
        });
    });

    $("#universidadId").change(function () {
        var id = $("#universidadId option:selected").val();
        cargarPeriodo(id);
        cargarFacultad(id);
    });

    function cargarPeriodo(id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'periodo_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divPeriodos").html(msg)
            }
        });
    }


    function cargarFacultad (id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'facultad_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }

    var canvas = $("#clases");
    var myChart;

    $(".grafFacultad").click(function () {
        var id = this.id
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();

        if(facultad != null){
            $("#chart-area").removeClass('hidden');
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportesGraf', action: 'variablesData')}',
                data: {prdo: prdo, facl: facultad},
                success: function (mnsj) {
                    var resp = mnsj.split('||')  /* se envia facultades y el JSON */
                    var facl = resp[0].split('_')
                    var json = $.parseJSON(resp[1])
//                console.log("json:", json)

                    $("#clases").remove();
                    $("#chart-area").removeAttr('hidden')
                    $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

                    canvas = $("#clases")
                    var colores = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#800000", "#808000"]
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
                            label: val.vrbl,
                            backgroundColor: colores[indice],
                            borderWidth: 2,
                            data: vlor
                        });
                        indice++
                    });
                    $.each(facl, function (key, val) {
//                    console.log("val:", val)
                        facultades += "<li>Carrera " + (key + 1) + ": " + val + "</li>";
                        leyenda.push("Carrera " + (key + 1))
                    });
                    facultades += "</ul>";

//                console.log("facultades:", facultades)
                    var optionsBarra = {
                        leyend: { display: true},
                        scales: {
                            xAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }}],
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }}]
                        }
                    };

                    var optionsPila = {
                        leyend: { display: true},
                        scales: {
                            xAxes: [{
                                ticks: {
                                    beginAtZero: true
                                },
                                stacked: true }],
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                },
                                stacked: true }]
                        }
                    };

                    if(id === 'tpenPila') {
                        grafica('bar', leyenda, datos, optionsPila, canvas)
                    } else {
                        grafica('bar', leyenda, datos, optionsBarra, canvas)
                    }

                    $("#divFacl").remove();
                    $('#chart-area').append('<div id="divFacl" style="margin-top: 30px; text-align: left">' + facultades + '</div>');
                }
            });
        }else{
            $("#chart-area").addClass('hidden');
            log("Seleccione una facultad","info")
        }
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