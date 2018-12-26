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
            <g:textField name="codigo_name" id="codigoMateria" class="form-control" maxlength="16"/>
        </div>
        <div class="col-md-1 negrilla control-label">Materia: </div>
        <div class="col-md-4">
            <g:textField name="materiaBusqueda_name" id="materiaBusqueda" class="form-control" maxlength="31"/>
        </div>

        <a href="#" id="btnBuscar" class="btn btn-info" title="Buscar la materia">
            <i class="fa fa-search-plus"></i> Buscar
        </a>
        <a href="#" id="btnLimpiar" class="btn btn-warning" title="Limpiar los campos de búsqueda">
            <i class="fa fa-eraser"></i>
        </a>
    </div>
</g:form>

<div class="col-md-11">
    <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
        <thead>
        <tr>
            <th style="width: 7%">Código</th>
            <th style="width: 27%">Materia</th>
            <th style="width: 13%">Curso</th>
            <th style="width: 3%">Paralelo</th>
            <th style="width: 18%">Profesor</th>
            <th style="width: 5%">Acciones</th>
            <th style="width: 1%"></th>

        </tr>
        </thead>
    </table>

    <div id="divTablaBusqueda">

    </div>

    <div class="panel panel-info col-md-12" style="margin-top: 10px" >
        <div class="panel-heading">
            * Máxima cantidad de registros en pantalla 30
        </div>
    </div>

</div>




<script type="text/javascript">

    $("#btnLimpiar").click(function () {
        $("#codigoMateria").val('');
        $("#materiaBusqueda").val('');
    });

    function buscarMat () {
        openLoader('Buscando...');
        var codigo = $("#codigoMateria").val();
        var materia = $("#materiaBusqueda").val();
        $.ajax({
            type: 'POST',
            url : '${createLink(controller: 'materia', action: 'tablaBusqueda_ajax')}',
            data: {
                codigo: codigo,
                materia: materia,
                periodo : '${periodo?.id}',
                id: '${estudiante?.id}'
            },
            success: function (msg){
                closeLoader();
                $("#divTablaBusqueda").html(msg)
            }
        });
    }


    buscarMat();

    $("#btnBuscar").click(function () {
        buscarMat();
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
