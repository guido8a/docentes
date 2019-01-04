<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/12/18
  Time: 14:35
--%>



<%@ page import="docentes.Pregunta" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Orden de Preguntas</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="pregunta" action="list" class="btn btn-primary">
            <i class="fa fa-chevron-left"></i> Regresar
        </g:link>
    </div>
    %{--<div class="col-md-2"></div>--}%

    %{--<div class="col-md-1"><label>Tipo de Encuesta:</label></div>--}%
    <div class="col-md-3" style="margin-left: 20px">
        <label>Tipo de Encuesta:</label>
        <g:select class="form-control" from="${docentes.TipoEncuesta.list().sort{it.descripcion}}" optionKey="id" optionValue="descripcion" name="tipoEncuesta_name" id="tipoEncuesta"/>
    </div>

    %{--<div class="col-md-1"><label>Pregunta:</label></div>--}%

    <div class="col-md-6">
        <label>Pregunta:</label>
        %{--<g:select from="${preguntasF}" optionKey="id" optionValue="descripcion" name="preguntaF_name" id="preguntaF" class="form-control selectpicker" data-divider="true"/>--}%
        <div id="divPreg">

        </div>

    </div>

    <div class="col-md-1" style="margin-top: 20px">
        <a href="#" class="btn btn-info" id="btnAgregarPregunta"><i class="fa fa-plus"></i> Agregar </a>
    </div>
</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr style="width: 100%">
        <th style="width: 8%">Código</th>
        <th style="width: 64%">Descripción</th>
        <th style="width: 9%">Orden Actual</th>
        <th style="width: 12%">Orden Nuevo</th>
        <th style="width: 4%; text-align: center"><i class="fa fa-trash-o"></i></th>
        <th style="width: 2%"></th>
    </tr>
    </thead>
</table>

<div id="divTablaPreguntas">

</div>

<script type="text/javascript">

    cargarPreg();

    function cargarPreg () {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'pregunta', action: 'pregunta_ajax')}",
            data:{

            },
            success: function (msg) {
                $("#divPreg").html(msg)
            }
        })
    }

    $("#btnAgregarPregunta").click(function () {
        var pregunta = $("#preguntaF option:selected").val();
        var encuesta = $("#tipoEncuesta option:selected").val();
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'pregunta', action: 'agregarPregunta_ajax')}",
            data:{
                pregunta: pregunta,
                encuesta: encuesta
            },
            success: function (msg) {
                if(msg == 'ok'){
                    log("Pregunta asignada correctamente","success");
                    setTimeout(function () {
                        cargarTablaPreguntas($("#tipoEncuesta option:selected").val());
                        cargarPreg();
                    }, 800);
                }else{
                    log("Error al asignar la pregunta","error");
                }
            }
        });
    });

    $("#tipoEncuesta").change(function () {
        cargarTablaPreguntas($("#tipoEncuesta option:selected").val());
    });

    cargarTablaPreguntas($("#tipoEncuesta option:selected").val());

    function cargarTablaPreguntas(tipo){
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'pregunta', action: 'tablaOrden_ajax')}",
            data:{
                tipoEncuesta: tipo
            },
            success: function (msg) {
                $("#divTablaPreguntas").html(msg)
            }
        });
    }

</script>

</body>
</html>
