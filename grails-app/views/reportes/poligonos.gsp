<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/17
  Time: 10:20
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Desempeño</title>
    <script src="${resource(dir: 'js', file: 'Chart.js')}"></script>

    <style type="text/css">

    .grafico{
        width: 100%;
        float: left;
        text-align: center;
        height: 240px;
    }
    .bajo {
        margin-bottom: 20px;
    }
    .centrado{
        text-align: center;
    }

    .legend {
        width: 50%;
        position: absolute;
        top: 100px;
        right: 20px;
        font-variant: small-caps;
        font-size: 14px;
    }

    </style>

</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="reportes" action="reportes" class="btn btn-primary" title="Regresar a lista de informes">
            <i class="fa fa-chevron-left"></i> Reportes
        </g:link>
    </div>

    %{--<div class="col-md-1 negrilla control-label">Periodo: </div>--}%
    <div class="col-md-2">
    <b>Período:</b>
    <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
              class="form-control"
              from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>
    </div>

    <div class="col-md-3">
        <b>Facultad:</b>
        <g:select name="facultad" id="facultadId" optionKey="id" optionValue="nombre"
                  class="form-control" from="${facultad}"
                  value="" />
    </div>
    <div class="col-md-3">
        <b>Carrera:</b>
        <div id="divEscuela">

        </div>
        %{--<g:select name="escuela" id="escuelaId" optionKey="id" optionValue="nombre"--}%
                  %{--class="form-control" from="${escl}"--}%
                  %{--value="" />--}%
    </div>
</div>


<div class="panel panel-info col-md-12" style="margin-top: 10px;" >

    <div class="panel-body">
        <div class="list-group" style="text-align: center">
            <div>
                <div class="col-md-1 negrilla control-label">Cédula: </div>
                <div class="col-md-2" id="divCedula">
                    <g:textField name="cedula" id="cedulaBusqueda" class="form-control number" maxlength="20"/>
                </div>
                <div class="col-md-1 negrilla control-label">Nombres: </div>
                <div class="col-md-3">
                    <g:textField name="nombres" id="nombresBusqueda" class="form-control"/>
                </div>
                <div class="col-md-1 negrilla control-label">Apellidos: </div>
                <div class="col-md-3">
                    <g:textField name="apellidos" id="apellidosBusqueda" class="form-control"/>
                </div>
                <a href="#" id="btnBuscar" class="btn btn-info" title="Buscar">
                    <i class="fa fa-search-plus"></i> Buscar
                </a>
            </div>


            <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
                <thead >
                <tr style="text-align: center">
                    <th style="width: 20%">Profesor</th>
                    <th style="width: 20%">Materia</th>
                    <th style="width: 5%">Par.</th>
                    <th style="width: 55%; text-align: center">Gráfico de desempeño</th>
                </tr>
                </thead>
            </table>

            <div id="divTablaProfesores" class="">

            </div>

        </div>
    </div>

</div>


<script type="text/javascript">

    cargarEscuelas($("#facultadId option:selected").val());

    $("#facultad").change(function () {
        var facultad = $("#facultadId option:selected").val();
        cargarEscuelas(facultad);
    });

    function cargarEscuelas (facultad) {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'reportesGraf', action: 'escuelas_ajax')}',
            data:{
                facultad: facultad
            },
            success: function (msg){
                $("#divEscuela").html(msg)
            }
        });
    }


    buscar();

    function buscar () {
//        openLoader("Buscando...");
        var ced = $("#cedulaBusqueda").val();
        var nom = $("#nombresBusqueda").val();
        var ape = $("#apellidosBusqueda").val();
        var fac = $("#facultadId").val();
        var escuela = $("#esculeaId").val();
        var per = $("#periodoId").val();
        console.log('buscar ... ');
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'reportes', action: 'graficoProf_ajax')}",
            data:{
                cedula: ced,
                nombres: nom,
                apellidos: ape,
                facultad: fac,
                periodo: per,
                escuela: escuela
            },
            success: function (msg){
                $("#divTablaProfesores").html(msg);
                closeLoader();

            }
        }) ;
    }

    $("#btnBuscar").click(function () {
        buscar();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            buscar();
        }
    });




    //    graficar()

    function graficar(area) {
        var canvas = area;
        var myChart;

//        $("#titulo").html(json.facultad)
//        $("#clases").remove();

        /* se crea dinámicamente el canvas y la función "click" */
//        $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

//        canvas = $("#clases_0");

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

</body>
</html>