<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/09/16
  Time: 12:02
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/09/16
  Time: 12:18
--%>

<div class="row-fluid"  style="width: 99.7%;height: 350px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 920px; height: 350px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${preguntas}" var="pregunta">
                    <tr data-id="${pregunta.id}">
                        <td style="width: 6%">${pregunta?.codigo}</td>
                        <td style="width: 50%">${pregunta?.descripcion}</td>
                        <td style="width: 5%">
                            <a href="#" class="btn btn-success btnAsignarPregunta" title="Asignar pregunta" data-id="${pregunta?.id}">
                                <i class="fa fa-plus"></i>
                            </a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(".btnAsignarPregunta").click(function () {
        var idPregunta = $(this).data("id");
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'prte', action: 'verificarPregunta_ajax')}',
            data:{
                    id: idPregunta,
                    encuesta: '${tipoEncuesta?.id}'
            },
            success: function (msg) {
                if(msg == 'no'){
                    $.ajax({
                        type:'POST',
                        url:"${createLink(controller: 'prte', action:'orden_ajax')}",
                        data:{
                            id: idPregunta
                        },
                        success: function (msg){
                            var b =  bootbox.dialog({
                                id: "dlgOrden",
                                title: "Asignar Orden",
                                class: "long",
                                message: msg,
                                buttons: {
                                    cancelar: {
                                        label: "Cancelar",
                                        className: "btn-primary",
                                        callback: function () {
                                        }
                                    },
                                    aceptar: {
                                        label: "Aceptar",
                                        className: "btn-success",
                                        callback: function () {
                                            var orden = $("#ordenE").val();
                                            var $form = $("#frmOrden");
                                            if(orden == '' ){
                                                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-info text-shadow'></i> Ingrese un número de orden");
                                                return false;
                                            }else{
                                                if($form.valid()){
                                                    $.ajax({
                                                        type: 'POST',
                                                        url: '${createLink(controller: 'prte', action: 'asignarPregunta_ajax')}',
                                                        data:{
                                                            pregunta: idPregunta,
                                                            encuesta: '${tipoEncuesta?.id}',
                                                            orden: orden
                                                        },
                                                        success: function (msg){
                                                            if(msg == 'ok'){
                                                                log("Pregunta asignada correctamente","success");
                                                                bootbox.hideAll();
                                                                cargarTablaPrte();
                                                            }else{
                                                                log("Error al asignar la pregunta","error")
                                                            }
                                                        }
                                                    });
                                                }else{
                                                    return false;
                                                }

                                            }

                                        }
                                    }
                                }
                            });

                        }
                    });
                }else{
                    bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-info text-shadow'></i> Esta pregunta ya se encuentra asignada!");
                    return false;
                }
            }
        });

    });
</script>
