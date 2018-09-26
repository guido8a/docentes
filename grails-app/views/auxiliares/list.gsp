
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
            <div class="btn-group">
                <g:link action="auxiliares" class="btn btn-info btnCrear">
                    <i class="fa fa-file-o"></i> Crear
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
                    <g:sortableColumn property="periodo" title="Período Académico" />

                    <g:sortableColumn property="minimo" title="Índice de calidad Mínimo" />
                    
                    <g:sortableColumn property="optimo" title="Índice de calidad Óptimo" />
                    
                    <g:sortableColumn property="maximoDirectivos" title="Ponderación para evaluación de Directivos" />
                    
                    <g:sortableColumn property="maximoPares" title="Ponderación para evaluación de Pares" />
                    
                    <g:sortableColumn property="maximoAutoevaluacion" title="Ponderación para Autoevaluaciones" />
                    
                    <g:sortableColumn property="maximoEstudiantes" title="Ponderación para evaluación de Estudiantes" />
                    <g:sortableColumn property="fechaInicio" title="Fecha de inicio Evaluaciones" />
                    <g:sortableColumn property="fechaCierre" title="Fecha de cierre Evaluaciones" />

                </tr>
            </thead>
            <tbody>
                <g:each in="${auxiliaresInstanceList}" status="i" var="auxiliaresInstance">
                    <tr data-id="${auxiliaresInstance.id}">
                        <td><strong>${auxiliaresInstance?.periodo?.nombre}</strong></td>
                        <td>${auxiliaresInstance?.minimo?.toInteger()}</td>
                        <td>${auxiliaresInstance?.optimo?.toInteger()}</td>
                        <td>${auxiliaresInstance?.maximoDirectivos}</td>
                        <td>${auxiliaresInstance?.maximoPares}</td>
                        <td>${auxiliaresInstance?.maximoAutoevaluacion}</td>
                        <td>${auxiliaresInstance?.maximoEstudiantes}</td>
                        <td>${auxiliaresInstance?.fechaInicio.format('yyyy-MM-dd')}</td>
                        <td>${auxiliaresInstance?.fechaCierre ? auxiliaresInstance?.fechaCierre.format('yyyy-MM-dd') : ''}</td>
                    </tr>
                </g:each>
            </tbody>
        </table>

        <elm:pagination total="${auxiliaresInstanceCount}" params="${params}"/>

        <script type="text/javascript">
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
//                        log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)
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

                %{--$(".btnCrear").click(function() {--}%
                    %{--location.href="${createLink(controller: 'auxiliares', action: 'auxiliares')}";--}%
                %{--});--}%

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
                                %{--$.ajax({--}%
                                    %{--type    : "POST",--}%
                                    %{--url     : "${createLink(action:'show_ajax')}",--}%
                                    %{--data    : {--}%
                                        %{--id : id--}%
                                    %{--},--}%
                                    %{--success : function (msg) {--}%
                                        %{--bootbox.dialog({--}%
                                            %{--title   : "Ver",--}%
                                            %{--message : msg,--}%
                                            %{--buttons : {--}%
                                                %{--ok : {--}%
                                                    %{--label     : "Aceptar",--}%
                                                    %{--className : "btn-primary",--}%
                                                    %{--callback  : function () {--}%
                                                    %{--}--}%
                                                %{--}--}%
                                            %{--}--}%
                                        %{--});--}%
                                    %{--}--}%
                                %{--});--}%
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
