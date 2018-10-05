
<%@ page import="docentes.Profesor" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Profesores</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group" style="margin-right: 100px">
        <a href="#" class="btn btn-info" id="btnProfesorNuevo">
            <i class="fa fa-user"></i> Nuevo Profesor
        </a>
    </div>


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

<div class="row" style="margin-left: 190px;">

</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th style="width: 10%">Cédula</th>
        <th style="width: 34%">Nombre</th>
        <th style="width: 33%">Apellido</th>
        <th style="width: 10%">Estado</th>
        <th style="width: 11%">Evaluar</th>
        <th style="width: 2%;"></th>
    </tr>
    </thead>
    <tbody>
    </tbody>
</table>

<div id="divTablaProfesores">

</div>

<script type="text/javascript">

    $("#btnProfesorNuevo").click(function () {
        var uni = $("#universidadId option:selected").val();
        location.href="${createLink(controller: 'profesor', action: 'profesor')}?universidad="  + uni
    });

    <g:if test="${session.perfil.codigo != 'ADMG'}">
    $(".uni").attr("disabled", true);
    </g:if>

    $("#btnBusqueda").click(function () {
        var ced = $("#cedula").val();
        var nom = $("#nombre").val();
        var ape = $("#apellido").val();
        cargarTablaProfesores(ced,nom,ape,$("#universidadId option:selected").val());
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#cedula").val('');
        $("#nombre").val('');
        $("#apellido").val('');
        cargarTablaProfesores(null,null,null,$("#universidadId option:selected").val());
    });

    cargarTablaProfesores(null, null, null, $("#universidadId option:selected").val());

    $("#universidadId").change(function () {
        cargarTablaProfesores(null, null, null, $("#universidadId option:selected").val());
    });

    function cargarTablaProfesores (ced,nom,ape,uni) {
        openLoader("Cargando....");
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'profesor', action: 'tablaProfesores_ajax')}",
            data:{
                cedula: ced,
                nombre: nom,
                apellido: ape,
                universidad: uni
            },
            success: function (msg) {
                closeLoader();
                $("#divTablaProfesores").html(msg)
            }
        });
    }

    var id = null;
    function submitForm() {
        var $form = $("#frmProfesor");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                    if (parts[0] == "OK") {
                        location.reload(true);
                    } else {
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar el Profesor seleccionado? Esta acción no se puede deshacer.</p>",
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
                    title   : title + " Profesor",
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
//                                createEditRow(id);
                        location.href='${createLink(controller: 'profesor', action: 'profesor')}/' + id;
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
