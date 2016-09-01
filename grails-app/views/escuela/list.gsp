
<%@ page import="docentes.Facultad; docentes.Escuela" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de Escuela</title>
    </head>
    <body>

        <elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

    <!-- botones -->
        %{--<div class="btn-toolbar toolbar">--}%


        <div class="row" style="margin-bottom: 10px">

            <div class="btn-group">
                <g:link action="form" class="btn btn-info btnCrear">
                    <i class="fa fa-file-o"></i> Nueva Escuela
                </g:link>
            </div>

            <div class="col-md-2 negrilla control-label">Facultad: </div>
            <div class="col-md-7">
                <g:select name="facultad" id="facultadId" optionKey="id" optionValue="nombre"
                          class="form-control" from="${docentes.Facultad.list([sort: 'nombre', order: 'asc'])}"/>
            </div>
        </div>


    <table class="table table-condensed table-bordered table-striped">
        <thead>
        <tr>
            <th style="width: 3%">Código</th>
            <th style="width: 10%">Nombre</th>
        </tr>
        </thead>
    </table>


    <div id="tablaEscuelas">

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

        %{--<table class="table table-condensed table-bordered table-striped">--}%
            %{--<thead>--}%
                %{--<tr>--}%
                    %{----}%
                    %{--<g:sortableColumn property="codigo" title="Codigo" />--}%
                    %{----}%
                    %{--<g:sortableColumn property="nombre" title="Nombre" />--}%
                    %{----}%
                    %{--<th>Facultad</th>--}%
                    %{----}%
                %{--</tr>--}%
            %{--</thead>--}%
            %{--<tbody>--}%
                %{--<g:each in="${escuelaInstanceList}" status="i" var="escuelaInstance">--}%
                    %{--<tr data-id="${escuelaInstance.id}">--}%
                        %{----}%
                        %{--<td>${fieldValue(bean: escuelaInstance, field: "codigo")}</td>--}%
                        %{----}%
                        %{--<td>${fieldValue(bean: escuelaInstance, field: "nombre")}</td>--}%
                        %{----}%
                        %{--<td>${fieldValue(bean: escuelaInstance, field: "facultad")}</td>--}%
                        %{----}%
                    %{--</tr>--}%
                %{--</g:each>--}%
            %{--</tbody>--}%
        %{--</table>--}%

        %{--<elm:pagination total="${escuelaInstanceCount}" params="${params}"/>--}%

        %{--<script type="text/javascript">--}%
            %{--var id = null;--}%
            %{--function submitForm() {--}%
                %{--var $form = $("#frmEscuela");--}%
                %{--var $btn = $("#dlgCreateEdit").find("#btnSave");--}%
                %{--if ($form.valid()) {--}%
                %{--$btn.replaceWith(spinner);--}%
                    %{--$.ajax({--}%
                        %{--type    : "POST",--}%
                        %{--url     : '${createLink(action:'save_ajax')}',--}%
                        %{--data    : $form.serialize(),--}%
                            %{--success : function (msg) {--}%
                        %{--var parts = msg.split("_");--}%
                        %{--log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)--}%
                        %{--if (parts[0] == "OK") {--}%
                            %{--location.reload(true);--}%
                        %{--} else {--}%
                            %{--spinner.replaceWith($btn);--}%
                            %{--return false;--}%
                        %{--}--}%
                    %{--}--}%
                %{--});--}%
            %{--} else {--}%
                %{--return false;--}%
            %{--} //else--}%
            %{--}--}%
            %{--function deleteRow(itemId) {--}%
                %{--bootbox.dialog({--}%
                    %{--title   : "Alerta",--}%
                    %{--message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar el Escuela seleccionado? Esta acción no se puede deshacer.</p>",--}%
                    %{--buttons : {--}%
                        %{--cancelar : {--}%
                            %{--label     : "Cancelar",--}%
                            %{--className : "btn-primary",--}%
                            %{--callback  : function () {--}%
                            %{--}--}%
                        %{--},--}%
                        %{--eliminar : {--}%
                            %{--label     : "<i class='fa fa-trash-o'></i> Eliminar",--}%
                            %{--className : "btn-danger",--}%
                            %{--callback  : function () {--}%
                                %{--$.ajax({--}%
                                    %{--type    : "POST",--}%
                                    %{--url     : '${createLink(action:'delete_ajax')}',--}%
                                    %{--data    : {--}%
                                        %{--id : itemId--}%
                                    %{--},--}%
                                    %{--success : function (msg) {--}%
                                        %{--var parts = msg.split("_");--}%
                                        %{--log(parts[1], parts[0] == "OK" ? "success" : "error"); // log(msg, type, title, hide)--}%
                                        %{--if (parts[0] == "OK") {--}%
                                            %{--location.reload(true);--}%
                                        %{--}--}%
                                    %{--}--}%
                                %{--});--}%
                            %{--}--}%
                        %{--}--}%
                    %{--}--}%
                %{--});--}%
            %{--}--}%
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
                            %{--title   : title + " Escuela",--}%
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

            %{--$(function () {--}%

                %{--$(".btnCrear").click(function() {--}%
                    %{--createEditRow();--}%
                    %{--return false;--}%
                %{--});--}%


            %{--});--}%
        %{--</script>--}%


    <script type="text/javascript">


        cargarTabla($("#facultadId").val());

        $("#facultadId").change(function () {
            var facultad = $("#facultadId").val();
            cargarTabla(facultad)
        });


        function cargarTabla(facultad) {
            $.ajax({
                type:'post',
                url:"${createLink(controller: 'escuela', action: 'tablaEscuela_ajax')}",
                data:{
                    facu: facultad
                },
                success: function (msg){

                }
            });
        }

    </script>


    </body>
</html>
