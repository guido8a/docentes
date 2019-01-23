<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/19
  Time: 9:45
--%>


<%@ page import="docentes.Materia" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Materias</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div class="row" style="margin-bottom: 10px">


    <div class="btn-group">
        <g:link action="form" class="btn btn-info btnCrear">
            <i class="fa fa-book"></i> Nueva Materia
        </g:link>
        <a href="#" class="btn btn-success btnMxE" title="Asignar materias a escuelas">
            <i class="fa fa-list"></i> Materias por Escuela
        </a>
    </div>



    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-sm-2 row" style="text-align: right; font-weight: bold">
            Universidad
        </div>

        <div class="col-sm-6">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" value="${session.univ}"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
    </g:if>
    <g:else>
        <div class="col-sm-2 row" style="text-align: right; font-weight: bold">
            Universidad
        </div>

        <div class="col-sm-6">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" from="${seguridad.Persona.get(session.usuario.id)?.universidad}"/>
        </div>
    </g:else>

</div>
<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th style="width: 15%;">Código</th>
        <th style="width: 85%">Nombre</th>
    </tr>
    </thead>
</table>

<div id="tablaMateriasU">

</div>

<script type="text/javascript">

    $(".btnMxE").click(function () {
        location.href="${createLink(controller: 'materia', action: 'list')}"
    })

    cargarTablaMaterias($("#universidadId option:selected").val());

    $("#universidadId").change(function () {
        cargarTablaMaterias($("#universidadId option:selected").val());
    });

    function cargarTablaMaterias (universidad) {
        openLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'materia', action: 'tablaMateriasUni_ajax')}',
            data:{
                uni: universidad
            },
            success: function (msg) {
                closeLoader();
                $("#tablaMateriasU").html(msg)
            }
        })
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
//                        log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
                    if (parts[0] == "SUCCESS") {
                        log("Materia guardada correctamente","success");
                        setTimeout(function () {
//                                location.reload(true);
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
        var escuela = $("#escuelaId").val();
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id, escuela: escuela } : {escuela:escuela};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_ajax')}",
            data    : data,
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

</script>

</body>
</html>
