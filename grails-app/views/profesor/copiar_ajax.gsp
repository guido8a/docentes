<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 12/09/16
  Time: 10:38
--%>

<div class="btn-group">
    <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Copiar Período <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
            <g:each in="${lista}" var="periodo" >
                <li><a href="#" class="btnCopiarPeriodo" data-id="${periodo.id}">${periodo?.nombre}</a></li>
            </g:each>
    </ul>
</div>


<script type="text/javascript">

        $(".btnCopiarPeriodo").click(function () {
            var porCopiar = $(this).data('id');
            $.ajax({
               type: 'POST',
                url: '${createLink(controller: 'profesor', action: 'verificar_ajax')}',
                data:{
                    profesor: '${profesor?.id}',
                    periodo: ${periodo?.id}
                },
                success: function (msg){
                    if(msg == 'ok'){

                        $.ajax({
                            type: 'POST',
                            url: "${createLink(controller: 'profesor', action: 'dialogoCopiar_ajax')}",
                            data:{
                                id: '${profesor?.id}',
                                periodoActual: ${periodo?.id},
                                periodoCopiar : porCopiar
                            },
                            success: function (msg){
                                bootbox.dialog({
                                    id: "dlgCopiar",
                                    title: "Copiar Período",
                                    message: msg,
                                    buttons: {
                                        acpetar :{
                                            label     : '<i class="fa fa-save"></i> Aceptar',
                                            className : 'btn-success',
                                            callback  : function () {
                                                $.ajax({
                                                   type: 'POST',
                                                    url: '${createLink(controller: 'profesor', action:'guardarCopia_ajax')}',
                                                    data:{
                                                        idProfe: '${profesor?.id}',
                                                        actual: ${periodo?.id},
                                                        copiar : porCopiar
                                                    },
                                                    success: function (msg) {
                                                        if(msg == 'ok'){
                                                            log("Materias asignadas correctamente","success");
                                                            cargarTablaMaterias(${periodo?.id});
                                                        }else{
                                                            log("Error al asignar las materias","error")
                                                        }
                                                    }
                                                });
                                            }
                                        },
                                        cancelar :{
                                            label     : '<i class="fa fa-close"></i> Cancelar',
                                            className : 'btn-primary',
                                            callback  : function () {
                                            }
                                        }
                                    }
                                }).off("shown.bs.modal")
                            }
                        });


                    }else{
                        log("No se puede asignar las materias al profesor. </br> Ya tiene materias asignadas. </br> <strong>Necesita borrarlas primero antes de copiar.</strong>", "error")
                    }
                }
            });
        })

</script>