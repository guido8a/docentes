
<%@ page import="utilitarios.Auxiliares" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Parámetros del Sistema</title>
</head>
<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group" style="margin-right: 250px">
        <a href="#" class="btn btn-info btnCrear">
            <i class="fa fa-file-o"></i> Crear
        </a>
    </div>

    <g:if test="${session.perfil.codigo == 'ADMG'}">
        %{--<div class="col-md-1" style="margin-top: 10px;"><label>Universidad:</label></div>--}%
        <div class="col-md-2" style="margin-top: 10px"><h4><span class="label label-primary">Universidad: </span></h4></div>
        <div class="col-sm-5" style="margin-top: 10px;">
            <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                      class="form-control" style="width: 350px"
                      from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
        </div>
    </g:if>
</div>

<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr style="font-size: 10px">
        <th>Período Académico</th>
        <th>Índice de calidad Mínimo</th>
        <th>Índice de calidad Óptimo</th>
        <th>Ponderación para evaluación de Directivos</th>
        <th>Ponderación para evaluación de Pares</th>
        <th>Ponderación para Autoevaluaciones</th>
        <th>Ponderación para evaluación de Estudiantes</th>
        <th>Fecha de inicio Evaluaciones</th>
        <th>Fecha de cierre Evaluaciones</th>
        %{--<g:sortableColumn property="periodo" title="Período Académico" />--}%

        %{--<g:sortableColumn property="minimo" title="Índice de calidad Mínimo" />--}%

        %{--<g:sortableColumn property="optimo" title="Índice de calidad Óptimo" />--}%

        %{--<g:sortableColumn property="maximoDirectivos" title="Ponderación para evaluación de Directivos" />--}%

        %{--<g:sortableColumn property="maximoPares" title="Ponderación para evaluación de Pares" />--}%

        %{--<g:sortableColumn property="maximoAutoevaluacion" title="Ponderación para Autoevaluaciones" />--}%

        %{--<g:sortableColumn property="maximoEstudiantes" title="Ponderación para evaluación de Estudiantes" />--}%
        %{--<g:sortableColumn property="fechaInicio" title="Fecha de inicio Evaluaciones" />--}%
        %{--<g:sortableColumn property="fechaCierre" title="Fecha de cierre Evaluaciones" />--}%
    </tr>
    </thead>



    %{--<tbody>--}%
    %{--<g:each in="${auxiliaresInstanceList}" status="i" var="auxiliaresInstance">--}%
    %{--<tr data-id="${auxiliaresInstance.id}">--}%
    %{--<td><strong>${auxiliaresInstance?.periodo?.nombre}</strong></td>--}%
    %{--<td>${auxiliaresInstance?.minimo?.toInteger()}</td>--}%
    %{--<td>${auxiliaresInstance?.optimo?.toInteger()}</td>--}%
    %{--<td>${auxiliaresInstance?.maximoDirectivos}</td>--}%
    %{--<td>${auxiliaresInstance?.maximoPares}</td>--}%
    %{--<td>${auxiliaresInstance?.maximoAutoevaluacion}</td>--}%
    %{--<td>${auxiliaresInstance?.maximoEstudiantes}</td>--}%
    %{--<td>${auxiliaresInstance?.fechaInicio.format('yyyy-MM-dd')}</td>--}%
    %{--<td>${auxiliaresInstance?.fechaCierre ? auxiliaresInstance?.fechaCierre.format('yyyy-MM-dd') : ''}</td>--}%
    %{--</tr>--}%
    %{--</g:each>--}%
    %{--</tbody>--}%
</table>

<div class="row-fluid"  style="width: 100%;height: 450px;overflow-y: auto;float: right; margin-top: -15px">
    <div class="span12">
        <div id="divTablaParametros" style="width: 100%; height: 450px;"></div>
    </div>
</div>

%{--<elm:pagination total="${auxiliaresInstanceCount}" params="${params}"/>--}%

<script type="text/javascript">

    <g:if test="${session.perfil.codigo == 'ADMG'}">
    cargarTablaParametros($("#universidadId").val());
    </g:if>
    <g:else>
    cargarTablaParametros(${docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id).id});
    </g:else>

    $("#universidadId").change(function () {
        cargarTablaParametros($("#universidadId option:selected").val());
    });

    function cargarTablaParametros(id) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'auxiliares', action: 'tablaParametros_ajax')}",
            data:{
                id: id
            },
            success: function (msg) {
                $("#divTablaParametros").html(msg)
            }
        })
    }

    var id = null;
    function submitForm() {
        var $form = $("#frmAuxiliares");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    if (msg == "ok") {
                        log("Grabado correctamente","success");
                        setTimeout(function () {
                            location.reload(true);
                        }, 800);
                    } else {
                        log("Error al grabar","error");
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
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar el Auxiliares seleccionado? Esta acción no se puede deshacer.</p>",
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
                                    log("Borrado correctamente","success");
                                    setTimeout(function () {
                                        location.reload(true);
                                    }, 800);
                                } else {
                                    log("Error al borrar","error");
                                    spinner.replaceWith($btn);
                                    return false;
                                }
                            }
                        });
                    }
                }
            }
        });
    }
    %{--function createEditRow(id) {--}%
    %{--var title = id ? "Editar" : "Crear";--}%
    %{--var data = id ? { id: id } : {};--}%
    %{--$.ajax({--}%
    %{--type    : "POST",--}%
    %{--url     : "${createLink(action:'form_ajax')}",--}%
    %{--data    : data,--}%
    %{--success : function (msg) {--}%
    %{--var b = bootbox.dialog({--}%
    %{--id      : "dlgCreateEdit",--}%
    %{--title   : title + " Auxiliares - Periodo: NN",--}%
    %{--class   : 'long',--}%
    %{--message : msg,--}%
    %{--buttons : {--}%
    %{--cancelar : {--}%
    %{--label     : "Cancelar",--}%
    %{--className : "btn-primary",--}%
    %{--callback  : function () {--}%
    %{--}--}%
    %{--},--}%
    %{--guardar  : {--}%
    %{--id        : "btnSave",--}%
    %{--label     : "<i class='fa fa-save'></i> Guardar",--}%
    %{--className : "btn-success",--}%
    %{--callback  : function () {--}%
    %{--return submitForm();--}%
    %{--} //callback--}%
    %{--} //guardar--}%
    %{--} //buttons--}%
    %{--}); //dialog--}%
    %{--setTimeout(function () {--}%
    %{--b.find(".form-control").first().focus()--}%
    %{--}, 500);--}%
    %{--} //success--}%
    %{--}); //ajax--}%
    %{--} //createEdit--}%

    $(function () {

        $(".btnCrear").click(function() {
        location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}?universidad=" + $("#universidadId").val();
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
                        location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}/" + id + "?ver=" + 1
                    }
                },
                fechas   : {
                    label  : "Fechas",
                    icon   : "fa fa-calendar",
                    action : function ($element) {
                        var id = $element.data("id");
                        $.ajax({
                            type: "POST",
                            url: "${createLink(controller: 'auxiliares', action: 'fechas_ajax')}",
                            data: {
                                id: id
                            },
                            success: function (msg) {
                                var b = bootbox.dialog({
                                    id: "dlgEditarFechas",
                                    title: "Editar Fechas",
                                    message: msg,
                                    class: "small",
                                    buttons: {
                                        cierre: {
                                            label: "<i class='fa fa-exclamation-circle'></i> Sin fecha de Cierre",
                                            className: "btn-warning",
                                            callback: function () {
                                                $("#fechaFin").val(null)
                                                return false
                                            }
                                        },
                                        cancelar: {
                                            label: "Cancelar",
                                            className: "btn-primary",
                                            callback: function () {
                                            }
                                        },
                                        guardar: {
                                            id: "btnSave",
                                            label: "<i class='fa fa-save'></i> Guardar",
                                            className: "btn-success",
                                            callback: function () {
                                                $.ajax({
                                                    type: 'POST',
                                                    url: "${createLink(controller: 'auxiliares', action: 'guardarFecha_ajax')}",
                                                    data:{
                                                        id: id,
                                                        fechaInicio: $("#fechaInicio").val(),
                                                        fechaFin: $("#fechaFin").val()
                                                    },
                                                    success: function (msg) {
                                                        if(msg == 'ok'){
                                                            log("Fecha guardada correctamente","success");
                                                            setTimeout(function () {
                                                                location.reload(true);
                                                            }, 800);
                                                        }else{
                                                            log("Error al guardar la fecha","error")
                                                        }
                                                    }
                                                });
//                                                        return submitForm(tipo);
                                            } //callback
                                        } //guardar
                                    } //buttons
                                }); //dialog
                            } //success
                        }); //ajax


                    }
                },
                editar   : {
                    label  : "Editar",
                    icon   : "fa fa-pencil",
                    action : function ($element) {
                        var id = $element.data("id");
//                                createEditRow(id);
                        location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}/" + id
                    }
                }
//                        ,
//                        eliminar : {
//                            label            : "Eliminar",
//                            icon             : "fa fa-trash-o",
//                            separator_before : true,
//                            action           : function ($element) {
//                                var id = $element.data("id");
//                                deleteRow(id);
//                            }
//                        }
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
