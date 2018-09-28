<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/09/18
  Time: 11:17
--%>

<div class="" style="width: 99.7%;height: 450px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1070px">
        <tbody>
        <g:each in="${estudiantes}" var="estudiante">
            <tr data-id="${estudiante?.id}">
                <td style="width: 20%">${estudiante?.cedula}</td>
                <td style="width: 40%">${estudiante?.apellido}</td>
                <td style="width: 40%">${estudiante?.nombre}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="panel panel-info col-md-12" style="margin-top: 10px" >
    <div class="panel-heading">
        %{--<h3 class="panel-title" style="height: 25px">--}%
            * Máxima cantidad de registros en pantalla 30
        %{--</h3>--}%
    </div>
</div>

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
//                                createEditRow(id);
                        location.href='${createLink(controller: 'estudiante', action: 'estudiante')}/' + id
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

