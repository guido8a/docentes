
<%@ page import="docentes.Estudiante" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Estudiantes</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>




<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link action="estudiante" class="btn btn-info btnCrear">
            <i class="fa fa-user"></i> Nuevo estudiante
        </g:link>
    </div>
    %{--<div class="btn-group pull-right col-md-3">--}%
    %{--<div class="input-group">--}%
    %{--<input type="text" class="form-control" placeholder="Buscar" value="${params.search}">--}%
    %{--<span class="input-group-btn">--}%
    %{--<g:link action="list" class="btn btn-default btn-search" type="button">--}%
    %{--<i class="fa fa-search"></i>&nbsp;--}%
    %{--</g:link>--}%
    %{--</span>--}%
    %{--</div><!-- /input-group -->--}%
    %{--</div>--}%
</div>


<div class="row" style="margin-left: 190px;">
    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-md-1"><b>Universidad:</b></div>
        <div class="col-sm-3">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 300px"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
    </g:if>
    <g:else>
        <div class="col-md-1"><b>Universidad:</b></div>
        <div class="col-sm-3">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="uni form-control" style="width: 300px"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}" value="${seguridad.Persona.get(session.usuario.id)?.universidad?.id}"/>
        </div>
    </g:else>
</div>




<div class="row" style="margin-bottom: 10px;">
    <div class="row-fluid">
        <div style="margin-left: 20px;">

            <div class="col-xs-3">
                <b style="margin-left: 5px">Cédula: </b>
                <g:textField name="cedula_name" maxlength="31" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="cedula" class="form-control"/>
            </div>

            <div class="col-xs-3">
                <b style="margin-left: 5px">Apellido: </b>
                <g:textField name="apellido_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="apellido" class="form-control"/>
            </div>

            <div class="col-xs-3">
                <b style="margin-left: 5px">Nombre: </b>
                <g:textField name="nombre_name" style="margin-right: 10px; width: 100%" value="${params.criterio}"
                             id="nombre" class="form-control"/>
            </div>

            <div class="btn-group col-xs-1" style="margin-left: -10px; margin-top: 20px; width: 110px;">
                <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar"
                   style="height: 34px; padding: 9px; width: 46px">
                    <i class="fa fa-search"></i></a>

                <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                   title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                    <i class="fa fa-eraser"></i></a>
            </div>

        </div>

    </div>
</div>


<table class="table table-bordered table-hover table-condensed" style="width: 1070px">
    <thead>
    <tr>
        <th style="width: 20%">Cédula</th>
        <th style="width: 40%">Apellido</th>
        <th style="width: 40%">Nombre</th>
    </tr>
    </thead>
</table>

<div id="divTablaEstudiantes">

</div>


<script type="text/javascript">

    <g:if test="${session.perfil.codigo != 'ADMG'}">
    $(".uni").attr("disabled", true);
    </g:if>

    $("#universidadId").change(function () {
        cargarTablaEstudiantes(null, null, null, $("#universidadId option:selected").val());
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#cedula").val('');
        $("#nombre").val('');
        $("#apellido").val('');
        cargarTablaEstudiantes(null, null, null, $("#universidadId option:selected").val());
    });

    $("#btnBusqueda").click(function () {
        var ced = $("#cedula").val();
        var nom = $("#nombre").val();
        var ape = $("#apellido").val();
        var un = $("#universidadId option:selected").val();

        cargarTablaEstudiantes(ced, nom, ape,un);
    });

    cargarTablaEstudiantes(null, null, null, $("#universidadId option:selected").val());

    function cargarTablaEstudiantes (c,n,a,u){
        openLoader("Cargando....");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'estudiante', action: 'tablaEstudiantes_ajax')}',
            data:{
                cedula: c,
                nombre: n,
                apellido: a,
                universidad: u
            },
            success: function (msg){
                closeLoader();
                $("#divTablaEstudiantes").html(msg)
            }
        });
    }



    var id = null;
    function submitForm() {
        var $form = $("#frmEstudiante");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
//                        log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                    if (parts[0] == "OK") {
                        log("Estudiante guardado correctamente","success")
                        setTimeout(function () {
                            location.reload(true);
                        }, 1000);
                    } else {
                        log("Error al guardar el estudiante","error")
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar el Estudiante seleccionado? Esta acción no se puede deshacer.</p>",
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
                                var parts = msg.split("_");
                                log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "OK") {
                                    location.reload(true);
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
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Estudiante",
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
//                    createEditRow();
            location.href='${createLink(controller: 'estudiante', action: 'estudiante')}'
//                    return false;
        });

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
                                    title   : "Ver datos del estudiante",
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
                        var unive = $element.data("uni");
                        location.href="${createLink(controller: 'estudiante', action: 'estudiante')}?id=" + id + '&universidad=' + unive
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

</body>
</html>
