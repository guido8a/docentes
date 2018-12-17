
<%@ page import="docentes.EscuelaCarrera" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Carreras asignadas a Escuelas</title>

    <style type="text/css">
    tr.trHighlight, tr.trHighlight td, td.trHighlight, .trHighlight {
        color      : #444444;
        background : #669aba !important;
    }
    </style>

</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link action="form" class="btn btn-info btnCrear">
            <i class="fa fa-file-o"></i> Nueva
        </g:link>
    </div>

    <g:if test="${session.perfil.codigo == 'ADMG'}">
        <div class="col-md-1">Universidad:</div>
        <div class="col-sm-3">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 280px"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
        %{--<div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>--}%

        %{--<div class="col-md-5" id="divFacultad">--}%

        %{--</div>--}%
    </g:if>
    <g:else>

        <div class="col-md-1">Universidad:</div>

        <div class="col-sm-3">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" from="${seguridad.Persona.get(session.usuario.id)?.universidad}"/>
        </div>

    %{--<div class="col-md-1" style="margin-top: 10px; margin-left: 10px">Facultad:</div>--}%

        %{--<div class="col-md-6">--}%
            %{--<g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"--}%
                      %{--optionKey="id" name="facultad_name" id="facultad" class="form-control"--}%
                      %{--noSelection="${[0:'Todas ...']}"/>--}%
        %{--</div>--}%
    </g:else>

    <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

    <div class="col-md-5" id="divFacultad">

    </div>


</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th>Escuela</th>
        <th>Carrera</th>
    </tr>
    </thead>
    <tbody>

    </tbody>
</table>

<div id="divTablaEscuelas">


</div>


<script type="text/javascript">

     cargarFacultad($("#universidadId").val());

    $("#universidadId").change(function () {
        var id = $("#universidadId option:selected").val();
        cargarFacultad(id);
    });


    function cargarFacultad (id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'facultad_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }


    var id = null;
    function submitForm() {
        var $form = $("#frmEscuelaCarrera");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    if (parts[0] == 'ok') {
                        log(parts[1],"success");
                        cargarTablaEscuelas($("#facultad option:selected").val());
                    } else {
                        log("Error al guardar el registro", "error");
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar el registro seleccionado? Esta acción no se puede deshacer.</p>",
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
                                    log("Registro borrado correctamente","success");
                                    cargarTablaEscuelas($("#facultad option:selected").val());
                                }else{
                                    log("Error al borrar el registro", "error")
                                }
                            }
                        });
                    }
                }
            }
        });
    }
    function createEditRow(id) {
        var title = id ? "Editar" : "Nueva";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Carrera asignada a la Escuela",
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
