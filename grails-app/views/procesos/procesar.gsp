<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/02/17
  Time: 11:34
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">
    <title></title>
    <style type="text/css">

    .progress {
        height: 35px;

    }
    .progress .skill {
        font: normal 12px "Open Sans Web";
        line-height: 35px;
        padding: 0;
        margin: 0 0 0 20px;
        text-transform: uppercase;
    }
    .progress .skill .val {
        float: right;
        font-style: normal;
        margin: 0 20px 0 0;
    }

    .progress-bar {
        text-align: center;
        transition-duration: 3s;
        font-weight: bold;
        color: #0b0b0b;
    }


    </style>
</head>

<body>


<div class="panel panel-info col-md-12" style="margin-top: 20px" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 35px; padding-left: 10px; padding-right: 110px">
            <div class="col-md-7" style="float: left">
                Procesamiento de las encuestas
            </div>

            <div class="col-md-4"> <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                             class="form-control" from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/> </div>

        </h3>
    </div>
    <div class="panel-body" style="text-align: center">


        %{--<div class="row">--}%
            %{--<svg id="containerN"></svg>--}%
        %{--</div>--}%


        <div class="progress progress-striped active">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">  <span class="fill" data-percentage="50"></span></div>
        </div>

        %{--<div class="container">--}%
            <div class="row">

                <button type="button" class="btn btn-success btnCargar2"><i class="fa fa-check"></i> Iniciar el Proceso</button>

            </div>
        %{--</div>--}%


    </div>
</div>





<script type="text/javascript">

    var progress = $("#containerN").Progress({
        percent: 0, // 20%

        width: 690,
        height: 50,

        // background color of the progress bar
        backgroundColor: '#555',

        // fill color of the progress bar
        barColor: '#d9534f',

        // text color
        fontColor: '#fff',

        // border radius
        radius: 6,

        // font size
        fontSize: 14,
    });



    %{--$(".btnCargar_old").click(function () {--}%

        %{--var periodo = $("#periodoId").val()--}%

        %{--$.ajax({--}%
            %{--type:'POST',--}%
            %{--async: false,--}%
            %{--url: "${createLink(controller: 'procesos', action: 'progreso')}",--}%
            %{--data:{--}%
                %{--periodo: periodo--}%
            %{--},--}%
            %{--success: function (msg){--}%
                %{--console.log("msg " + msg.split("_"))--}%
                %{--var parts = msg.split("_");--}%

                %{--var tamano = (parts.length -1);--}%
                %{--var total = 0--}%
                %{--for(j=0;j<tamano;j++){--}%
                    %{--var pt = Math.round(parts[j])--}%
                    %{--total = pt + total--}%
                %{--}--}%

                %{--var tam = 100/(parts.length - 1)--}%
                %{--var sumado = 0--}%
                %{--for(i = 0; i < (parts.length - 1); i++){--}%
                    %{--var valor = (parts[i]*100)/total;--}%
                    %{--var formateado = parseFloat(Math.round(valor * 100) / 100).toFixed(2);--}%
                    %{--console.log("valor " +  formateado)--}%
                    %{--sumado += parseFloat(formateado);--}%
                        %{--cargarBarra(formateado,sumado,i);--}%
                %{--}--}%
            %{--}--}%
        %{--})--}%
    %{--});--}%

    $(".btnCargar2").click(function () {

        var periodo = $("#periodoId").val()

        $.ajax({
            type:'POST',
            async: false,
            url: "${createLink(controller: 'procesos', action: 'progreso')}",
            data:{
                periodo: periodo
            },
            success: function (msg){
//                console.log("msg " + msg)
//                progress.percent(10);
                var parts = msg.split("*")
                var tamano = (parts.length -1);
                var total = 0
                var parcial = 0
                for(j=0;j<tamano;j++){
                    var pt = Math.round(parts[j].split("_")[1]);
                    total = pt + total
                }

                for(i = 0; i < tamano; i++){
                    parcial += Math.round(parts[i].split("_")[1])
                    cargarBarra(parts[i],total,parcial);
                }

/*
                var parts = msg.split("_");

                var tamano = (parts.length -1);
                var total = 0
                for(j=0;j<tamano;j++){
                    var pt = Math.round(parts[j])
                    total = pt + total
                }

                var tam = 100/(parts.length - 1)
                var sumado = 0
                for(i = 0; i < (parts.length - 1); i++){
                    var valor = (parts[i]*100)/total;
                    var formateado = parseFloat(Math.round(valor * 100) / 100).toFixed(2);
                    console.log("valor " +  formateado)
                    sumado += parseFloat(formateado);
                        cargarBarra(formateado,sumado,i);
                }
*/
            }
        })
    });




    %{--function cargarBarra (parte,sumado,itera) {--}%
%{--//        console.log("entro "+ itera)--}%
        %{--$.ajax({--}%
            %{--type: 'POST',--}%
            %{--url:"${createLink(controller: 'procesos', action: 'prueba')}",--}%
            %{--data:{--}%
                %{--parte: parte,--}%
                %{--itera: itera,--}%
                %{--sumado: sumado--}%
            %{--},--}%
            %{--success: function (msg){--}%

                %{--setTimeout(function () {--}%
                        %{--$('.progress-bar').css('width', msg+'%').attr('aria-valuenow', msg ).text(msg + " %").addClass('progress-bar-warning')--}%

                %{--},parte*100)--}%
            %{--}--}%
        %{--});--}%
    %{--}--}%

    function cargarBarra (arreglo,total,parcial) {
        console.log("entro cargar barra")
        var periodo = $("#periodoId").val()
        $.ajax({
            type: 'POST',
            async: false,
            url:"${createLink(controller: 'procesos', action: 'procesaFacl')}",
            data:{
                arreglo:  arreglo,
                periodo: periodo,
                total: total,
                parcial: parcial
            },
            success: function (msg){
                var v = parseFloat(Math.round(msg * 100) / 100).toFixed(2);
                console.log("retorna", msg);
//                progress.percent(v);
                $('.progress-bar').css('width', msg+'%').attr('aria-valuenow', msg ).text(msg + " %").addClass('progress-bar-warning')
            }
        });
    }





</script>

</body>
</html>