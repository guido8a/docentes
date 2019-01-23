<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/09/16
  Time: 12:51
--%>

<div><label style="font-size: 13px; color: #3f71ba">Escuela: ${escuela?.nombre} </label></div>

<div class="row" style="margin-bottom: 10px;">
    <div class="row-fluid">
        <div style="margin-left: 10px;">
            <div class="col-md-2">
                <b style="margin-left: 5px">Código: </b>
                <g:textField name="codigoBusqueda_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="codigoBusqueda" class="form-control allCaps"/>
            </div>
            <div class="col-md-4">
                <b style="margin-left: 5px">Materia: </b>
                <g:textField name="materiaBusqueda_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="materiaBusqueda" class="form-control"/>
            </div>
            <div class="col-md-4">
                <b style="margin-left: 5px">Profesor: </b>
                <g:select name="profesorBusqueda_name" from="${profesores.unique()}"
                          optionKey="id" optionValue="${{it.apellido + " " + it.nombre}}" id="profesorBusqueda" class="form-control" noSelection="${['-1': 'Seleccione...']}"/>
            </div>
            <div class="btn-group col-md-2" style="margin-left: -10px; margin-top: 18px">
                <a href="#" name="busqueda" class="btn btn-success" id="btnBusqueda" title="Buscar">
                    <i class="fa fa-search"></i></a>

                <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                   title="Borrar criterios">
                    <i class="fa fa-eraser"></i></a>
            </div>
        </div>
    </div>
</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
    <tr>
        <th style="width: 7%">Código</th>
        <th style="width: 31%">Materia</th>
        <th style="width: 6%">Curso</th>
        <th style="width: 6%">Paralelo</th>
        <th style="width: 20%">Profesor</th>
        <th style="width: 10%">Escuela</th>
        <th style="width: 5%">Acciones</th>
        <th style="width: 2%"></th>
    </tr>
    </thead>
</table>

<div id="tablaMateriasE">

</div>


<script type="text/javascript">

    $("#btnBusqueda").click(function () {
        cargarTablaMateriasDictan();
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#codigoBusqueda").val('');
        $("#materiaBusqueda").val('');
        $("#profesorBusqueda").val(-1);
        cargarTablaMateriasDictan();
    });

    cargarTablaMateriasDictan();

    function cargarTablaMateriasDictan () {

        var universidad = $("#universidadE option:selected").val();
        var facultad = $("#facultadE option:selected").val();
        var escuela = $("#escuelaE option:selected").val();
        var periodo = $("#periodoE option:selected").val();

        var codigo = $("#codigoBusqueda").val();
        var materia = $("#materiaBusqueda").val();
        var profesor = $("#profesorBusqueda option:selected").val();

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'estudiante', action: 'tablaMateriasDicta_ajax')}',
            async: false,
            data:{
                universidad: universidad,
                facultad: facultad,
                escuela: escuela,
                periodo: periodo,
                estudiante: '${estudiante?.id}',
                materia: materia,
                codigo: codigo,
                profesor: profesor
            },
            success: function(msg){
                $("#tablaMateriasE").html(msg)
            }
        });
    }

</script>