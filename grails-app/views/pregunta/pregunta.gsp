<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/09/16
  Time: 12:15
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
        <g:link controller="pregunta" action="list" class="btn btn-primary" title="Regresar a la lista de preguntas">
            <i class="fa fa-chevron-left"></i> Lista
        </g:link>

        <g:if test="${preguntaInstance}">
            <g:if test="${preguntaInstance?.estado == 'N'}">
                <a href="#" class="btn btn-success btnGuardar" >
                    <i class="fa fa-save"></i> Guardar
                </a>
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
            <a href="#" class="btn btn-success btnGuardar" >
                <i class="fa fa-save"></i> Guardar
            </a>
        </g:else>
        <g:link controller="pregunta" action="pregunta" class="btn btn-info">
            <i class="fa fa-file-o"></i> Nuevo
        </g:link>

    </div>
</div>

<div class="row">
    <div class="col-md-1 negrilla control-label">Variable: </div>
    <div class="col-md-4">
        <g:select name="variable" id="variableId" optionKey="id" optionValue="descripcion"
                  class="form-control" from="${docentes.Variables.list([sort: 'descripcion', order: 'asc'])}" value="${preguntaInstance?.variables?.id}" disabled="${preguntaInstance?.estado == 'R'}"/>
    </div>
    <div class="col-md-1 negrilla control-label">Tipo de Valoración: </div>
    <div class="col-md-2">
        <g:select name="vloración" id="valoracionId" optionKey="id" optionValue="descripcion"
                  class="form-control" from="${docentes.TipoRespuesta.list([sort: 'descripcion', order: 'asc'])}" value="${preguntaInstance?.tipoRespuesta?.id}" disabled="${preguntaInstance?.estado == 'R'}"/>
    </div>
    <div class="col-md-1 negrilla control-label">Estado: </div>
    <div class="col-md-1">
        <g:textField name="estado_name" id="estadoPregunta" value="${preguntaInstance ? preguntaInstance?.estado : 'N'}" class="form-control" readonly="true" title="${preguntaInstance?.estado == 'R' ? 'Registrado' : 'No Registrado'}"/>
    </div>
</div>

<div class="row">
    <div class="col-md-1 negrilla control-label">Código: </div>
    <div class="col-md-1">
        <g:textField name="codigo_name" id="codigoPregunta" value="${preguntaInstance?.codigo}" class="allCaps form-control required" maxlength="8" readonly="${preguntaInstance?.estado == 'R'}"/>
    </div>
    <div class="col-md-1 negrilla control-label">Respuestas: </div>
    <div class="col-md-1">
        <g:textField name="numero_name" id="numeroRespuestas" value="${preguntaInstance?.numeroRespuestas}" class="form-control required number" readonly="${preguntaInstance?.estado == 'R'}"/>
    </div>
    <div class="col-md-1 negrilla control-label">Estrategia: </div>
    <div class="col-md-5">
        <g:textArea name="estrategia_name" id="estrategiaPregunta" value="${preguntaInstance?.estrategia}" class="form-control" maxlength="127" style="resize: none" readonly="${preguntaInstance?.estado == 'R'}"/>
    </div>
</div>
<div class="row">
    <div class="col-md-1 negrilla control-label">Pregunta: </div>
    <div class="col-md-9">
        <g:textArea name="descripcion_name" id="descripcionPregunta" value="${preguntaInstance?.descripcion}" class="form-control required" maxlength="255" style="height: 80px; resize: none; margin-bottom: 20px" readonly="${preguntaInstance?.estado == 'R'}"/>
    </div>
</div>

<div class="col-md-12 ${preguntaInstance ? '' : 'hidden'}">
    <ul class="nav nav-pills">
        <li class="active col-md-5"><a data-toggle="tab" href="#home">Respuestas</a></li>
        <li class="col-md-5"><a data-toggle="tab" href="#itemsTab">Items</a></li>
    </ul>

    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">

            <div class="row">

                <div class="col-md-1 negrilla control-label">Respuesta: </div>
                <div class="col-md-5" id="divRespuesta">
                </div>

                <div class="col-md-1 negrilla control-label">Código: </div>
                <div class="col-md-1" id="divCodigo">
                </div>

                <div class="col-md-1 negrilla control-label">Valoración: </div>
                <div class="col-md-1" id="divValoracion">
                </div>

                <a href="#" id="btnAgregar" class="btn btn-success ${preguntaInstance?.estado == 'N' ? '' : 'hidden'}" title="">
                    <i class="fa fa-plus"></i>
                </a>
            </div>

            <div class="col-md-11">
                <table class="table table-condensed table-bordered table-striped" style="margin-top: 20px">
                    <thead>
                    <tr>
                        <th style="width: 8%">Código</th>
                        <th style="width: 33%">Respuesta</th>
                        <th style="width: 14%">Valoración</th>
                        <th style="width: 8%" class="${preguntaInstance?.estado == 'N' ? '' : 'hidden'}">Acciones</th>
                    </tr>
                    </thead>
                </table>

                <div id="divTablaRespuestas">

                </div>
            </div>

        </div>
        <div id="itemsTab" class="tab-pane fade">

            <div class="row ${preguntaInstance?.estado == 'R' ? 'hidden' : ''}">

                <div class="col-md-1 negrilla control-label">Descripción: </div>
                <div class="col-md-5">
                    <g:textField name="descripcionItem_name" id="descripcionItem" class="form-control required" maxlength="127" />
                </div>

                <div class="col-md-1 negrilla control-label">Orden: </div>
                <div class="col-md-1">
                    <g:textField name="ordenItem_name" id="ordenItem" class="form-control required number" maxlength="2" />
                </div>

                <div class="col-md-1 negrilla control-label">Tipo: </div>
                <div class="col-md-1">
                    %{--<g:textField name="tipoItem_name" id="tipoItem" class="allCaps form-control required" maxlength="1"/>--}%
                    <g:select name="tipoItem_name" id="tipoItem" class="form-control" from="${['A','B']}"/>
                </div>

                <a href="#" id="btnAgregarItem" class="btn btn-success ${preguntaInstance?.estado == 'N' ? '' : 'hidden'}" title="">
                    <i class="fa fa-plus"></i>
                </a>
            </div>


            <div class="col-md-11">
                <table class="table table-condensed table-bordered table-striped" style="margin-top: 20px">
                    <thead>
                    <tr>
                        %{--<th style="width: 8%">Pregunta</th>--}%
                        <th style="width: 8%">Orden</th>
                        <th style="width: 30%">Descripción</th>
                        <th style="width: 8%">Tipo</th>
                        <th style="width: 9%" class="${preguntaInstance?.estado == 'N' ? '' : 'hidden'}">Acciones</th>
                    </tr>
                    </thead>
                </table>

                <div id="divTablaItems">

                </div>
            </div>


        </div>
    </div>
</div>

<script type="text/javascript">

    $("#btnAgregarItem").click(function () {
        var descripcion = $("#descripcionItem").val();
        var orden = $("#ordenItem").val();
        var tipo = $("#tipoItem").val();

        if(descripcion == '' || orden == ''){
            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Debe ingresar todos los datos solicitados!")
            return false;
        }else{
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'pregunta', action : 'guardarItem_ajax')}',
                data:{
                    pregunta: '${preguntaInstance?.id}',
                    descripcion: descripcion,
                    orden: orden,
                    tipo: tipo
                },
                success: function (msg){
                    if(msg == 'ok'){
                        log("Item agregado correctamente","success");
                        cargarTablaItems();
                    }else{
                        log("Error al agregar el item","error")
                    }
                }
            })
        }
    });

    $(".btnRegistrar").click(function () {
        var idPregunta = ${preguntaInstance?.id}
                bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de registrar esta pregunta?", function (result) {
                    if (result) {
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'pregunta', action: 'registrar_ajax')}',
                            data:{
                                id: '${preguntaInstance?.id}'
                            },
                            success: function (msg){
                                if(msg == 'ok'){
                                    log("Pregunta registrada correctamente","success");
                                    setTimeout(function () {
                                        location.href='${createLink(controller: 'pregunta', action: 'pregunta')}/' + idPregunta
                                    }, 800);
                                }else{
                                    log("Error al registrar la pregunta","error")
                                }
                            }
                        });
                    }
                });
    });

    $(".btnDesregistrar").click(function () {
        var idPregunta = ${preguntaInstance?.id}
                bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de desregistrar esta pregunta?", function (result) {
                    if (result) {
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'pregunta', action: 'desregistrar_ajax')}',
                            data:{
                                id: '${preguntaInstance?.id}'
                            },
                            success: function (msg){
                                if(msg == 'ok'){
                                    log("Pregunta desregistrada correctamente","success");
                                    setTimeout(function () {
                                        location.href='${createLink(controller: 'pregunta', action: 'pregunta')}/' + idPregunta
                                    }, 800);
                                }else{
                                    log("Error al desregistrar la pregunta","error")
                                }
                            }
                        });
                    }
                });


    });

    $(".btnGuardar").click(function () {
        var variable = $("#variableId").val();
        var tipoRespuesta = $("#valoracionId").val();
        var codigo = $("#codigoPregunta").val();
        var numero = $("#numeroRespuestas").val();
        var estrategia = $("#estrategiaPregunta").val();
        var pregunta = $("#descripcionPregunta").val();
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'pregunta', action: 'guardarPregunta_ajax')}',
            data:{
                id: '${preguntaInstance?.id}',
                variable: variable,
                valoracion: tipoRespuesta,
                codigo: codigo,
                numero: numero,
                estrategia: estrategia,
                pregunta: pregunta

            },
            success: function (msg) {
                var parts = msg.split("_");
                if(parts[0] == 'ok'){
                    log("Información guardada correctamente","success");
                    setTimeout(function () {
                        location.href='${createLink(controller: 'pregunta', action: 'pregunta')}/' + parts[1]
                    }, 800);
                }else{
                    log("Error al guardar la información","error")
                }
            }
        });
    });

    $("#btnAgregar").click(function () {
        var idRespuesta = $("#respuestaNueva").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action : 'agregarRespuesta_ajax')}',
            data:{
                id: '${preguntaInstance?.id}',
                respuesta: idRespuesta,
                valor: $("#valoracionRespuesta").val()
            },
            success: function (msg){
                if(msg == 'ok'){
                    log("Respuesta agregada correctamente","success");
                    cargarTablaRespuestas();
                    cargarRespuesta();
                }else{
                    log("Error al agregar la respuesta","error")
                }
            }
        })
    });


    function cargarRespuesta () {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action : 'respuesta_ajax')}',
            data:{
                id: '${preguntaInstance?.id}'
            },
            success: function (msg){
                $("#divRespuesta").html(msg)
            }
        })
    }


    if('${preguntaInstance}'){
        cargarRespuesta ();
        cargarTablaRespuestas();
        cargarTablaItems();
    }


    function cargarTablaRespuestas () {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action: 'tablaRespuestas_ajax')}',
            data:{
                id: '${preguntaInstance?.id}'
            },
            success: function(msg){
                $("#divTablaRespuestas").html(msg)
            }
        });
    }

    function cargarTablaItems () {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action: 'tablaItems_ajax')}',
            data:{
                id: '${preguntaInstance?.id}'
            },
            success: function(msg){
                $("#divTablaItems").html(msg)
            }
        });
    }

</script>

</body>
</html>