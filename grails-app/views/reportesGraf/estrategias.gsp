<%@ page import="docentes.Universidad; seguridad.Persona" contentType="text/html;charset=UTF-8" %>
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
        height: auto;
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
<div align="center">
    <h1>Desempeño según la Estrategia Institucional</h1>
    <p style="font-size: 28px; color: rgba(63,113,186,0.9)">${seguridad.Persona.get(session.usuario.id)?.universidad?.nombre}</p>
</div>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 10px">

    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-md-1">Universidad:</div>
        <div class="col-sm-3">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 280px"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
        <div class="col-md-2">Seleccione el período de evaluaciones:</div>
        <div class="col-sm-1" id="divPeriodos">

        </div>

        <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

        <div class="col-md-3" id="divFacultad">

        </div>
    </g:if>
    <g:else>
        <div class="col-md-2">Seleccione el período de evaluaciones:</div>
        <div class="col-sm-1">
            <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 90px"
                      from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>
        </div>

        <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

        <div class="col-md-4">
            <g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                      optionKey="id" name="facultad_name" id="facultad" class="form-control"
                      noSelection="${[0:'Todas ...']}"/>
        </div>

    </g:else>




%{----}%
%{--<div class="col-md-2">Seleccione el periodo de evaluaciones:</div>--}%

%{--<div class="col-sm-1">--}%
%{--<g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"--}%
%{--class="form-control" style="width: 90px"--}%
%{--from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>--}%
%{--</div>--}%

%{--<div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>--}%

%{--<div class="col-md-4">--}%
%{--<g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"--}%
%{--optionKey="id" name="facultad_name" id="facultad" class="form-control"--}%
%{--noSelection="${[0:'Todas ...']}"/>--}%
%{--</div>--}%

    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-md-3" style="margin-top: 8px; margin-left: -150px">
    </g:if>
    <g:else>
        <div class="col-md-3">
    </g:else>
        <div class="btn btn-info" id="graficar">
            <i class="fa fa-pie-chart"></i> Polígono
        </div>
        <div class="btn btn-info" id="grafPolar" style="margin-left: 2px">
            <i class="fa fa-pie-chart"></i> Polar
        </div>
    </div>


</div>

<div class="chart-container grafico" id="chart-area" hidden>
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


    cargarPeriodo($("#universidadId").val());
    cargarFacultad($("#universidadId").val());

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
                                backgroundColor: "rgba(255,255,255,0.05)",
                                borderWidth: 1,
                                data: [100,100,100,100,100] },
                            {   label: ["Desempeño porcentual"],
                                backgroundColor: "rgba(240,240,120,0.4)",
                                borderColor: "rgba(120,120,80, 0.5)",
                                borderWidth: 4,
                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] },
                            {   label: ["Mínimo"],
                                backgroundColor: "rgba(255,240,240,0.2)",
                                borderColor: "rgba(200,40,40, 0.3)",
                                borderWidth: 2,
                                data: [40,40,40,40,40]},
                            {   label: ["Óptimo"],
                                backgroundColor: "rgba(240,240,255,0.2)",
                                borderColor: "rgba(0,0,200, 0.2)",
                                borderWidth: 2,
                                data: [80,80,80,80,80]}
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
                            {   label: ["Desempeño porcentual"],
                                backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] },
                            {   label: ["Mínimo"],
                                backgroundColor: "rgba(255,160,160,0.1)",
//                                borderColor: "rgba(255,255,255,0.8)",
//                                borderWidth: 1,
                                data: [40,40,40,40,40] },
                            {   label: ["Óptimo"],
                                backgroundColor: "rgba(160,160,240,0.05)",
                                borderWidth: 1,
                                data: [80,80,80,80,80] }
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