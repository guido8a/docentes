<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/17
  Time: 10:20
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Desempeño</title>
</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="reportes" action="reportes" class="btn btn-primary" title="Regresar a lista de informes">
            <i class="fa fa-chevron-left"></i> Reportes
        </g:link>
    </div>
</div>

<div class="panel panel-info col-md-12" style="margin-top: 10px;" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 30px; text-align: center">

                Informe de Desempeño

        </h3>
    </div>

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
                    <th style="width: 7%">Cédula</th>
                    <th style="width: 17%">Nombres</th>
                    <th style="width: 17%">Apellidos</th>
                    <th style="width: 5%">Titulo</th>
                    <th style="width: 20%;">Informes</th>
                </tr>
                </thead>
            </table>

            <div id="divTablaProfesores" class="">

            </div>

        </div>
    </div>

</div>


<script type="text/javascript">



    function buscar () {
        openLoader("Buscando...");
        var ced = $("#cedulaBusqueda").val();
        var nom = $("#nombresBusqueda").val();
        var ape = $("#apellidosBusqueda").val();
        var fac = ${facultad?.id};
        var per = ${periodo?.id}
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'reportes', action: 'tablaProfesores_ajax')}",
            data:{
                cedula: ced,
                nombres: nom,
                apellidos: ape,
                facultad: fac,
                periodo: per
            },
            success: function (msg){
                $("#divTablaProfesores").html(msg);
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