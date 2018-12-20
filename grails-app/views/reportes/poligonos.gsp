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
        height: 180px;
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
                    <th style="width: 15%">Profesor</th>
                    <th style="width: 35%; text-align: center">Desempeño Alumnos (rojo) y Autoevaluación</th>
                    <th style="width: 15%">Profesor</th>
                    <th style="width: 35%; text-align: center">Desempeño Alumnos (rojo) y Autoevaluación</th>
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


    $(document).ready(function() {
        buscar();
    })

    function buscar () {
//        openLoader("Buscando...");
        var cdla = $("#cedulaBusqueda").val();
        var nmbr = $("#nombresBusqueda").val();
        var apll = $("#apellidosBusqueda").val();
//        var facl = $("#facultadId").val();
        var escl = $("#escuelaId option:selected").val();
        var prdo = $("#periodoId").val();
        console.log('buscar ... ', escl);
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'reportes', action: 'graficoProf_ajax')}",
            data:{
                cedula: cdla,
                nombres: nmbr,
                apellidos: apll,
//                facultad: facl,
                prdo: prdo,
                escl: escl
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

    function graficar(area, serie1, serie2) {
        var canvas = area;
        var myChart;
        var data1 = serie1.split("_");
        var data2 = serie2.split("_");
        console.log("serie1", serie1, 'serie2:', serie2)
        var chartData = {
            type: 'radar',
            data: {
                labels: ['IC', 'DAC', 'DHA', 'IF', 'NI', 'EA'],
                datasets: [
                    {
                        label: ["Autoevaluación"],
                        fill: true,
                        backgroundColor: "rgba(80,140,198,0.2)",
                        borderColor: "rgba(60,120,198,1)",
                        pointBorderColor: "#fff",
                        pointBackgroundColor: "rgba(179,181,198,1)",
                        data: data2
                    },
                    {
                        label: ["Heteroevaluación"],
                        backgroundColor: "rgba(255,99,132,0.2)",
                        borderColor: "rgba(255,99,132,1)",
                        pointBorderColor: "#fff",
                        pointBackgroundColor: "rgba(255,99,132,1)",
                        pointBorderColor: "#fff",
//                        data: [68.77,75.61,90.69,96.62,86.82, 95]
                        data: data1
                    },
                    {   label: ["Mínimo"],
                        backgroundColor: "rgba(255,240,240,0.2)",
                        borderColor: "rgba(200,40,40, 0.3)",
                        borderWidth: 2,
                        data: [40,40,40,40,40,40]},
                    {   label: ["Óptimo"],
                        backgroundColor: "rgba(240,240,255,0.2)",
                        borderColor: "rgba(0,0,200, 0.2)",
                        borderWidth: 2,
                        data: [80,80,80,80,80,80]}
                ]

            },
            options: {
                legend: {
                    display: false,
                    labels: {
                        fontColor: 'rgb(20, 80, 100)',
                        fontSize: 14
                    }
                },
                scale: {
                    ticks: {
                        beginAtZero: true,
                        min: 0,
                        max: 100,
                        stepSize: 20
                    }
                }

            }
        }

        myChart = new Chart(canvas, chartData, 1);
    }


</script>

</body>
</html>