<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main_q"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.12.0.css')}" rel="stylesheet">
    <script src="${resource(dir: 'js', file: 'jquery-ui.min.js')}"></script>

    <title>Quanto</title>
    <style>
    .fila1 {
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
        line-height: 1.0em;
        padding: 0 3px;
        margin-top: -2px;
        font-weight: normal;
        border-radius: 8px;
    }

    .radio-toolbar input[type="radio"]:checked + label {
        font-weight: bold;
        background-color: #ffe869;
    }

    </style>
</head>

<body>
<div class="container ui-widget-content ui-corner-all" style="height: auto">
    <p style="text-align: center; font-size: large; color: #495a6b">${tpen.descripcion}</p>
    <g:if test="${profesor}">
        <p style="text-align: center; color: #495a6b">Docente: <strong>${profesor}</strong> &nbsp; ${materia? "Materia: $materia": ""}</p>
    </g:if>

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
                    <div class="radio-toolbar resp" style="margin-bottom: 1.0em;">
                        <input type="radio" name="respuestas" value="${respuesta.id}"
                            ${(respuesta.id == resp[0] ? 'checked' : ' ')} id="${respuesta.id}">
                        <label for="${respuesta.id}">${respuesta.dscr}</label>
                    </div>
                </g:each>
            </div>
        </div>

    </g:form>

</div>

<div class="row col-md-12 col-xs-12">
    <a class="btn btn-danger col-md-4 col-xs-4" href="#" id="abandonar"><i class="fa fa-trash-o"></i> Abandonar encuesta</a>
    <a class="btn btn-default col-md-4 col-xs-4" href="#" id="anterior"><i class="fa fa-arrow-left"></i> Anterior</a>
    <g:if test="${actual == total}">
        <a class="btn btn-info  col-md-4 col-xs-4" href="#" id="siguiente"><strong>Finalizar Encuesta</strong> <i
                class="fa fa-check"></i></a>
    </g:if>
    <g:else>
        <a class="btn btn-default col-md-4 col-xs-4" href="#" id="siguiente">Siguiente <i class="fa fa-arrow-right"></i></a>
    </g:else>
</div>


<script type="text/javascript">
    $(function () {
        $(document).ready(function () {
            // Handler for .ready() called.
            $(".resp").change();
        });

        $("#abandonar").click(function () {
            bootbox.confirm({
                title: "¿Abandonar la encuesta?",
                message: "Si abandona la encuesta podrá retomarla desde la última pregunta contestada.",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i> Aceptar',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if(result) {
                        location.href = "${createLink(action: 'previa')}"
                    }
                }
            });
        });

        $("#anterior").click(function () {
            bootbox.confirm({
                title: "¿Regresar a la pregunta anterior?",
                message: "Confirme la orden o presione Cancelar",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i> Aceptar',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if(result) {
                        location.href = "${createLink(action: 'anterior')}" + "?encu__id=${encu}&actual=${actual}"
                    }
                }
            });
        });

        $("#siguiente").click(function () {
            var respit = $('input[name=respuestas]:checked').length;
            if (respit == 0) {
                bootbox.alert({
                    title: "No ha seleccionado una respuesta",
                    message: "Escoja una de las opciones de 'Seleccione una Respuesta', si ha seleccionado " +
                    "ASIGNATURA, asegúrese de haber escogido una.",
                    buttons: {
                        ok: {
                            label: '<i class="fa fa-check"></i> Aceptar',
                            className: 'btn-success'
                        }
                    }
                });
                return false;
            } else {
                $("#forma").submit();
                return true;
            }
        });
    });
</script>
</body>
</html>
