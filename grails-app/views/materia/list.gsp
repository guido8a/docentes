
<%@ page import="docentes.Materia" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de Materia</title>
    </head>
    <body>

        <elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

    <!-- botones -->
        %{--<div class="btn-toolbar toolbar">--}%

    <div class="row" style="margin-bottom: 10px">


            <div class="btn-group">
                <g:link action="form" class="btn btn-info btnCrear">
                    <i class="fa fa-book"></i> Nueva Materia
                </g:link>
            </div>


        <div class="col-md-1 negrilla control-label">Facultad: </div>
        <div class="col-md-4">
            <g:select name="facultad" id="facultadId" optionKey="id" optionValue="nombre"
                      class="form-control" from="${docentes.Facultad.list([sort: 'nombre', order: 'asc'])}"/>
        </div>


        <div class="col-md-1 negrilla control-label">Escuela: </div>
        <div class="col-md-4" id="divEscuela">

        </div>

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
        %{--</div>--}%

        <table class="table table-condensed table-bordered table-striped">
            <thead>
                <tr>

                    <th style="width: 15%;">Código</th>
                    <th style="width: 50%">Nombre</th>
                    <th style="width: 31%">Escuela</th>

                </tr>
            </thead>
            %{--<tbody>--}%
                %{--<g:each in="${materiaInstanceList}" status="i" var="materiaInstance">--}%
                    %{--<tr data-id="${materiaInstance.id}">--}%
                        %{----}%
                        %{--<td>${fieldValue(bean: materiaInstance, field: "codigo")}</td>--}%
                        %{----}%
                        %{--<td>${fieldValue(bean: materiaInstance, field: "nombre")}</td>--}%
                        %{----}%
                        %{--<td>${fieldValue(bean: materiaInstance, field: "escuela")}</td>--}%
                        %{----}%
                    %{--</tr>--}%
                %{--</g:each>--}%
            %{--</tbody>--}%
        </table>

    <div id="tablaMaterias">

    </div>

        %{--<elm:pagination total="${materiaInstanceCount}" params="${params}"/>--}%

        <script type="text/javascript">
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
                                location.reload(true);
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


            cargarEscuela($("#facultadId").val());


            function cargarEscuela (facultad) {
                $.ajax({
                    type:'POST',
                    url: '${createLink(controller: 'materia', action: 'escuela_ajax')}',
                    data:{
                        id: facultad
                    },
                    success: function (msg){
                        $("#divEscuela").html(msg)
                    }
                })
            }



        $("#facultadId").change(function () {
            var facultad = $("#facultadId").val();
            cargarEscuela(facultad)
        })




        </script>

    </body>
</html>
