<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 09/02/17
  Time: 14:43
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta name="layout" content="main">
    <title>Variables Auxiliares</title>

    <style type="text/css">

    .estilo{
        margin-top: 10px;
    }
    .bajo {
        margin-bottom: 20px;
    }

    </style>

</head>

<body>

<div class="row">
    <div class="col-md-12">
        <div class="btn-group col-md-4">
            <g:link controller="auxiliares" action="list" class="btn btn-primary" title="Parámetros auxiliares">
                <i class="fa fa-chevron-left"></i> Lista
            </g:link>

            <a href="#" class="btn btn-success btnGuardar" >
                <i class="fa fa-save"></i> Guardar
            </a>

            <a href="#" class="btn btn-info btnDefecto" >
                <i class="fa fa-dashboard"></i> Valores por defecto
            </a>
        </div>
        <g:if test="${!auxiliar}">
            <div class="col-md-3">
                <div class="col-md-4"><h4><span class="label label-primary">Período: </span></h4></div>
                <div class="col-md-6">
                    <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                              class="form-control" from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
                </div>
            </div>
        </g:if>
    </div>
</div>



<div class="row">
    <div class="col-md-12">
        <div class="col-md-4">
            <label class="bajo">Índice de calidad Mínimo (evaluación docentes)</label>

            <div id="fuel-gauge"></div>

            <div class="col-md-7 estilo" id="fuel-gauge-control"></div>

        </div>
        <div class="col-md-4">
            <label class="bajo">Índice de calidad Óptimo (evaluación docentes)</label>

            <div  id="fuel-gauge2"></div>

            <div class="col-md-7 estilo" id="fuel-gauge-control2"></div>

        </div>
        <div class="col-md-4">
            <label class="bajo">Ajuste para potenciadores de nivel Moderado (0-100 val=75)</label>
            <div id="fuel-gauge3"></div>

            <div class="col-md-7 estilo" id="fuel-gauge-control3"></div>

        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="col-md-4">
            <label class="bajo">Ajuste para potenciadores de nivel Exagerado (0-75 val=50)</label>
            <div id="fuel-gauge4"></div>

            <div class="col-md-7 estilo" id="fuel-gauge-control4"></div>

        </div>
        <div class="col-md-4">
            <label class="bajo">% de opinión para Cuellos de Botella (10-50 val=10)</label>
            <div id="fuel-gauge5"></div>

            <div class="col-md-7 estilo" id="fuel-gauge-control5"></div>
        </div>
        <div class="col-md-4">
            <label class="bajo">% de opinión para Factor de éxito (10-50 val=10) </label>

            <div id="fuel-gauge6"></div>

            <div class="col-md-7 estilo" id="fuel-gauge-control6"></div>

        </div>
    </div>
</div>

<div class="row">
    <div class="panel panel-info col-md-12" style="margin-top: 20px" >
        <div class="panel-heading">
            <h3 class="panel-title" style="height: 35px; text-align: center">
                PONDERACIONES ${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteModerado}
            </h3>
        </div>
        <div class="panel-body" style="text-align: center">
            <div class="col-md-2"></div>
            <div class="col-md-6">
                <div id="chart_div"></div>
            </div>
            <div class="col-md-3">
                <table style="margin-top: 50px">
                    <tr>
                        <td><label>Directivos</label></td>
                        <td>
                            <div class="input-group">
                                <g:textField name="dire_name" id="idDire" value="${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoDirectivos ?: 20}" class="form-control number" maxlength="2"/>
                                <span class="input-group-addon" id="sizing-addon2">%</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><label>Pares</label></td>
                        <td>
                            <div class="input-group">
                                <g:textField name="pares_name" id="idPares" value="${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoPares ?: 20}" class="form-control number" maxlength="2"/>
                                <span class="input-group-addon" id="sizing-addon2">%</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><label>Autoevaluaciones</label></td>
                        <td>
                            <div class="input-group">
                                <g:textField name="auto_name" id="idAuto" value="${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoAutoevaluacion ?: 20}" class="form-control number" maxlength="2"/>
                                <span class="input-group-addon" id="sizing-addon2">%</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><label>Estudiantes</label></td>
                        <td>
                            <div class="input-group">
                                <g:textField name="estu_name" id="idEstu" value="${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoEstudiantes ?: 40}" class="form-control number" maxlength="2"/>
                                <span class="input-group-addon" id="sizing-addon2">%</span>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

        </div>
    </div>
</div>

<script type="text/javascript">

    google.charts.load('current', {'packages':['corechart']});

    // Set a callback to run when the Google Visualization API is loaded.
    google.charts.setOnLoadCallback(drawChart);

    // Callback that creates and populates a data table,
    // instantiates the pie chart, passes in the data and
    // draws it.
    function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Topping');
        data.addColumn('number', 'Slices');
        data.addRows([
            ['Ponderación para evaluación de Directivos', ${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoDirectivos ?: 20}],
            ['Ponderación para evaluación de Pares ', ${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoPares ?: 20}],
            ['Ponderación para Autoevaluaciones ', ${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoAutoevaluacion ?: 20}],
            ['Ponderación para evaluación de Estudiantes', ${utilitarios.Auxiliares.get(auxiliar?.id)?.maximoEstudiantes ?: 40}]
        ]);

        // Set chart options
        var options = {'title':'Valores de Ponderaciones',
            'width':500,
            'is3D':true,
            'height':300};

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
    }


    $( function () {
        var $myFuelGauge;

        $myFuelGauge = $("div#fuel-gauge").dynameter({
            width: 200,
            label: 'Mínimo',
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.minimo ?: 50},
            min: 0,
            max: 100,
//            unit: 'gal',
            regions: { // Value-keys and color-refs
                0: 'error',
                65: 'warn',
                25: 'normal'
            }
        });

        // jQuery UI slider widget
        $('div#fuel-gauge-control').slider({
            min: 0,
            max: 100,
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.minimo ?: 50},
            step: 1,
            slide: function (evt, ui) {
                $myFuelGauge.changeValue((ui.value).toFixed(1));
                imprimirValor(ui.value, "minimo")
            }
        });

        imprimirValor(${utilitarios.Auxiliares.get(auxiliar?.id)?.minimo ?: 50},"minimo")

    });


    $( function () {
        var $myFuelGauge2;

        $myFuelGauge2 = $("div#fuel-gauge2").dynameter({
            width: 200,
            label: 'Óptimo',
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.optimo ?: 50},
            min: 0,
            max: 100,
//            unit: 'gal',
            regions: { // Value-keys and color-refs
                0: 'error',
                65: 'warn',
                25: 'normal'
            }
        });

        // jQuery UI slider widget
        $('div#fuel-gauge-control2').slider({
            min: 0,
            max: 100,
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.optimo ?: 50},
            step: 1,
            slide: function (evt, ui) {
                $myFuelGauge2.changeValue((ui.value).toFixed(1));
                imprimirValor(ui.value, "optimo")
            }
        });

        imprimirValor(${utilitarios.Auxiliares.get(auxiliar?.id)?.optimo ?: 50},"optimo")

    });

    $( function () {
        var $myFuelGauge3;

        $myFuelGauge3 = $("div#fuel-gauge3").dynameter({
            width: 200,
            label: 'Moderado',
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteModerado ?: 75},
            min: 0,
            max: 100,
//            unit: 'gal',
            regions: { // Value-keys and color-refs
                0: 'error',
                65: 'warn',
                25: 'normal'
            }
        });

        // jQuery UI slider widget
        $('div#fuel-gauge-control3').slider({
            min: 0,
            max: 100,
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteModerado ?: 75},
            step: 1,
            slide: function (evt, ui) {
                $myFuelGauge3.changeValue((ui.value).toFixed(1));
                imprimirValor(ui.value, "moderado")
            }
        });

        imprimirValor(${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteModerado ?: 75},"moderado")

    });

    $( function () {
        var $myFuelGauge4;

        $myFuelGauge4 = $("div#fuel-gauge4").dynameter({
            width: 200,
            label: 'Exagerado',
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteExagerado ?: 50},
            min: 0,
            max: 75,
//            unit: 'gal',
            regions: { // Value-keys and color-refs
                0: 'error',
                65: 'warn',
                25: 'normal'
            }
        });

        // jQuery UI slider widget
        $('div#fuel-gauge-control4').slider({
            min: 0,
            max: 75,
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteExagerado ?: 50},
            step: 1,
            slide: function (evt, ui) {
                $myFuelGauge4.changeValue((ui.value).toFixed(1));
                imprimirValor(ui.value, "exagerado")
            }
        });

        imprimirValor(${utilitarios.Auxiliares.get(auxiliar?.id)?.ajusteExagerado ?: 50},"exagerado")

    });

    $( function () {
        var $myFuelGauge5;

        $myFuelGauge5 = $("div#fuel-gauge5").dynameter({
            width: 200,
            label: 'C. Botella',
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.cuelloBotella ?: 10},
            min: 10,
            max: 75,
//            unit: 'gal',
            regions: { // Value-keys and color-refs
                10: 'error',
                65: 'warn',
                25: 'normal'
            }
        });

        // jQuery UI slider widget
        $('div#fuel-gauge-control5').slider({
            min: 10,
            max: 75,
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.cuelloBotella ?: 10},
            step: 1,
            slide: function (evt, ui) {
                $myFuelGauge5.changeValue((ui.value).toFixed(1));
                imprimirValor(ui.value, "botella")
            }
        });

        imprimirValor(${utilitarios.Auxiliares.get(auxiliar?.id)?.cuelloBotella ?: 10},"botella")

    });

    $( function () {
        var $myFuelGauge6;

        $myFuelGauge6 = $("div#fuel-gauge6").dynameter({
            width: 200,
            label: 'F. Éxito',
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.factorExito ?: 10},
            min: 10,
            max: 50,
//            unit: 'gal',
            regions: { // Value-keys and color-refs
                10: 'error',
                45: 'warn',
                25: 'normal'
            }
        });

        // jQuery UI slider widget
        $('div#fuel-gauge-control6').slider({
            min: 10,
            max: 50,
            value: ${utilitarios.Auxiliares.get(auxiliar?.id)?.factorExito ?: 10},
            step: 1,
            slide: function (evt, ui) {
                $myFuelGauge6.changeValue((ui.value).toFixed(1));
                imprimirValor(ui.value, "exito")
            }
        });

        imprimirValor(${utilitarios.Auxiliares.get(auxiliar?.id)?.factorExito ?: 10},"exito")

    });

    var mini = 0;
    var opti = 0;
    var mode = 0;
    var exag = 0;
    var bote = 0;
    var ex = 0;

    function imprimirValor (va,tipo) {
        switch (tipo) {
            case "minimo" :
                mini = va;
                break;
            case "optimo" :
                opti = va;
                break;
            case "moderado":
                mode = va;
                break;
            case "exagerado":
                exag = va;
                break;
            case "botella":
                bote = va;
                break;
            case "exito":
                ex = va;
                break;
        }
    }


    $(".btnGuardar").click(function () {
        var dire = $("#idDire").val();
        var estu = $("#idEstu").val();
        var pares = $("#idPares").val();
        var auto = $("#idAuto").val();
        var per = $("#periodoId").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'auxiliares', action: 'guardarValores_ajax')}',
            data:{
                id: '${auxiliar?.id}',
                minimo: mini,
                optimo: opti,
                moderado: mode,
                exagerado: exag,
                botella: bote,
                exito: ex,
                directivos: dire,
                estudiantes: estu,
                pares: pares,
                auto: auto,
                periodo : per
            },
            success: function (msg){
                var parts = msg.split("_");
                if(parts[0] == 'ok'){
                    log(parts[1],"success");
                    setTimeout(function () {
                        location.href='${createLink(controller: 'auxiliares', action: 'auxiliares')}/' + parts[2]
                    }, 500);
                }else{
                    log(parts[1],"error");
                }
            }
        });
    });



    //    $(".form-control").keydown(function (ev) {
    //        if (ev.keyCode == 13) {
    //           console.log("enter")
    //            return false;
    //        }
    //        return true;
    //    });



</script>


</body>
</html>