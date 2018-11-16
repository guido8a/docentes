<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 27/09/18
  Time: 10:20
--%>

<g:if test="${auxiliaresInstanceList}">

    <table class="table table-bordered table-hover table-condensed">
        <tbody>
        <g:each in="${auxiliaresInstanceList}" status="i" var="auxiliaresInstance">
            <tr data-id="${auxiliaresInstance.id}">
                <td style="width: 9%"><strong>${auxiliaresInstance?.periodo?.nombre}</strong></td>
                <td style="width: 8%">${auxiliaresInstance?.minimo?.toInteger()}</td>
                <td style="width: 8%">${auxiliaresInstance?.optimo?.toInteger()}</td>
                <td style="width: 13%">${auxiliaresInstance?.maximoDirectivos}</td>
                <td style="width: 13%">${auxiliaresInstance?.maximoPares}</td>
                <td style="width: 14%">${auxiliaresInstance?.maximoAutoevaluacion}</td>
                <td style="width: 13%">${auxiliaresInstance?.maximoEstudiantes}</td>
                <td style="width: 11%">${auxiliaresInstance?.fechaInicio?.format('yyyy-MM-dd')}</td>
                <td style="width: 11%">${auxiliaresInstance?.fechaCierre ? auxiliaresInstance?.fechaCierre?.format('yyyy-MM-dd') : ''}</td>
            </tr>
        </g:each>
        </tbody>
    </table>

</g:if>
<g:else>
    <div class="panel panel-warning col-md-12">
        <div class="panel-heading" style="text-align: center">
            <h3 class="panel-title" style="height: 30px; margin-top: 15px">
                La universidad seleccionada no tiene parámetros
            </h3>
        </div>
    </div>
</g:else>

<script type="text/javascript">

    $(function () {

        $("tbody tr").contextMenu({
            items  : {
                header   : {
                    label  : "Acciones",
                    header : true
                },
                ver      : {
                    label  : "Ver",
                    icon   : "fa fa-search",
                    action : function ($element) {
                        var id = $element.data("id");
                        location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}/" + id + "?ver=" + 1 + "?tipo=" + 1
                    }
                },
                fechas   : {
                    label  : "Fechas",
                    icon   : "fa fa-calendar",
                    action : function ($element) {
                        var id = $element.data("id");
                        $.ajax({
                            type: "POST",
                            url: "${createLink(controller: 'auxiliares', action: 'fechas_ajax')}",
                            data: {
                                id: id
                            },
                            success: function (msg) {
                                var b = bootbox.dialog({
                                    id: "dlgEditarFechas",
                                    title: "Editar Fechas",
                                    message: msg,
                                    class: "small",
                                    buttons: {
                                        cierre: {
                                            label: "<i class='fa fa-exclamation-circle'></i> Sin fecha de Cierre",
                                            className: "btn-warning",
                                            callback: function () {
                                                $("#fechaFin").val(null);
                                                return false
                                            }
                                        },
                                        cancelar: {
                                            label: "Cancelar",
                                            className: "btn-primary",
                                            callback: function () {
                                            }
                                        },
                                        guardar: {
                                            id: "btnSave",
                                            label: "<i class='fa fa-save'></i> Guardar",
                                            className: "btn-success",
                                            callback: function () {
                                                $.ajax({
                                                    type: 'POST',
                                                    url: "${createLink(controller: 'auxiliares', action: 'guardarFecha_ajax')}",
                                                    data:{
                                                        id: id,
                                                        fechaInicio: $("#fechaInicio").val(),
                                                        fechaFin: $("#fechaFin").val()
                                                    },
                                                    success: function (msg) {
                                                        if(msg == 'ok'){
                                                            log("Fecha guardada correctamente","success");
                                                            setTimeout(function () {
                                                                location.reload(true);
                                                            }, 800);
                                                        }else{
                                                            log("Error al guardar la fecha","error")
                                                        }
                                                    }
                                                });
//                                                        return submitForm(tipo);
                                            } //callback
                                        } //guardar
                                    } //buttons
                                }); //dialog
                            } //success
                        }); //ajax
                    }
                },
                editar   : {
                    label  : "Editar",
                    icon   : "fa fa-pencil",
                    action : function ($element) {
                        var id = $element.data("id");
//                                createEditRow(id);
                        %{--location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}/" + id--}%
                        location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}?id=" + id + "&tipo=" + 2

                    }
                }
//                        ,
//                        eliminar : {
//                            label            : "Eliminar",
//                            icon             : "fa fa-trash-o",
//                            separator_before : true,
//                            action           : function ($element) {
//                                var id = $element.data("id");
//                                deleteRow(id);
//                            }
//                        }
            },
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });


    });


</script>


