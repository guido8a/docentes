<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 05/10/18
  Time: 10:17
--%>
<g:if test="${profesores}">
    <div class="" style="width: 100%;height: 450px; overflow-y: auto; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover" width="1120px">
            <tbody>
            <g:each in="${profesores}" var="profesor">
                <tr data-id="${profesor?.id}">
                    <td style="width: 10%">${profesor?.cedula}</td>
                    <td style="width: 34%">${profesor?.nombre}</td>
                    <td style="width: 33%">${profesor?.apellido}</td>
                    <td style="width: 11%">${profesor?.estado}</td>
                    <td style="width: 11%">${profesor?.evaluar}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
    <g:if test="${profesores.size() > 20}">
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
                        location.href='${createLink(controller: 'profesor', action: 'profesor')}?id=' + id;
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