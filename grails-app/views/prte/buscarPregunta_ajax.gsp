<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/09/16
  Time: 11:32
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/09/16
  Time: 10:58
--%>

<g:form class="form-horizontal" name="frmBusqueda" role="form" action="save" method="POST">
    <div class="row">
        <div class="col-md-1 negrilla control-label">Código: </div>
        <div class="col-md-2">
            <g:textField name="codigo_name" id="codigoPregunta" class="form-control allCaps" maxlength="8"/>
        </div>
        <div class="col-md-1 negrilla control-label">Pregunta: </div>
        <div class="col-md-4">
            <g:textField name="preguntaBusqueda_name" id="descripcionPregunta" class="form-control" maxlength="200"/>
        </div>

        <a href="#" id="btnBuscar" class="btn btn-success" title="Buscar la pregunta">
            <i class="fa fa-search-plus"></i> Buscar
        </a>
        <a href="#" id="btnLimpiar" class="btn btn-primary" title="Limpiar los campos de búsqueda">
            <i class="fa fa-eraser"></i> Limpiar
        </a>
    </div>
</g:form>

<div class="col-md-11">
    <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
        <thead>
        <tr>
            <th style="width: 7%">Código</th>
            <th style="width: 52%">Pregunta</th>
            <th style="width: 5%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>

    <div id="divTablaBusquedaPregunta">

    </div>

</div>




<script type="text/javascript">

    $("#btnLimpiar").click(function () {
        $("#codigoPregunta").val('');
        $("#descripcionPregunta").val('');
    });


    $("#btnBuscar").click(function () {
        openLoader('Buscando...');
        var codigo = $("#codigoPregunta").val();
        var pregunta = $("#descripcionPregunta").val();
        $.ajax({
            type: 'POST',
            url : '${createLink(controller: 'prte', action: 'tablaBusquedaPregunta_ajax')}',
            data: {
                codigo: codigo,
                pregunta: pregunta,
                tipoEncuesta: '${tipoEncuesta?.id}'
            },
            success: function (msg){
                closeLoader();
                $("#divTablaBusquedaPregunta").html(msg)
            }
        });
    });


    var validator = $("#frmBusqueda").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });


</script>
