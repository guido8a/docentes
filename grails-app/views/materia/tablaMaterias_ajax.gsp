<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/09/16
  Time: 12:51
--%>

<g:if test="${materias}">
    <div class="row-fluid"  style="width: 99.7%;height: 400px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 1120px; height: 400px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <g:each in="${materias}" var="materia">
                        <tr data-id="${materia.id}">
                            <td style="width: 25%">${materia?.codigo}</td>
                            <td style="width: 75%">${materia?.nombre}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="panel panel-info col-md-12" style="margin-top: 10px" >
        <div class="panel-heading">
            * Máxima cantidad de registros en pantalla 20
        </div>
    </div>
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
                            id : id,
                            escuela: '${escuela?.id}'
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