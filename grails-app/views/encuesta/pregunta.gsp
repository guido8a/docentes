<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main"/>

    %{--<link rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css">--}%
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.12.0.css')}" rel="stylesheet">
    %{--<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>--}%
    <script src="${resource(dir: 'js', file: 'jquery-ui.min.js')}"></script>


    <title>Quanto</title>
    <style>
    .fila1 {
        /*border: 1px solid #c0c0c0;*/
        border: 1px solid #495a6b;
        float: left;
        width: 75%;
    }

    .fila2 {
        border: 1px solid #495a6b;
        margin-left: 15px;
        float: left;
        width: 23%;
    }

    .radio-toolbar input[type="radio"] {
        cursor: pointer;
    }

    .radio-toolbar label {
        padding: 4px 3px;
        font-size: 12px;
        font-weight: normal;
        border-radius: 8px;
    }

    .radio-toolbar input[type="radio"]:checked + label {
        font-weight: bold;
        background-color: #c7d9eb;
    }

    </style>
</head>

<body>
<div class="container ui-widget-content ui-corner-all" style="height: auto">
    <p style="text-align: center; font-size: large; color: #495a6b">${tpen.descripcion}</p>
    <p style="text-align: center; color: #495a6b">Docente: <strong>${profesor}</strong> &nbsp; ${materia? "Materia: <strong>$materia</strong>": ""}</p>

    <g:form name="forma" role="form" action="respuesta" controller="encuesta" method="POST">
        <input type="hidden" name="encu__id" value="${encu}">
        <input type="hidden" name="tpen__id" value="${tpen.id}">
        <input type="hidden" name="actual" value="${actual}">

        <div class="mensaje" style="display: none;"></div>

        <div class="panel panel-default fila1">
            <div class="panel-heading">
                <h3 class="panel-title">Pregunta ${actual} de ${total}</h3>
            </div>

            <div class="panel-body" style="font-size: 1.5em">${pregunta.dscr}</div>
            <input type="hidden" name="preg__id" value="${pregunta.id}">
        </div>

        <div class="panel panel-default fila2">

            <div class="panel-heading">
                <span style="font-weight: bold">Seleccione una Respuesta</span>
            </div>

            <div class="panel-body">
                <g:each in="${rp}" var="respuesta">
                    <div style="width: 190px; height: 25px;cursor:pointer; " class="radio-toolbar">
                        <input style="float: left;" type="radio" value="${respuesta.id}"
                               name="respuestas" ${(respuesta.id == resp[0] ? 'checked' : ' ')}>
                        <label>${respuesta.dscr}</label>
                    </div>
                </g:each>
            </div>
        </div>

    </g:form>

</div>

<div class="bs-component" style="margin-bottom: 15px;">
    <div class="btn-group btn-group-justified">
        <a class="btn btn-danger" href="#" id="abandonar"><i class="fa fa-trash-o"></i> Abandonar encuesta</a>
        <g:if test="${(actual > 1)}">
        <a class="btn btn-default" href="#" id="anterior"><i class="fa fa-arrow-left"></i> Anterior</a>
        </g:if>
        <g:if test="${actual == total}">
        <a class="btn btn-info" href="#" id="siguiente"><strong>Finalizar Encuesta</strong> <i class="fa fa-check"></i></a>
        </g:if>
        <g:else>
            <a class="btn btn-default" href="#" id="siguiente">Siguiente <i class="fa fa-arrow-right"></i></a>
        </g:else>
    </div>
</div>

<div id="mensajeAbandonar" style="display: none; background-color: #ffeaea">
    <div style="font-size: medium; color: #4b1918">
        ¿Está seguro de abandonar la encuesta?<br>
        Para completarla debe volver a seleccionar el mismo profesor y continuar desde la pregunta en que abandonó.
    </div>
</div>

<div id="mensajeAnterior" style="display: none;">
    <div style="font-size: medium; color: #444">
        ¿Ir a la respuesta anterior?<br>
    </div>
</div>

<div id="sinRespuesta" style="display: none;">
    <div style="font-size: medium; color: #844">
        ¿No ha seleccionado una respuesta?<br>
        Escoja una opción de <strong>Seleccione una Respuesta</strong>.
    </div>
</div>

<script type="text/javascript">
    $(function () {
        var boton = $("#buscar");
        $(document).ready(function () {
            // Handler for .ready() called.
            $(".resp").change();
        });


        $("#materias").dialog({
            autoOpen: false,
            resizable: true,
            title: 'Seleccione una materia',
            modal: true,
            width: "auto",
            height: "auto",
            position: {my: "left top", at: "left top-40px", of: boton},  //izquierda arriba del boton-40px
//            open: function(event, ui) {
//                $(".ui-dialog-titlebar-close").hide();
//            },
            buttons: {
                "Aceptar": function () {
                    $("#matVal").val($("#div_" + $('.radioMat:checked').attr("id")).text())
                    $("#materia").val($('.radioMat:checked').val())
//                console.log(jQuery('.radioMat:checked').val(),$("#div_"+jQuery('.radioMat:checked').attr("id")))
                    $(this).dialog("close");
                },
                "Cancelar": function () {
//                    $("#matVal").val("")
//                    $("#materia").val("")
                    $(this).dialog("close");
                }
            }
        });

        $("#mensajeAbandonar").dialog({
            dialogClass: "alert",
            autoOpen: false,
            resizable: false,
            height: "auto",
            width: 400,
            modal: true,
            title: 'Confirme la orden',
            buttons: {
                "Aceptar": function () {
                    $(this).dialog("close");
                    location.href = "${createLink(action: 'previa')}";
                },
                Cancelar: function () {
                    $(this).dialog("close");
                }
            }
        });

        $("#mensajeAnterior").dialog({
            dialogClass: "alert",
            autoOpen: false,
            resizable: false,
            height: "auto",
            width: 400,
            modal: true,
            title: 'Confirme la orden',
            buttons: {
                "Aceptar": function () {
                    $(this).dialog("close");
                    location.href = "${createLink(action: 'anterior')}" + "?encu__id=${encu}&actual=${actual}"
                },
                Cancelar: function () {
                    $(this).dialog("close");
                }
            }
        });

        $("#sinRespuesta").dialog({
            dialogClass: "alert",
            autoOpen: false,
            resizable: false,
            height: "auto",
            width: 400,
            modal: true,
            title: 'No hay respuestas',
            buttons: {
                "Aceptar": function () {
                    $(this).dialog("close");
                }
            }
        });

        $("#buscar").click(function () {
            $(".radio:first").attr("checked", "checked");
            $("#materias").dialog("open");
        });

        $("#abandonar").click(function () {
            $("#mensajeAbandonar").dialog("open");
//            console.log('Abortar');
        });
        $("#anterior").click(function () {
            $("#mensajeAnterior").dialog("open");
//            console.log('Anterior');
        });

        $("#siguiente").click(function () {
            var respit = $('input[name=respuestas]:checked').length;
            if (respit == 0) {
                $("#sinRespuesta").dialog("open");
                return false;
            } else {
                $("#forma").submit();
//                console.log('Siguiente');
                return true;
            }
        });

    });
</script>
</body>
</html>
