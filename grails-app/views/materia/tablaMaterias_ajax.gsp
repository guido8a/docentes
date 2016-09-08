<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/09/16
  Time: 12:51
--%>

<div class="row-fluid"  style="width: 99.7%;height: 400px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1120px; height: 400px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${materias}" var="materia">
                    <tr data-id="${materia.id}">
                        <td style="width: 15%">${materia?.codigo}</td>
                        <td style="width: 50%">${materia?.nombre}</td>
                        <td style="width: 30%">${materia?.escuela?.nombre}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
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