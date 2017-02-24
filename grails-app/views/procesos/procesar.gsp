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


        <div class="progress progress-striped active row">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">  <span class="fill" data-percentage="50"></span></div>
        </div>

        <div class="row">
            <button type="button" class="btn btn-success btnCargar2"><i class="fa fa-check"></i> Iniciar el Proceso</button>
        </div>
    </div>
</div>


<div class="row divFacultad" style="text-align: center">
    <div class="alert alert-warning" role="alert" style="height: 265px"></div>
</div>


<script type="text/javascript">

    var url = "${resource(dir:'images', file:'spinner64.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' width='40px' height='40px'/><span> Procesando...</span>");

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
                $(".btnCargar2").replaceWith(spinner);
//                console.log("msg " + msg)
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
                    $(".divfacultad").html("<h4>Inciando proceso de datos...</h4>")
                    cargarBarra(parts[i],total,parcial);
                    cargarDescripcion(parts[i])
                }
            }
        })
    });


    function cargarBarra (arreglo,total,parcial) {
//        console.log("entro cargar barra")
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
                var v = parseFloat(Math.round(msg * 100) / 100).toFixed(1);
//                progress.percent(v);
                $('.progress-bar').css('width', v + '%').attr('aria-valuenow', v).text(v + " %").addClass('progress-bar-success');
                if(msg == 100){
                    setTimeout(function () {
                        bootbox.dialog({
                            title   : "",
                            message : "<i class='fa fa-check fa-3x pull-left text-success text-shadow'></i><p>Encuestas procesadas correctamente!</p>",
                            buttons : {
                                cancelar : {
                                    label     : "<i class='fa fa-close'></i> Aceptar",
                                    className : "btn-success",
                                    callback  : function () {
                                        %{--location.href=${createLink(controller:'inicio', action: 'index')}--}%
                                        location.href="${createLink(controller:'procesos', action: 'totales')}/" + periodo
                                    }
                                }
                            }
                        });
                    }, 1000)
                }

            }
        });
    }

    function cargarDescripcion (parte) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'procesos', action: 'descripcion_ajax')}',
            data:{
                parte: parte
            },
            success: function (msg){
                $(".divfacultad").html(msg)
            }
        });
    }

</script>

</body>
</html>