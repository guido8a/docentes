<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/09/16
  Time: 10:23
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Preguntas a aplicarse en la encuesta</title>
</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="tipoEncuesta" action="list" class="btn btn-primary" title="Regresar a la lista de preguntas">
            <i class="fa fa-chevron-left"></i> Lista
        </g:link>

        <g:if test="${preguntaInstance}">
            <g:if test="${preguntaInstance?.estado == 'N'}">
                %{--<a href="#" class="btn btn-success btnGuardar" >--}%
                    %{--<i class="fa fa-save"></i> Guardar--}%
                %{--</a>--}%
                <a href="#" class="btn btn-warning btnRegistrar" title="Registrar la pregunta">
                    <i class="fa fa-check-circle-o"></i> Registrar
                </a>

            </g:if>
            <g:else>
                <a href="#" class="btn btn-danger btnDesregistrar" title="Desregistrar la pregunta">
                    <i class="fa fa-check-circle-o"></i> Desregistrar
                </a>
            </g:else>
        </g:if>
        <g:else>

        </g:else>
        %{--<g:link controller="pregunta" action="pregunta" class="btn btn-info">--}%
            %{--<i class="fa fa-file-o"></i> Nuevo--}%
        %{--</g:link>--}%

    </div>
</div>

<div class="row">
    <div class="col-md-1 negrilla control-label">Código: </div>
    <div class="col-md-1" id="divCodigo">
    </div>
    <div class="col-md-2 negrilla control-label">Tipo de Encuesta: </div>
    <div class="col-md-4">
        <g:select name="tipoEncuesta_name" id="tipoEncuestaId" optionKey="id" optionValue="descripcion"
                  class="form-control" from="${docentes.TipoEncuesta.list([sort: 'descripcion', order: 'asc'])}" value="${tipoEncuesta?.id}" disabled="${tipoEncuesta ? 'true' : 'false'}"/>
    </div>
</div>

<div class="panel panel-info col-md-12" style="margin-top: 20px" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 35px; padding-left: 10px; padding-right: 110px">
            <div class="col-md-7" style="float: left">
                Preguntas a aplicarse en la encuesta
            </div>

        </h3>
    </div>
    <div class="panel-body">
        <div class="list-group" style="text-align: center">

            <div class="row">
                <div class="col-md-1 negrilla control-label">Preguntas: </div>
                <div class="col-md-9">
                    <g:textField name="preguntas_name" id="preguntasId" class="form-control" placeholder="Seleccione la pregunta..."/>
                </div>
            </div>


            <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
                <thead>
                <tr>
                    <th style="width: 7%">Código</th>
                    <th style="width: 6%">Orden</th>
                    <th style="width: 47%">Pregunta</th>
                    <th style="width: 7%">Acciones</th>
                </tr>
                </thead>
            </table>

            <div id="divTablaPreguntas">

            </div>

        </div>
    </div>
</div>



<script type="text/javascript">


    cargarTablaPrte();

    function cargarTablaPrte(){
        var idEncuesta = $("#tipoEncuestaId").val();
    $.ajax({
       type: 'POST',
        url: '${createLink(controller: 'prte', action: 'tablaPrte_ajax')}',
        data: {
            id: idEncuesta
        },
        success: function (msg){
        $("#divTablaPreguntas").html(msg)
        }
    });
    }


    $("#preguntasId").click(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'prte', action:'buscarPregunta_ajax')}",
            data    : {
                id: '${tipoEncuesta?.id}'
            },
            success : function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgBuscadorPreguntas",
                    title   : "Buscar Preguntas",
                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax

    });


    cargarCodigoTipoEncuesta();

    function cargarCodigoTipoEncuesta () {
        var idE = $("#tipoEncuestaId").val();
        $.ajax({
           type: 'POST',
            url: '${createLink(controller: 'prte', action: 'codigo_ajax')}',
            data:{
                id: idE
            },
            success: function (msg){
                $("#divCodigo").html(msg)
            }
        });
    }
</script>

</body>
</html>