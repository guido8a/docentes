<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main_q"/>

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
        width: 100%;
    }

    .fila2 {
        border: 1px solid #495a6b;
        float: left;
        width: 65%;
    }

    .fila3 {
        border: 1px solid #495a6b;
        float: right;
        width: 33%;
    }


    .radio-toolbar input[type="radio"], label {
        cursor: pointer;
    }

    .radio-toolbar label {
        line-height: 1.0em;
        padding: 2px 5px;
        margin-top: -2px;
        font-weight: normal;
        border-radius: 8px;
        font-size: 14px;
        border-style: solid;
        border-color: #d0d0e0;
        border-width: 1px;
    }

    .radio-toolbar input[type="radio"]:checked + label {
        font-weight: bold;
        background-color: #fff3d0;
    }

    </style>
</head>

<body>
<div class="container ui-widget-content ui-corner-all" style="height: auto">
    <p style="text-align: center; font-size: large; color: #495a6b">Encuesta de ${tpen.descripcion}</p>

    <g:form name="forma" role="form" action="respuestaPrit" controller="encuesta" method="POST">
        <input type="hidden" name="encu__id" value="${encu}">
        <input type="hidden" name="tpen__id" value="${tpen.id}">
        <input type="hidden" name="actual" value="${actual}">

        <div class="mensaje" style="display: none;"></div>

        <div class="panel panel-default fila1">
            <div class="panel-heading">
                <h3 class="panel-title">Pregunta ${actual} de ${total}</h3>
            </div>

            <div class="panel-body" style="font-size: 1.4em">${pregunta.dscr}</div>
            <input type="hidden" name="preg__id" value="${pregunta.id}">
        </div>


        <div class="panel panel-default fila2">
            <div class="panel-heading">
                <span style="font-weight: bold">Seleccione una opción</span>
            </div>

            <div class="panel-body">
                <g:each in="${prit}" var="pr">
                    <div class="radio-toolbar">
                        <input type="radio" name="causas" value="${pr.id}"
                               ${(pr.id == resp[2] ? 'checked' : ' ')} id="${pr.id}">
                        <label for="${pr.id}">${pr.dscr}</label>
                    </div>
                </g:each>
            </div>
        </div>


        <div class="panel panel-default fila3">

            <div class="panel-heading">
                <span style="font-weight: bold">Seleccione una opción</span>
            </div>

            <div class="panel-body">
                <g:each in="${rp}" var="respuesta">
                    <div class="radio-toolbar" style="margin-bottom: 1.5em;">
                        <input type="radio" name="respuestas" value="${respuesta.id}"
                                ${(respuesta.id == resp[0] ? 'checked' : ' ')} id="${respuesta.id}">
                        <label for="${respuesta.id}">${respuesta.dscr.split(' ')[0]}</label>
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
    var url = "${resource(dir:'images', file:'spinner32.gif')}";
    var spinner = $("<div class='btn col-md-4 col-xs-4' style='height: auto; border-color: #495a6b'><img  src='" + url + "'/><span> Cargando...</span></div>");

    $(function () {

        $(document).ready(function () {
            // Handler for .ready() called.
            $(".resp").change();
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
                        $("#anterior").replaceWith(spinner);
                        location.href = "${createLink(action: 'anterior')}" + "?encu__id=${encu}&actual=${actual}"
                    }
                }
            });
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
                        $("#abandonar").replaceWith(spinner);
                        location.href = "${createLink(action: 'previa')}"
                    }
                }
            });
        });


        $("#siguiente").click(function () {
            var respit = $('input[name=respuestas]:checked').length;
            var resprp = $('input[name=causas]:checked').length;
            if (respit == 0 || resprp == 0) {
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
                $("#siguiente").replaceWith(spinner);
                $("#forma").submit();
                return true;
            }
        });

    });
</script>
</body>
</html>
