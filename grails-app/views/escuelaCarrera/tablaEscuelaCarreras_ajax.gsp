<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 17/10/18
  Time: 14:53
--%>

<div class="" style="width: 100%;height: 450px; overflow-y: auto; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1120px">
        <tbody>
        <g:each in="${escuelaCarreraInstanceList}" status="i" var="escuelaCarreraInstance">
            <tr data-id="${escuelaCarreraInstance.id}">
                <td style="width: 55%">${escuelaCarreraInstance?.escuela?.nombre}</td>
                <td style="width: 45%">${escuelaCarreraInstance?.carrera?.descripcion}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="panel panel-info col-md-12" style="margin-top: 10px" >
    <div class="panel-heading">
        * Máxima cantidad de registros en pantalla 30
    </div>
</div>


<script type="text/javascript">
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
                                title   : "Ver",
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
                    createEditRow(id);
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


</script>