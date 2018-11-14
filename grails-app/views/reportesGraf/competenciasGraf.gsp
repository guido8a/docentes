<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/18
  Time: 10:43
--%>

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
        width: 47%;
        float: left;
        text-align: center;
        height: 500px;
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
    <h1>Competencias</h1>
</div>
<div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">

%{--<div class="col-md-1"></div>--}%

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


<div class="row text-info" style="text-align: center">

    <div class="btn btn-info tipoEncuesta" id="tpenBarras">
        <i class="fa fa-bar-chart"></i> Diagrama de Barras
    </div>

</div>


<div class="chart-container grafico" id="chart-area" hidden style="height: 600px">
    <h3 id="titulo"></h3>
    <div id="graf" align="center">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

    <a href="#" class="btn btn-info" id="imprimirGenerales"><i class="fa fa-line-chart"></i> Imprimir</a>

</div>


<div class="chart-container grafico" id="chart-area2" hidden style="height: 600px">
    <h3 id="titulo2"></h3>
    <div id="graf2">
        <canvas id="clases2" style="margin-top: 30px"></canvas>
    </div>

    <a href="#" class="btn btn-info" id="imprimirEspecificas"><i class="fa fa-line-chart"></i> Imprimir</a>
</div>


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
    var canvas2 = $("#clases2");
    var myChart;
    var myChart2;

    $(".tipoEncuesta").click(function () {
        var id = this.id;
//        console.log("id:", id)
        var prdo = $("#periodoId").val();
        var esc = $("#escuelaId").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'competenciasData_ajax')}',
            data: {
                prdo: prdo,
                escuela: esc
            },
            success: function (mnsj) {

                var json = $.parseJSON(mnsj);

                $("#titulo").html("Competencias Generales");
                $("#titulo2").html("Competencias Específicas");

                $("#clases").remove();
                $("#clases2").remove();
                $("#chart-area").removeAttr('hidden');
                $("#chart-area2").removeAttr('hidden');
                $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');
                $('#graf2').append('<canvas id="clases2" style="margin-top: 30px"></canvas>');

                canvas = $("#clases");
                canvas2 = $("#clases2");
                var colores = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9"];
                var datos = [];
                var facultades = "<ul>";
                var facultades2 = "<ul>";
                var leyendaG = [];
                var leyendaE = [];
                var leyenda = [];
                var leyenda2 = [];
                var vlor;
                var indice = 0;
                var ddGE = [];
                var ddGP = [];
                var ddEE = [];
                var ddEP = [];
                var parts;
                var valores;
                var ges = 0;
                var es = 0;

                $.each(json, function (key, val) {
//                    console.log("key:", key, "val:", val)
                    parts = key.split("_");
                    valores = val.split("_");

                    if(parts[0] == 'G'){
                        leyendaG.push(parts[1]);
                        ddGE.push(valores[0]);
                        ddGP.push(valores[1]);
                        ges ++;
                        facultades += "<li>" + parts[0] +  " " + ges + " : " + parts[1] + "</li>";
                        leyenda.push(parts[0] + ges);
                    }else{
                        leyendaE.push(parts[1]);
                        ddEE.push(valores[0]);
                        ddEP.push(valores[1]);
                        es ++;
                        facultades2 += "<li>" + parts[0] +  " " + es + " : " + parts[1] + "</li>";
                        leyenda2.push(parts[0] + " " + es);
                    }

                    indice++
                });

                facultades += "</ul>";

//                var optionsBarra = {
//                    leyend: { display: true}
//                };


                myChart = new Chart(canvas, {
                    type: 'bar',
                    data: {
                        labels: leyenda,
                        datasets: [
                            {
                                label: ["Alumnos"],
//                                backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                backgroundColor: "rgba(55, 160, 225, 0.7)",
//                                borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                borderWidth: 2,
                                data: ddGE
                            },
                            {
                                label: ["Profesores"],
//                                backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                backgroundColor: "rgba(225, 58, 55, 0.7)",
//                                borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                borderWidth:  2,
                                data: ddGP
                            }
                        ]
                    },
                    options: {
                        legend: { display: false,
                            labels: {
                                fontColor: 'rgb(20, 80, 100)',
                                fontSize: 11
                            }
                        },
                        scales: {
                            xAxes: [{
                                ticks: {
                                    beginAtZero: true
                                },
                                stacked: false
                            }],
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                },stacked: false }]
                        }

                    }
//                    ,
//                    plugins: [{
//                        beforeInit: function(myChart) {
//                            myChart.data.labels.forEach(function(e, i, a) {
//                                if (/ /.test(e)) {
//                                    a[i] = e.split(/ /);
//                                }
//                            });
//                        }
//                    }]
                });

                myChart2 = new Chart(canvas2, {
                    type: 'bar',
                    data: {
                        labels: leyenda2,
                        datasets: [
                            {
                                label: ["Alumnos"],
//                                backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                backgroundColor: "rgba(55, 160, 225, 0.7)",
//                                borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                borderWidth: 2,
                                data: ddEE
                            },
                            {
                                label: ["Profesores"],
//                                backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                backgroundColor: "rgba(225, 58, 55, 0.7)",
//                                borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                borderWidth:  2,
                                data: ddEP
                            }
                        ]
                    },
                    options: {
                        legend: { display: false,
                            labels: {
                                fontColor: 'rgb(20, 80, 100)',
                                fontSize: 11
                            }
                        },
                        scales: {
                            xAxes: [{
                                ticks: {
                                    beginAtZero: true
                                },
                                stacked: false
                            }],
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                },stacked: false }]
                        }

                    }
//                    ,
//                    plugins: [{
//                        beforeInit: function(myChart) {
//                            myChart.data.labels.forEach(function(e, i, a) {
//                                if (/ /.test(e)) {
//                                    a[i] = e.split(/ /);
//                                }
//                            });
//                        }
//                    }]
                });


                $("#divFacl").remove();
                $("#divFacl2").remove();
                $('#chart-area').append('<div id="divFacl" style="margin-top: 20px; text-align: left">' + facultades + '</div>');
                $('#chart-area2').append('<div id="divFacl2" style="margin-top: 20px; text-align: left">' + facultades2 + '</div>');
            }
        });
    });

    $("#imprimirGenerales").click(function () {
        var prdo = $("#periodoId").val();
        var escuela = $("#escuelaId").val();
        location.href = "${createLink(controller: 'reportesGraf', action: 'competenciasReporteGeneral')}?periodo=" + prdo +
            "&escuela=" + escuela + "&tipo=" + 1;
    });

    $("#imprimirEspecificas").click(function () {
        var prdo = $("#periodoId").val();
        var escuela = $("#escuelaId").val();
        location.href = "${createLink(controller: 'reportesGraf', action: 'competenciasReporteGeneral')}?periodo=" + prdo +
            "&escuela=" + escuela + "&tipo=" + 2;
    });

</script>


</body>
</html>