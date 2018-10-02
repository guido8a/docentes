<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/09/16
  Time: 11:23
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/09/16
  Time: 11:42
--%>

<g:if test="${respuestas}">
    %{--<div class="row-fluid"  style="width: 99.7%;height: 300px;overflow-y: auto;float: right;">--}%
        <div class="col-md-12">
            %{--<div style="width: 960px; height: 300px;">--}%
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <g:each in="${respuestas}" var="respuesta">
                        <tr data-id="${respuesta.id}">
                            <td style="width: 8%">${respuesta?.respuesta?.codigo}</td>
                            <td style="width: 33%">${respuesta.respuesta?.descripcion}</td>
                            <td style="width: 14%">${respuesta?.valor}</td>
                            <td style="width: 8%" class="${pregunta?.estado == 'N' ? '' : 'hidden'}">
                            <a href="#" class="btn btn-success btnEditar ${pregunta?.estado == 'N' ? '' : 'hidden'}" data-id="${respuesta.id}"  title="Editar la respuesta">
                                <i class="fa fa-pencil"></i>
                            </a>
                                <a href="#" class="btn btn-danger btnBorrar ${pregunta?.estado == 'N' ? '' : 'hidden'}" data-id="${respuesta.id}"  title="Borrar la respuesta">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            %{--</div>--}%
        </div>
    %{--</div>--}%
</g:if>
<g:else>
    <div class="row-fluid"  style="width: 99.7%;height: 180px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 960px; height: 180px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <tr>
                        <td style="width: 100%"><div class="text-info text-center not-found"><i class="fa-2x pull-center text-shadow">La pregunta no tiene ninguna respuesta asignada.</i></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:else>

<script type="text/javascript">

    $(".btnEditar").click(function () {
        var idPR = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action: 'editarRespuesta_ajax')}',
            data:{
                id: idPR
            },
            success: function (msg){
                var b =  bootbox.dialog({
                    id      : "dlgEditarRespuesta",
                    title   : "Editar Respuesta",
                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "Aceptar",
                            className : "btn-success",
                            callback  : function () {

                                if($("#valoracionEditar").val() == ''){
                                    bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Debe ingresar un valor numérico en valoración!")
                                    return false;
                                }else{
                                    $.ajax({
                                        type: 'POST',
                                        url: '${createLink(controller: 'pregunta', action: 'editarSave_ajax')}',
                                        data:{
                                            id: idPR,
                                            valor: $("#valoracionEditar").val()
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Valoración de la respuesta actualizada correctamente","success");
                                                cargarTablaRespuestas();
                                            }else{
                                                log("Error al actualizar la valoración de la respuesta","error")
                                            }
                                        }
                                    });
                                }
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $(".btnBorrar").click(function () {
        var idPR = $(this).data("id");
        bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de borrar esta respuesta?", function (result) {
            if (result) {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'pregunta', action: 'borrarRespuesta_ajax')}',
                    data:{
                        id: idPR
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            log("Respuesta borrada correctamente","success");
                            cargarTablaRespuestas();
                            cargarRespuesta();
                        }else{
                            log("Error al borrar la respuesta","error")
                        }
                    }
                });
            }
        });
    });

</script>

