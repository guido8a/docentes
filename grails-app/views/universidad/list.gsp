
<%@ page import="docentes.Universidad" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Universidad</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link action="form" class="btn btn-primary btnCrear">
            <i class="fa fa-file-o"></i> Nuevo
        </g:link>
    </div>
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link action="list" class="btn btn-default btn-search" type="button">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>

        <g:sortableColumn property="nombre" title="Nombre" />

        <g:sortableColumn property="nombreContacto" title="Nombre Contacto" />

        <g:sortableColumn property="apellidoContacto" title="Apellido Contacto" />

        <g:sortableColumn property="fechaInicio" title="Fecha Inicio" />

        <g:sortableColumn property="fechaFin" title="Fecha Fin" />

        <g:sortableColumn property="logo" title="Logo" />

    </tr>
    </thead>
    <tbody>
    <g:each in="${universidadInstanceList.sort{it.nombre}}" status="i" var="universidadInstance">
        <tr data-id="${universidadInstance.id}">

            <td>${fieldValue(bean: universidadInstance, field: "nombre")}</td>

            <td>${fieldValue(bean: universidadInstance, field: "nombreContacto")}</td>

            <td>${fieldValue(bean: universidadInstance, field: "apellidoContacto")}</td>

            <td><g:formatDate date="${universidadInstance.fechaInicio}" format="dd-MM-yyyy" /></td>

            <td><g:formatDate date="${universidadInstance.fechaFin}" format="dd-MM-yyyy" /></td>

            <td>${fieldValue(bean: universidadInstance, field: "logo")}</td>

        </tr>
    </g:each>
    </tbody>
</table>

<elm:pagination total="${universidadInstanceCount}" params="${params}"/>

<script type="text/javascript">
    var id = null;
    function submitForm() {
        var $form = $("#frmUniversidad");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    if(msg =='ok'){
                        log("Universidad guardada correctamente", "success");
                        setTimeout(function () {
                            location.reload(true);
                        }, 800);
                    }else{
                        log("Error al guardar la universidad", "error")
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar el Universidad seleccionado? Esta acción no se puede deshacer.</p>",
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
                                if (msg == "ok") {
                                    log("Universidad borrada correctamente","success");
                                    setTimeout(function () {
                                        location.reload(true);
                                    }, 800);
                                }else{
                                    log("Error al borrar la universidad","error");
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
                    title   : title + " Universidad",
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

        function createContextMenu(node) {
            var $tr = $(node);

            var items = {
                header : {
                    label  : "Acciones",
                    header : true
                }
            };

            var id = $tr.data("id");

            console.log("id " + id)

            var ver = {
                label  : 'Ver',
                icon   : "fa fa-search",
                action : function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'show_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            bootbox.dialog({
                                title   : "Ver Universidad",
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
            };

            var editar = {
                label           : 'Editar',
                icon            : "fa fa-pencil",
                action          : function (e) {
                    createEditRow(id);
                }
            };

            var eliminar = {
                label            : 'Eliminar',
                icon             : "fa fa-trash-o",
                separator_before : true,
                action           : function (e) {
                    deleteRow(id);
                }
            };

            items.ver = ver;
            items.editar = editar;
            items.eliminar = eliminar;

            return items;
        }

        $("tr").contextMenu({
            items  : createContextMenu,
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
