<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/02/17
  Time: 10:40
--%>

<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js/vendor', file: 'jquery.ui.widget.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js/imgResize', file: 'load-image.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js/imgResize', file: 'canvas-to-blob.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.iframe-transport.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.fileupload.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.fileupload-process.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.fileupload-image.js')}"></script>
<link href="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/css', file: 'jquery.fileupload.css')}"
      rel="stylesheet">

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cargar Datos</title>
    <style type="text/css">

    .conBorde {
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    </style>

</head>

<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div class="col-md-12 btn-block" style="text-align: center; height: 50px">
    <a href="#" class="btn col-md-3 btn-danger" id="borrarDatos">Borrar datos</a>
    <a href="#" class="btn col-md-3 btn-primary" id="validarDatos">Validar archivo</a>
    <a href="#" class="btn col-md-3 btn-info" id="cargarDatos">Cargar datos</a>
    <a href="#" class="btn col-md-3 btn-success" id="masDatos">Añadir datos</a>
</div>

<div class="col-md-3" id="botones">

</div>

<div class="col-md-8">
    <div class="panel panel-primary">
        <div class="panel-heading">Formato de los archivos Excel (.xls)</div>

        <div class="panel-body" id="formato">

        </div>
    </div>
</div>

<div class="col-md-8">
    <g:uploadForm action="validar" method="post" name="frmaArchivo">
    <div class="panel panel-primary">
        <div class="panel-heading">Seleccionar el archivo a cargar</div>

        <div class="panel-body">
            <span class="btn btn-info fileinput-button col-md-8" style="position: relative">
                %{--<i class="glyphicon glyphicon-plus"></i>--}%
                %{--<span>Seleccionar archivo</span>--}%
                <input type="file" name="file" multiple="" id="archivo" class="archivo col-md-12">
                <input type="hidden" name="tipoTabla" id="tipoTabla" value="">
            </span>
            <div class="col-md-1"></div>
            <div class="col-md-4" id="spinner">
            </div>
        </div>

    </div>
    </g:uploadForm>
</div>

<script type="text/javascript">

    var url = "${resource(dir:'images', file:'spinner64.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' width='40px' height='40px'/><span> Cargando...</span>");

    cargarBotones(1);
    cargarFormato(1);

    function cargarBotones(boton) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'procesos', action: 'botones_ajax')}',
            data: {
                boton: boton
            },
            success: function (msg) {
                $("#botones").html(msg)
            }
        });
    }

    function cargarFormato(tipo) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'procesos', action: 'formato_ajax')}",
            data: {
                tipo: tipo
            },
            success: function (msg) {
                $("#formato").html(msg)
                $(".list-group-item").removeClass("list-group-item-danger")
                $("#btn" + $("#tablaTipo").val()).addClass("list-group-item-danger")
            }
        })
    }

    $("#borrarDatos").click(function () {
        $.ajax({
            type: 'POST',
            url: "${createLink(action: 'periodos_ajax')}",
            success: function (msg){
                bootbox.dialog({
                    id      : "dlgRecomendacion",
                    title   : "¿Esta a punto de Borrar los datos del período?",
//                    class   : "long",
                    message : "<h4>Borrar los datos de Materias dictadas y Estudiantes Matriculados</h4>" + msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "Borrar",
                            className : "btn-warning",
                            callback  : function () {
                                $.ajax({
                                    type: 'POST',
                                    url: '${createLink(action: 'borrarDatos')}',
                                    data:{
                                        id: $("#periodoId").val()
                                    },
                                    success: function (msg){
                                        var ms = msg.split("_");
                                        if(ms[0] == 'ok'){
                                            log(ms[1],"success")
                                        }else{
                                            log(ms[1],"error")
                                        }
                                    }
                                })
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });

    });

    $("#validarDatos").click(function () {
        var arch = $('#archivo').val();
        var boton = $("#tabla").val();
        console.log('archivo:', arch);
        if (arch) {
            $.ajax({
                type: 'POST',
                url: "${createLink(action: 'periodos_ajax')}",
                success: function (msg){
                    bootbox.dialog({
                        title   : "¿Validar archivo para el período..?",
//                    class   : "long",
//                        message : "<h4>Archivo " + arch + </h4>" + msg,
                        message : "Se validará: <strong>" + arch + "</strong> como archivo de datos para <strong>" +
                           boton + "</strong>" + msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            aceptar : {
                                label     : "Validar",
                                className : "btn-warning",
                                callback  : function () {
                                    $("#tipoTabla").val($("#tabla").val());
                                    $("#spinner").replaceWith(spinner);
                                    $("#frmaArchivo").submit();
                                }
                            }

                        } //buttons
                    }); //dialog
                }
            });

            return true;
        } else {
            bootbox.alert({
                title: "Seleccione el archivo a validar",
                message: "Seleccione el archivo de datos para realizar el proceso de validación",
                buttons: {
                    ok: {
                        label: '<i class="fa fa-check"></i> Aceptar',
                        className: 'btn-success'
                    }
                }
            });
            return false;
        }
    });

    $("#cargarDatos").click(function () {
        var foo = "bar1";
        var foo1 = "bar2";
        var ob  = {};
        ob[foo] = "something";
        ob[foo1] = "something dos";
        alert("json:" + JSON.stringify(ob))
    })

</script>

</body>
</html>