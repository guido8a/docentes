<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 20/09/16
  Time: 12:58
--%>

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

<g:if test="${items}">
    <div class="row-fluid"  style="width: 99.7%;height: 300px;overflow-y: auto;float: right;">
        <div class="span12">
            %{--<div style="width: 960px; height: 300px;">--}%
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <g:each in="${items}" var="item">
                        <tr data-id="${item.id}">
                            %{--<td style="width: 8%">${item?.pregunta?.codigo}</td>--}%
                            <td style="width: 4%">${item?.orden}</td>
                            <td style="width: 40%">${item?.descripcion}</td>
                            <td style="width: 4%">${item?.tipo}</td>
                            <td style="width: 5%" class="${item?.pregunta?.estado == 'N' ? '' : 'hidden'}">
                                <a href="#" class="btn-sm btn-success btnEditarItem ${item?.pregunta?.estado == 'N' ? '' : 'hidden'}" data-id="${item?.id}"  title="Editar el item">
                                    <i class="fa fa-pencil"></i>
                                </a>
                                <a href="#" class="btn-sm btn-danger btnBorrarItem ${item?.pregunta?.estado == 'N' ? '' : 'hidden'}" data-id="${item?.id}"  title="Borrar el item">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            %{--</div>--}%
        </div>
    </div>
</g:if>
<g:else>
    <div class="row-fluid"  style="width: 99.7%;height: 180px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 960px; height: 180px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <tr>
                        <td style="width: 100%"><div class="text-info text-center not-found"><i class="fa-2x pull-center text-shadow">La pregunta no tiene items asignados.</i></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:else>

<script type="text/javascript">

    $(".btnEditarItem").click(function () {
        var idI = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action: 'editarItem_ajax')}',
            data:{
                id: idI
            },
            success: function (msg){
                var b =  bootbox.dialog({
                    id      : "dlgEditarItem",
                    title   : "Editar Item de la Pregunta",
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

                                var descripcion = $("#descripcionItemEditar").val();
                                var orden = $("#ordenItemEditar").val();
                                var tipo = $("#tipoItemEditar").val();


                                if(descripcion == '' || orden == ''){
                                    bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Debe ingresar todos los datos solicitados!");
                                    return false;
                                }else{
                                    $.ajax({
                                        type: 'POST',
                                        url: '${createLink(controller: 'pregunta', action : 'guardarItem_ajax')}',
                                        data:{
                                            pregunta: '${pregunta.id}',
                                            descripcion: descripcion,
                                            orden: orden,
                                            tipo: tipo,
                                            id: idI
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Item guardado correctamente","success");
                                                cargarTablaItems();
                                            }else{
                                                log("Error al guardar el item","error")
                                            }
                                        }
                                    })
                                }
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $(".btnBorrarItem").click(function () {
        var idItem = $(this).data("id");
        bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de borrar este item?", function (result) {
            if (result) {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'pregunta', action: 'borrarItem_ajax')}',
                    data:{
                        id: idItem
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            log("Item borrado correctamente","success");
                            cargarTablaItems();
                        }else{
                            log("Error al borrar el item","error")
                        }
                    }
                });
            }
        });
    });

</script>

