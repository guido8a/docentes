<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/09/18
  Time: 11:17
--%>

<g:if test="${estudiantes}">
    <div class="" style="width: 99.7%;height: 450px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover" width="100%">
            <tbody>
            <g:each in="${estudiantes}" var="estudiante">
                <tr data-id="${estudiante?.id}" data-uni="${universidad?.id}">
                    <td style="width: 20%">${estudiante?.cedula}</td>
                    <td style="width: 40%">${estudiante?.apellido}</td>
                    <td style="width: 40%">${estudiante?.nombre}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <g:if test="${estudiantes.size() > 20}">
        <div class="panel panel-info col-md-12" style="margin-top: 10px" >
            <div class="panel-heading">
                * Máxima cantidad de registros en pantalla 20
            </div>
        </div>
    </g:if>
</g:if>
<g:else>
    <div class="row-fluid"  style="width: 99.7%;height: 200px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 100%; height: 100px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <tr>
                        <td style="width: 100%"><div class="text-info text-center not-found"><i class="fa-2x pull-center text-shadow fa fa-close"> No existen registros.</i></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
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
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(action:'show_ajax')}",
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                bootbox.dialog({
                                    title   : "Ver datos del estudiante",
                                    message : msg,
                                    buttons : {
                                        ok : {
                                            label     : "Aceptar",
                                            className : "btn-primary",
                                            callback  : function () {
                                            }
                                        }
                                    }
                                });
                            }
                        });
                    }
                },
                editar   : {
                    label  : "Editar",
                    icon   : "fa fa-pencil",
                    action : function ($element) {
                        var id = $element.data("id");
                        var unive = $element.data("uni");
                        location.href="${createLink(controller: 'estudiante', action: 'estudiante')}?id=" + id + '&universidad=' + unive
                    }
                },
                eliminar : {
                    label            : "Eliminar",
                    icon             : "fa fa-trash-o",
                    separator_before : true,
                    action           : function ($element) {
                        var id = $element.data("id");
                        deleteRow(id);
                    }
                }
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

