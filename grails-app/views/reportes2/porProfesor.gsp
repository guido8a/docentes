<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Desempeño</title>
</head>

<body>

<div style="text-align: center; margin-top: -30px">
<h3>Resultado de evaluaciones por Profesor</h3>
</div>
<div class="btn-toolbar toolbar">
    %{--<div class="btn-group">--}%
        %{--<g:link controller="reportes" action="reportes" class="btn btn-primary" title="Regresar a lista de informes">--}%
            %{--<i class="fa fa-chevron-left"></i> Reportes--}%
        %{--</g:link>--}%
    %{--</div>--}%

    <div class="col-sm-1 row" style="text-align: right">
        Facultad
    </div>
    <div class="col-sm-3">
        <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                  class="form-control"
                  from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
    </div>
    <div class="col-sm-1 row" style="text-align: right">
        Carrera
    </div>
    <div class="col-sm-3">
        <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                  class="form-control"
                  from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
    </div>
    <div class="col-sm-1 row" style="text-align: right">
        Periodo
    </div>
    <div class="col-sm-2">
        <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                  class="form-control"
                  from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
    </div>
</div>

<div class="panel panel-info col-md-12" style="margin-top: 10px;" >

    <div class="panel-body">
        <div class="list-group" style="text-align: center">
            <div>
                <div class="col-md-1 negrilla control-label">Cédula: </div>
                <div class="col-md-2" id="divCedula">
                    <g:textField name="cedula" id="cedulaBusqueda" class="form-control number" maxlength="20"/>
                </div>
                <div class="col-md-1 negrilla control-label">Nombres: </div>
                <div class="col-md-3">
                    <g:textField name="nombres" id="nombresBusqueda" class="form-control"/>
                </div>
                <div class="col-md-1 negrilla control-label">Apellidos: </div>
                <div class="col-md-3">
                    <g:textField name="apellidos" id="apellidosBusqueda" class="form-control"/>
                </div>
                <a href="#" id="btnBuscar" class="btn btn-info" title="Buscar">
                    <i class="fa fa-search-plus"></i> Buscar
                </a>
            </div>


            <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
                <thead>
                <tr>
                    <th style="width: 15%">Profesor</th>
                    <th style="width: 20%">Título</th>
                    <th style="width: 15%">Materia</th>
                    <th style="width: 3%">C</th>  %{--curso y paralelo--}%
                    <th style="width: 5%">Dicta</th>  %{--curso y paralelo--}%
                    <th style="width: 7%">Auto Ev.</th>
                    <th style="width: 7%">Etero Ev.</th>
                    <th style="width: 7%;">Cuellos</th>
                    <th style="width: 7%;">Poten.</th>
                    <th style="width: 7%;">Fact. E.</th>
                    <th style="width: 7%;">Ver..</th>
                </tr>
                </thead>
            </table>

            <div id="divTblaProf" class="">

            </div>

        </div>
    </div>

</div>


<script type="text/javascript">

    buscar();

    function buscar () {
        openLoader("Buscando...");
        var ced = $("#cedulaBusqueda").val();
        var nom = $("#nombresBusqueda").val();
        var ape = $("#apellidosBusqueda").val();
        var escl = 4;
        var prdo = 4;
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'reportes2', action: 'tblaProf_ajax')}",
            data:{
                cedula: ced,
                nombres: nom,
                apellidos: ape,
                periodo: prdo,
                escuela: escl
            },
            success: function (msg){
                $("#divTblaProf").html(msg);
                closeLoader();

            }
        }) ;
    }

    $("#btnBuscar").click(function () {
        buscar();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            buscar();
        }
    });
</script>

</body>
</html>