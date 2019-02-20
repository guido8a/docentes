<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Desempeño</title>
    <style>
    .potn{
        background: #ddf8ff;
    }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: -30px">
    <h3>Resumen Individual por Profesor</h3>
</div>
<div class="btn-toolbar toolbar">

    <g:hiddenField name="uni_name" id="universidadId" value="${seguridad.Persona.get(session.usuario.id)?.universidad?.id}"/>


    <div class="row text-info" style="font-size: 11pt; margin-bottom: 5px">
        <div class="col-md-1" style="text-align: right">Período</div>
        <div class="col-md-2" id="divPeriodos" style="margin-left: 0px">

        </div>

        <div class="col-md-1">Facultad</div>
        <div class="col-md-3" id="divFacultad">

        </div>

        <div class="col-md-1">Carrera</div>
        <div class="col-md-3" id="divEscuela">

        </div>
    </div>





    %{--<div class="col-sm-1 row" style="text-align: right">--}%
    %{--Facultad--}%
    %{--</div>--}%
    %{--<div class="col-sm-3">--}%
    %{--<g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"--}%
    %{--class="form-control"--}%
    %{--from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>--}%
    %{--</div>--}%
    %{--<div class="col-sm-1 row" style="text-align: right">--}%
    %{--Carrera--}%
    %{--</div>--}%
    %{--<div class="col-sm-3">--}%
    %{--<g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"--}%
    %{--class="form-control"--}%
    %{--from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>--}%
    %{--</div>--}%
    %{--<div class="col-sm-1 row" style="text-align: right">--}%
    %{--Periodo--}%
    %{--</div>--}%
    %{--<div class="col-sm-2">--}%
    %{--<g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"--}%
    %{--class="form-control"--}%
    %{--from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>--}%
    %{--</div>--}%
</div>

<div class="panel panel-info col-md-12" style="margin-top: 10px;" >

    <div class="panel-body">
        <div class="list-group" style="text-align: center">
            <div>
                %{--<div class="col-md-1 negrilla control-label">Cédula: </div>--}%
                %{--<div class="col-md-2" id="divCedula">--}%
                    %{--<g:textField name="cedula" id="cedulaBusqueda" class="form-control number" maxlength="20"/>--}%
                %{--</div>--}%
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
                    <th style="width: 14%">Profesor</th>
                    <th style="width: 20%">Título</th>
                    <th style="width: 15%">Materia</th>
                    <th style="width: 3%">&nbsp;&nbsp;C</th>  %{--curso y paralelo--}%
                    <th style="width: 5%">Dicta</th>  %{--curso y paralelo--}%
                    <th style="width: 7%">Auto Ev.</th>
                    <th style="width: 8%">Hetero Ev.</th>
                    <th style="width: 7%;">Cuellos</th>
                    <th style="width: 7%;">Poten.</th>
                    <th style="width: 7%;">Fact. E.</th>
                    <th style="width: 7%;"> Ver ...</th>
                </tr>
                </thead>
            </table>

            <div id="divTblaProf" class="">

            </div>

        </div>
    </div>

</div>


<script type="text/javascript">


    cargarPeriodo($("#universidadId").val());
    cargarFacultad($("#universidadId").val());

    $("#universidadId").change(function () {
        var id = $("#universidadId option:selected").val();
        cargarPeriodo(id);
        cargarFacultad(id);
    });

    function cargarPeriodo(id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'periodo_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divPeriodos").html(msg)
            }
        });
    }


    function cargarFacultad (id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'facultadSel_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }



    buscar();

    function buscar () {
        openLoader("Buscando...");
        var ced = $("#cedulaBusqueda").val();
        var nom = $("#nombresBusqueda").val();
        var ape = $("#apellidosBusqueda").val();
        var escl = $("#escuelaId").val();
        var prdo = $("#periodoId").val();
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