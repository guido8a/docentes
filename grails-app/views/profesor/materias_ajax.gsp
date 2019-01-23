<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/09/16
  Time: 12:51
--%>

<div class="row" style="margin-bottom: 10px;">
    <div class="row-fluid">
        <div style="margin-left: 10px;">
            <div class="col-md-2">
                <b style="margin-left: 5px">Código: </b>
                <g:textField name="codigo_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="codigo" class="form-control allCaps"/>
            </div>

            <div class="col-md-4">
                <b style="margin-left: 5px">Nombre: </b>
                <g:textField name="nombre_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="nombre" class="form-control"/>
            </div>
            <div class="btn-group col-md-3" style="margin-left: -10px; margin-top: 18px">
                <a href="#" name="busqueda" class="btn btn-success" id="btnBusqueda" title="Buscar">
                    <i class="fa fa-search"></i> Buscar</a>

                <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                   title="Borrar criterios">
                    <i class="fa fa-eraser"></i> Limpiar</a>
            </div>
        </div>
    </div>
</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th style="width: 23%;">Código</th>
        <th style="width: 65%">Nombre</th>
        <th style="width: 10%">Seleccionar</th>
        <th style="width: 2%"></th>
    </tr>
    </thead>
</table>

<div id="tablaMaterias">

</div>

<script type="text/javascript">

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            cargarTablaMaterias (${escuela.facultad.universidad.id}, $("#codigo").val(), $("#nombre").val());
        }
    });

    cargarTablaMaterias (${escuela.facultad.universidad.id}, $("#codigo").val(), $("#nombre").val());

    $("#btnBusqueda").click(function () {
        var cod = $("#codigo").val();
        var nom = $("#nombre").val();
        var uni = ${escuela.facultad.universidad.id}
        cargarTablaMaterias (uni, cod, nom)
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#codigo").val('');
        $("#nombre").val('');
        var uni = ${escuela.facultad.universidad.id}
        cargarTablaMaterias (uni, null, null)
    });

    function cargarTablaMaterias (uni, cod, nom) {
        openLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'materia', action: 'tablaMateriasUni_ajax')}',
            data:{
                universidad: uni,
                codigo: cod,
                nombre: nom
            },
            success: function (msg){
                closeLoader();
                $("#tablaMaterias").html(msg)
            }
        });
    }

</script>