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
    <div class="panel-body">

        <div class="progress progress-striped active">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">  <span class="fill" data-percentage="50"></span></div>

            %{--<div class="progress">--}%
                %{--<div class="progress-bar progress-bar-success" style="width: 35%">--}%
                    %{--<span class="sr-only">35% Complete (success)</span>--}%
                %{--</div>--}%
                %{--<div class="progress-bar progress-bar-warning progress-bar-striped" style="width: 20%">--}%
                    %{--<span class="sr-only">20% Complete (warning)</span>--}%
                %{--</div>--}%
                %{--<div class="progress-bar progress-bar-danger" style="width: 10%">--}%
                    %{--<span class="sr-only">10% Complete (danger)</span>--}%
                %{--</div>--}%
            %{--</div>--}%
        </div>

        <div class="container">
            <div class="row">

                <button type="button" class="btn btn-success btnCargar2"><i class="fa fa-check"></i> Iniciar el Proceso</button>

            </div>
        </div>


    </div>
</div>




<script type="text/javascript">


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
                console.log("msg " + msg.split("_"))
                var parts = msg.split("_");



                var tamano = (parts.length -1);
                var total = 0
                for(j=0;j<tamano;j++){
                    var pt = Math.round(parts[j])
                    total = pt + total
                }

                var tam = 100/(parts.length - 1)
//                var formateado = parseFloat(Math.round(tam * 100) / 100).toFixed(2);


                for(i = 0; i < (parts.length - 1); i++){
//                    console.log("iiiii " + i + "_ " + formateado + i)

                    var valor = (parts[i]*100)/total;

                    var formateado = parseFloat(Math.round(valor * 100) / 100).toFixed(2);
                    console.log("valor " +  formateado)
                        cargarBarra(formateado,i);


                    %{--$.ajax({--}%
                        %{--type: 'POST',--}%
                        %{--url:"${createLink(controller: 'procesos', action: 'prueba')}",--}%
                        %{--data:{--}%

                        %{--},--}%
                        %{--success: function (msg){--}%
                        %{--$('.progress-bar').css('width', msg+'%').attr('aria-valuenow', msg ).text(msg + " %").removeClass('progress-bar-warning').removeClass('progress-bar-success');--}%
                        %{--return true--}%
                        %{--}--}%
                    %{--});--}%

                }

                %{--if(msg == 1){--}%
                    %{--$('.progress-bar').css('width', 10+'%').attr('aria-valuenow', 10).text(10 + " %").removeClass('progress-bar-warning').removeClass('progress-bar-success');--}%
                    %{--setTimeout(function () {--}%

                        %{--$.ajax({--}%
                            %{--type: 'POST',--}%
                            %{--async: false,--}%
                            %{--url:"${createLink(controller: 'procesos', action: 'progreso')}",--}%
                            %{--data:{},--}%
                            %{--success: function (msg) {--}%
                                %{--if (msg == 1) {--}%
                                    %{--$('.progress-bar').css('width', 40 + '%').attr('aria-valuenow', 40).addClass('progress-bar-warning').text(40 + " %");--}%
                                    %{--setTimeout(function () {--}%
                                        %{--$.ajax({--}%
                                            %{--type: 'POST',--}%
                                            %{--url:"${createLink(controller: 'reportes2', action: 'progreso')}",--}%
                                            %{--data:{},--}%
                                            %{--success: function (msg){--}%
                                                %{--if(msg == 1){--}%
                                                    %{--$('.progress-bar').css('width', 100+'%').attr('aria-valuenow', 100).removeClass('progress-bar-warning').addClass('progress-bar-success').text(100 + " %");--}%
                                                %{--}--}%
                                            %{--}--}%

                                        %{--});--}%


                                    %{--},3000)--}%
                                %{--}--}%
                            %{--}--}%
                        %{--});--}%

                    %{--},5000)--}%

                %{--}--}%

            }
        })
    });

    var n = 0


    function cargarBarra (parte,itera) {
//        console.log("entro "+ itera)
        $.ajax({
            type: 'POST',
            url:"${createLink(controller: 'procesos', action: 'prueba')}",
            data:{
                parte: parte,
                itera: itera,
                n: n
            },
            success: function (msg){

                setTimeout(function () {

//                    if(itera == 0){
                        $('.progress-bar').css('width', msg+'%').attr('aria-valuenow', msg ).text(msg + " %").addClass('progress-bar-warning')
//                    }else{
//                        $('.progress-bar').add($('.progress-bar').css('width', msg+'%').attr('aria-valuenow', msg ).text(msg + " %").addClass('progress-bar-success'))
//                    }

                    n += parte

                },parte*100)


            }
        });
    }




</script>

</body>
</html>