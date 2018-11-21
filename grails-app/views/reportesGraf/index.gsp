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
        height: 540px;
        border-radius: 8px;
        margin: 10px;
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
        /*color: @light;*/
        /*font-family: @family;*/
        font-variant: small-caps;
        font-size: 14px;
    }

    </style>
</head>

<body>
<div align="center">
    <h1>Clasificación por Desempeño</h1>
    <g:if test="${session.perfil.codigo != 'ADMG'}">
        <p style="font-size: 28px; color: rgba(63,113,186,0.9)">${seguridad.Persona.get(session.usuario.id)?.universidad?.nombre}</p>
    </g:if>
</div>


%{--<div class="row text-info" style="font-size: 11pt; margin-bottom: 21px">--}%

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

%{--<div class="col-md-2" id="divFacultad">--}%

%{--</div>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<div class="col-md-2">Seleccione el período de evaluaciones:</div>--}%
%{--<div class="col-sm-1">--}%
%{--<g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"--}%
%{--class="form-control" style="width: 90px"--}%
%{--from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>--}%
%{--</div>--}%

%{--<div class="col-md-1" style="margin-top: 10px; margin-left: 10px">Facultad:</div>--}%

%{--<div class="col-md-4">--}%
%{--<g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"--}%
%{--optionKey="id" name="facultad_name" id="facultad" class="form-control"--}%
%{--noSelection="${[0:'Todas ...']}"/>--}%
%{--</div>--}%

%{--</g:else>--}%
%{--<div class="col-md-1">--}%
%{--<div class="btn btn-info" id="graficar">--}%
%{--<i class="fa fa-pie-chart"></i> Aceptar--}%
%{--</div>--}%
%{--</div>--}%
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

<div class="row text-info" style="text-align: center">
    <div class="btn btn-info graficar">
        <i class="fa fa-pie-chart"></i> Aceptar
    </div>
</div>



<div class="chart-container grafico" id="chart-area" hidden>
    <h3 id="titulo"></h3>
    <div id="graf">
        <canvas id="clases" style="margin-top: 30px"></canvas>
    </div>

    <div id="tabla" style="margin-left: 20%; margin-top: 10px; width: 60%; height: 124px; border-style: solid; border-width: 1px; border-color: #888">
        <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
            <thead>
            <tr>
                <th class="centrado" rowspan="2" style="width: 40%">Clase</th>
                <th class="centrado" rowspan="2" style="width: 40%">Valor</th>
            </tr>
            </thead>

            <tbody id="divDatos">
            </tbody>
        </table>
    </div>

    <div style="margin-top: 10px">
        <a href="#" class="btn btn-info" id="imprimirClases">
            <i class="fa fa-line-chart"></i> Imprimir
        </a>
    </div>
</div>

<div class="chart-container grafico" id="chart-area2" hidden>
    <h3 id="titulo2"></h3>
    <div id="graf2">
        <canvas id="clases2" style="margin-top: 30px"></canvas>
    </div>

    <div id="tbRc" style="margin-left: 25%; margin-top: 30px; width: 50%; height: 82px; border-style: solid; border-width: 1px; border-color: #888">
        <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
            <thead>
            <tr>
                <th class="centrado" rowspan="2">Con Recomendaciones</th>
                <th class="centrado" rowspan="2">Sin Recomendaciones</th>
            </tr>
            </thead>
            <tbody id="datosRc">
            </tbody>
        </table>
    </div>

    <div style="margin-top: 20px">
        <a href="#" class="btn btn-info" id="imprimirRecomendados">
            <i class="fa fa-line-chart"></i> Imprimir
        </a>
    </div>
</div>

<script type="text/javascript">

    %{--cargarPeriodo($("#universidadId").val());--}%
    %{--cargarFacultad($("#universidadId").val());--}%


    %{--$("#universidadId").change(function () {--}%
    %{--var id = $("#universidadId option:selected").val();--}%
    %{--cargarPeriodo(id);--}%
    %{--cargarFacultad(id);--}%
    %{--});--}%

    %{--function cargarPeriodo(id) {--}%
    %{--$.ajax({--}%
    %{--type: 'POST',--}%
    %{--url: '${createLink(controller: 'reportesGraf', action: 'periodo_ajax')}',--}%
    %{--data:{--}%
    %{--universidad: id--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--$("#divPeriodos").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%

    %{--function cargarFacultad (id) {--}%
    %{--$.ajax({--}%
    %{--type: 'POST',--}%
    %{--url: '${createLink(controller: 'reportesGraf', action: 'facultadSel_ajax')}',--}%
    %{--data:{--}%
    %{--universidad: id--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--$("#divFacultad").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%

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

    $(".graficar").click(function () {

        openLoader("Graficando...");

        var prdo = $("#periodoId").val();
        var univ = $("#universidadId").val();
        var facl = $("#facultad").val();
        var escl = $("#escuelaId option:selected").val();

        if(escl != null){
            $("#chart-area").removeClass('hidden')
            $("#chart-area2").removeClass('hidden')
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportesGraf', action: 'clasificar')}',
                data: {facl: facl, prdo: prdo, univ: univ, escl: escl},
                success: function (msg) {

                    closeLoader();

                    var valores = msg.split("_")
                    $("#titulo").html(valores[3])
                    $("#titulo2").html(valores[6])
                    $("#clases").remove();
                    $("#clases2").remove();
                    $("#r1").remove();
                    $("#r2").remove();
                    $("#c1").remove(); $("#dc1").remove();
                    $("#c2").remove(); $("#dc2").remove();
                    $("#c3").remove(); $("#dc3").remove();
                    $("#chart-area").removeAttr('hidden')
                    $("#chart-area2").removeAttr('hidden')

                    /* se crea dinámicamente el canvas y la función "click" */
                    $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');
                    $('#graf2').append('<canvas id="clases2" style="margin-top: 30px"></canvas>');

                    $('#datosRc').append('<tr><td class= "centrado" id="r1">' + valores[4] +
                        '</td><td class= "centrado" id="r2">' + valores[5]+ '</td></tr>');

                    $('#divDatos').append('<tr><td class= "centrado" id="c1">A</td><td class= "centrado" id="dc1">' +
                        valores[0] + '</td></tr><tr><td class= "centrado" id="c2">B</td><td class= "centrado" id="dc2">' +
                        valores[1]+ '</td></tr><tr><td class= "centrado" id="c3">C</td><td class= "centrado" id="dc3">' +
                        valores[2]+ '</td></tr>');

                    $("#clases").off();
                    $('#clases').on('click', function(evt) {
                        var activePoint = myChart.getElementAtEvent(evt)[0];
                        var data = activePoint._chart.data;
                        var datasetIndex = activePoint._datasetIndex;
                        var label = data.datasets[datasetIndex].label[activePoint._index];
                        var value = data.datasets[datasetIndex].data[activePoint._index];

                        $.ajax({
                            type: 'POST',
                            url:'${createLink(controller: 'reportesGraf', action: 'dialogo_ajax')}',
                            data:{
                                indice: datasetIndex,
                                etiqueta: label,
                                valor: value,
                                periodo: prdo,
                                facultad:facl,
                                tipo: 1
                            },
                            success: function (msg){
                                var b = bootbox.dialog({
                                    id: "dlgRecomendaciones",
                                    title: "Clase: " + label,
                                    class: "long",
                                    message: msg,
                                    buttons: {
                                        cancelar: {
                                            label: "<i class='fa fa-times'></i> Cancelar",
                                            className: "btn-primary",
                                            callback: function () {
                                            }
                                        }
                                    } //buttons
                                }); //dialog
                            }
                        });

//                    console.log("indice:", datasetIndex, "etiqueta:",label, "valor:", value);
                    });

                    canvas = $("#clases")
//                console.log("ok", valores[0])



                    $("#clases2").off();
                    $('#clases2').on('click', function(evt) {
                        var activePoint = myChart.getElementAtEvent(evt)[0];
                        var data = activePoint._chart.data;
                        var datasetIndex = activePoint._datasetIndex;
                        var label = data.datasets[datasetIndex].label[activePoint._index];
                        var value = data.datasets[datasetIndex].data[activePoint._index];


                        if(label == 'A'){
                            $.ajax({
                                type: 'POST',
                                url:'${createLink(controller: 'reportesGraf', action: 'dialogo_ajax')}',
                                data:{
                                    indice: datasetIndex,
                                    etiqueta: label,
                                    valor: value,
                                    periodo: prdo,
                                    facultad:facl,
                                    tipo: 2
                                },
                                success: function (msg){
                                    var b = bootbox.dialog({
                                        id: "dlgRecomendaciones",
                                        title: "Clase: " + label,
                                        class: "long",
                                        message: msg,
                                        buttons: {
                                            cancelar: {
                                                label: "<i class='fa fa-times'></i> Cancelar",
                                                className: "btn-primary",
                                                callback: function () {
                                                }
                                            }
                                        } //buttons
                                    }); //dialog
                                }
                            });
                        }




//                    console.log("indice:", datasetIndex, "etiqueta:",label, "valor:", value);
                    });



                    var chartData = {
                        type: 'bar',
                        data: {
                            labels: ['Clase A', 'Clase B', 'Clase C'],
                            datasets: [
                                {
                                    label: ["Profesores"],
                                    backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                    borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                    borderWidth: [3,3,3],
                                    data: [valores[0], valores[1], valores[2]]
                                }
                            ]
                        },
                        options: {
                            legend: { display: false,
                                labels: {
                                    fontColor: 'rgb(20, 80, 100)',
                                    fontSize: 14
                                }
                            }
                        }
                    };

                    var chartDataRc = {
                        type: 'pie',
                        data: {
                            labels: ['Con recomendaciones', 'Sin recomendaciones'],
                            datasets: [
                                {
//                                label: ["R", "N"],
                                    backgroundColor: ['#ff8f43', '#4678aa'],
                                    borderColor: ['#ffaf63', '#7697da'],
                                    borderWidth: [3,3],
                                    data: [valores[4], valores[5]]
                                }
                            ]
                        },
                        options: {
                            legend: {
                                display: true,
                                labels: {
                                    fontColor: 'rgb(20, 80, 100)',
                                    fontSize: 14
                                }
                            }
                        }
                    }
                    myChart = new Chart(canvas, chartData, 1);
                    myChart2 = new Chart($("#clases2"), chartDataRc, 1);

                }


            });
        }else{
            closeLoader();
            $("#chart-area").addClass('hidden');
            $("#chart-area2").addClass('hidden');
          log("Seleccione una carrera","info")
        }


    });

    $("#imprimirRecomendados").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escl = $("#escuelaId option:selected").val();
        var universidad = $("#universidadId option:selected").val();
        location.href = "${createLink(controller: 'reportes', action: 'recomendacionesGrafico')}?periodo=" + prdo +
            "&facultad=" + facl + "&tipo=" + 1 + "&escl=" + escl + "&univ=" + universidad;
    });

    $("#imprimirClases").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var universidad = $("#universidadId option:selected").val();
        var escl = $("#escuelaId option:selected").val();
        location.href = "${createLink(controller: 'reportes', action: 'profesoresClases')}?periodo=" + prdo + "&univ=" + universidad +
            "&facultad=" + facl + "&tipo=" + 1 + "&escl=" + escl;
    });


</script>


</body>
</html>