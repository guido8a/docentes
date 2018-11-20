<%@ page import="docentes.Universidad; seguridad.Persona" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gráficos</title>
    <script src="${resource(dir: 'js', file: 'Chart.min.js')}"></script>
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
    <h1>Relación de Potenciadores a Limitantes (%)</h1>
    <g:if test="${session.perfil.codigo != 'ADMG'}">
        <p style="font-size: 28px; color: rgba(63,113,186,0.9)">${seguridad.Persona.get(session.usuario.id)?.universidad?.nombre}</p>
    </g:if>
</div>
%{--<div class="row text-info" style="font-size: 11pt; margin-bottom: 10px">--}%

%{--<g:if test="${session.perfil.codigo == 'ADMG'}">--}%
%{--<div class="col-md-1">Universidad:</div>--}%
%{--<div class="col-sm-3">--}%
%{--<g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"--}%
%{--class="form-control" style="width: 280px"--}%
%{--from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>--}%
%{--</div>--}%
%{--<div class="col-md-2">Seleccione el período de evaluaciones:</div>--}%
%{--<div class="col-sm-1" id="divPeriodos">--}%

%{--</div>--}%

%{--<div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>--}%

%{--<div class="col-md-3" id="divFacultad">--}%

%{--</div>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<div class="col-md-2">Seleccione el período de evaluaciones:</div>--}%
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

%{--</g:else>--}%




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


<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">

    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-sm-3 row" style="text-align: right">
            Universidad
        </div>

        <div class="col-sm-6">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
        <div class="col-md-1">Período:</div>
    </g:if>
    <g:else>
        <div class="col-sm-6">
            Universidad
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 280px"
                      from="${seguridad.Persona.get(session.usuario.id)?.universidad}"/>
        </div>

        <div class="col-md-1">Periodo:</div>
        <div class="col-sm-1">
            <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 90px"
                      from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>
        </div>
    </g:else>

    <div class="col-md-2" id="divPeriodos">

    </div>

</div>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">
    <div class="col-md-1">Facultad</div>
    <div class="col-md-5" id="divFacultad">

    </div>

    <div class="col-md-1">Carrera</div>
    <div class="col-md-5" id="divEscuela">

    </div>
</div>

<div class="btn btn-info" id="graficar">
    <i class="fa fa-pie-chart"></i> Polígono
</div>
<div class="btn btn-info" id="grafPolar" style="margin-left: 2px">
    <i class="fa fa-pie-chart"></i> Polar
</div>




%{--<g:if test="${session.perfil.codigo == 'ADMG'}">--}%
%{--<div class="col-md-3" style="margin-top: 8px; margin-left: -150px">--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<div class="col-md-3">--}%
%{--</g:else>--}%

%{--</div>--}%


%{--</div>--}%

<div class="col-md-5"></div>

<div class="chart-container grafico" id="chart-area" hidden>
    <h3 id="titulo"></h3>
    <div id="graf">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

</div>

%{--
<div class="chart-container grafico" id="chart-area" hidden style="width: 60%; float: left">
    <h3 id="titulo"></h3>
    <div id="graf">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

</div>
<div class="chart-container grafico" id="chart-area" hidden style="width: 48%; float: left">
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
            url: '${createLink(controller: 'reportesGraf', action: 'facultadSel_ajax')}',
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
        var escl = $("#escuelaId option:selected").val();

        if(escl != null){
            $("#chart-area").removeClass('hidden');
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportesGraf', action: 'estrategiaData')}',
                data: {facl: facl, prdo: prdo, escl: escl},
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
//                            {   label: ["Desempeño porcentual"],
//                                backgroundColor: "rgba(120,255,120,0.4)",
//                                borderColor: "rgba(60,160,120, 0.5)",
//                                borderWidth: 4,
//                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] },
                                {   label: ["Potenciadores"],
                                    backgroundColor: "rgba(120,255,120,0.4)",
                                    borderColor: "rgba(60,160,120, 0.5)",
                                    borderWidth: 4,
//                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] },
                                    data: [json.promedio, json.ptnv, json.fcex, 0, 0] },
                                {   label: ["Limitantes"],
                                    backgroundColor: "rgba(255,120,0,0.4)",
                                    borderColor: "rgba(255,120,0, 0.5)",
                                    borderWidth: 4,
//                                data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] },
                                    data: [json.promedio, 0, 0, json.ccbb, json.rcmn] },
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
                            legend: {
                                display: true,
                                labels: {
                                    fontColor: 'rgb(20, 80, 100)',
                                    fontSize: 14,

                                }
                            }

                        }
                    };

                    myChart = new Chart(canvas, chartData, 1);
                }
            });
        }else{
            $("#chart-area").addClass('hidden');
            log("Seleccione una carrera","info")
        }


    });

    $("#grafPolar").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escl = $("#escuelaId option:selected").val();

        if(escl != null){
            $("#chart-area").removeClass('hidden');
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportesGraf', action: 'estrategiaData')}',
                data: {facl: facl, prdo: prdo, escl: escl},
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
                                {   label: ["Porcentajes"],
//                                backgroundColor: ["#20a5da", "#00af30","#80ff80", "#d45840", "#be5882"],
                                    backgroundColor: ["rgba(32,165,218,0.5)", "#00af30","#80ff80", "#d45840", "rgba(206,88,130,0.6)"],
                                    data: [json.promedio, json.ptnv, json.fcex, json.ccbb, json.rcmn] }
//                            {   label: ["Mínimo"],
//                                backgroundColor: "rgba(255,160,160,0.1)",
//                                data: [40,40,40,40,40] },
//                            {   label: ["Óptimo"],
//                                backgroundColor: "rgba(160,160,240,0.05)",
//                                borderWidth: 1,
//                                data: [80,80,80,80,80] }
                            ]

                        },
                        options: {
                            legend: {
                                display: true,
                                labels: {
                                    fontColor: 'rgb(20, 80, 100)',
                                    fontSize: 14
                                },
                                pointLabels: {
                                    fontSize: 16
                                }
                            }

                        }
                    };

                    myChart = new Chart(canvas, chartData, 1);
                }
            });
        }else{
            $("#chart-area").addClass('hidden');
            log("Seleccione una carrera","info")
        }
    });

</script>

</body>
</html>