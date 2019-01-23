
<%@ page import="docentes.Materia" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Materias</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div class="row" style="margin-bottom: 10px;">
    <div class="row-fluid">
        <div style="margin-left: 10px;">

            <g:if test="${session.perfil.codigo == 'ADMG'}">
                <div class="col-md-4">
                    <b style="margin-left: 5px">Universidad: </b>
                    <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                              class="form-control" from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-4">
                    <b style="margin-left: 5px">Universidad: </b>
                    <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                              class="uni form-control" from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}" value="${seguridad.Persona.get(session.usuario.id)?.universidad?.id}"/>
                </div>
            </g:else>

            <div class="col-md-2">
                <b style="margin-left: 5px">Código: </b>
                <g:textField name="codigo_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="codigo" class="form-control allCaps"/>
            </div>

            <div class="col-md-3">
                <b style="margin-left: 5px">Nombre: </b>
                <g:textField name="nombre_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="nombre" class="form-control"/>
            </div>
            <div class="btn-group col-md-1" style="margin-left: -10px; margin-top: 20px; width: 110px ">
                <a href="#" name="busqueda" class="btn btn-success" id="btnBusqueda" title="Buscar"
                   style="height: 34px; padding: 9px; width: 46px">
                    <i class="fa fa-search"></i></a>

                <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                   title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                    <i class="fa fa-eraser"></i></a>
            </div>

            <div class="btn-group col-md-1" style="margin-left: -10px; margin-top: 20px; ">
                <a href="#" class="btn btn-info btnCrearMateria">
                    <i class="fa fa-book"></i> Nueva Materia
                </a>
            </div>
        </div>
    </div>
</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th style="width: 25%;">Código</th>
        <th style="width: 75%">Nombre</th>
    </tr>
    </thead>
</table>

<div id="tablaMaterias">

</div>

<script type="text/javascript">

    $("#universidadId").change(function () {
        $("#codigo").val('');
        $("#nombre").val('');
        var uni = $("#universidadId option:selected").val();
        cargarTablaMaterias (uni, null, null)
    });

    cargarTablaMaterias ($("#universidadId option:selected").val(), null, null);

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            var cod = $("#codigo").val();
            var nom = $("#nombre").val();
            var uni = $("#universidadId option:selected").val();
            cargarTablaMaterias (uni, cod, nom)
        }
    });

    $(".btnCrearMateria").click(function () {
        createEditRow()
    });

    <g:if test="${session.perfil.codigo != 'ADMG'}">
    $(".uni").attr("disabled", true);
    </g:if>

    $("#btnBusqueda").click(function () {
        var cod = $("#codigo").val();
        var nom = $("#nombre").val();
        var uni = $("#universidadId option:selected").val();
        cargarTablaMaterias (uni, cod, nom)
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#codigo").val('');
        $("#nombre").val('');
        cargarTablaMaterias ($("#universidadId option:selected").val(), null, null)
    });

    function cargarTablaMaterias (uni, cod, nom) {
//        openLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'materia', action: 'tablaMaterias_ajax')}',
            data:{
                universidad: uni,
                codigo: cod,
                nombre: nom
            },
            success: function (msg){
                closeLoader();
                $("#tablaMaterias").html(msg)
                closeLoader();
            }
        });
    }

    var id = null;
    function submitForm() {
        var $form = $("#frmMateria");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    if (parts[0] == "SUCCESS") {
                        log("Materia guardada correctamente","success");
                        setTimeout(function () {
                            $("#escuelaId").change();
                        }, 1000);
                    } else {
                        log("Error al guardar la materia","error");
                        spinner.replaceWith($btn);
                        return false;
                    }
                }
            });
        } else {
            return false;
        } //else
    }
    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar la Materia seleccionada? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash-o'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
//                                        log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    log("Materia borrada correctamente","success");
                                    setTimeout(function () {
                                        location.reload(true);
                                    }, 1000)
                                }else{
                                    log("Error al borrar la materia","error");
                                }
                            }
                        });
                    }
                }
            }
        });
    }
    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
        var uni = $("#universidadId option:selected").val();

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_ajax')}",
            data    : {
                id: id,
                universidad: uni
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Materia",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitForm();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    $(function () {

        $(".btnCrear").click(function() {
            createEditRow();
            return false;
        });


    });

    %{--cargarEscuela($("#facultadId").val());--}%

    %{--function cargarEscuela (facultad) {--}%
    %{--$.ajax({--}%
    %{--type:'POST',--}%
    %{--url: '${createLink(controller: 'materia', action: 'escuela_ajax')}',--}%
    %{--data:{--}%
    %{--id: facultad--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--$("#divEscuela").html(msg)--}%
    %{--}--}%
    %{--})--}%
    %{--}--}%



    %{--$("#facultadId").change(function () {--}%
    %{--var facultad = $("#facultadId").val();--}%
    %{--cargarEscuela(facultad)--}%
    %{--})--}%

</script>

</body>
</html>
