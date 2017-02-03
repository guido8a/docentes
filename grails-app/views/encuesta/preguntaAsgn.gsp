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
    .fila3 {
        border: 1px solid #495a6b;
        float: left;
        width: 76%;
    }

    .fila {
        border: 1px solid #495a6b;
        float: left;
        width: 100%;
    }

    .fila1 {
        border: 1px solid #495a6b;
        float: right;
        width: 22%;
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

    .radio-toolbar input[type="radio"]:checked + label{
        font-weight: bold;
        background-color: #ffe869;
    }
    .marcado{
        font-weight: bold;
        background-color: #ffe869;
    }
    </style>
</head>

<body>
<div class="container ui-widget-content ui-corner-all" style="height: auto">
    <p style="text-align: center; font-size: large; color: #495a6b">Encuesta de ${tpen.descripcion}</p>

    <g:form name="forma" role="form" action="respuestaAsgn" controller="encuesta" method="POST">
        <input type="hidden" name="encu__id" value="${encu}">
        <input type="hidden" name="tpen__id" value="${tpen.id}">
        <input type="hidden" name="actual" value="${actual}">

        <div class="mensaje" style="display: none;"></div>

        <div class="panel panel-default fila3">
            <div class="panel-heading">
                <h3 class="panel-title">Pregunta ${actual} de ${total}</h3>
            </div>

            <div class="panel-body" style="font-size: 1.4em">${pregunta.dscr}</div>
            <input type="hidden" name="preg__id" value="${pregunta.id}">
        </div>

        <div class="panel panel-default fila1">
            <div class="panel-heading">
                <span style="font-weight: bold">Seleccione una Respuesta</span>
            </div>

            <div class="panel-body">
                <g:each in="${rp}" var="respuesta">
                    <div class="radio-toolbar resp" style="margin-bottom: 1.5em;">
                        <input type="radio" name="respuestas" value="${respuesta.id}"
                                ${(respuesta.id == resp[0] ? 'checked' : ' ')} id="${respuesta.id}">
                        <label for="${respuesta.id}">${respuesta.dscr}</label>
                    </div>
                </g:each>
            </div>
        </div>

    %{--${materias}--}%
        <div id="materias" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="exampleModalLabel">Seleccione una materia</h4>
                    </div>
                    <!-- dialog body -->
                    <div class="modal-body">
                    <g:each in="${materias}" var="m" status="i">
                        <div class="radio-toolbar respRadio" style="margin-bottom: 1.0em;">
                            <label  id="div_${m.id}_${i}" class="marca ${(m.id == resp[1]) ? 'marcado' : ''}">
                                <input type="radio" name="respMat" id="${m.id}_${i}" class="radioMat"
                                       value="${m.id}" ${(m.id == resp[1]) ? 'checked' : ''}>${m.dscr}</label>
                        </div>
                    </g:each>

                    <script>
                        $(".marca").mousedown(function () {
                            console.log($(this).val())
                            $(".marca").removeClass("marcado");
                            $(this).addClass("marcado")
                        });
                    </script>
                    </div>
                    <!-- dialog buttons -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="modalCancelar">Cancelar</button>
                        <button type="button" class="btn btn-success" id="modalOk">Aceptar</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="panel panel-default fila" id="divAsignatura" style="display: none">
            <div class="panel-heading">
                <h3 class="panel-title">Asignatura</h3>
            </div>

            <div class="panel-body" style="font-size: 1.2em">
                <input type="text" readonly id="matVal" name="asignatura" style="color: #000; width: 75%"
                       value="${materias.find { it.id == resp[1] }?.dscr}">
                %{--<input type="text" disabled id="matVal" style="color: #000; width: 400px;" value="">--}%
                <input id="buscar" type="button" value="Buscar asignatura" class="tbbtn fg-button fondo ui-corner-all">
                <input type="hidden" name="materia" id="materia" value="${resp[1]}">
            </div>
        </div>
    %{--
            <div class=" filaEntera ui-corner-all barra"  >
                Asignatura :
                <input type="text" disabled id="matVal" style="color: #000; width: 400px;" >
                <input id="buscar" type="button" value="Buscar" class="tbbtn fg-button fondo ui-corner-all">
                <input type="hidden" name="materia" id="materia" value="${resp[pregcdgo]?.get(1)}">
            </div>
    --}%
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


<div id="mensajeAbandonar" style="display: none; background-color: #ffeaea">
    <div style="font-size: medium; color: #4b1918">
        ¿Está seguro de abandonar la encuesta?<br>
        Se borrarán todas las respuestas registradas.
    </div>
</div>

<script type="text/javascript">
    $(function () {
        var boton = $("#buscar");
        $(document).ready(function () {
            // Handler for .ready() called.
            $(".resp").change();
        });


        $("#buscar").click(function () {
            $(".marca").removeClass("marcado");
            $("#div_" + $('.radioMat:checked').attr("id")).addClass("marcado");
            $("#materias").modal("show");
        });

//      Aceptar del Modal --> modalOk
        $("#modalOk").click(function () {
//            console.log($("#div_" + $('.radioMat:checked').attr("id")).text().trim(), $('.radioMat:checked').val());
            $("#matVal").val($("#div_" + $('.radioMat:checked').attr("id")).text().trim())
            $("#materia").val($('.radioMat:checked').val())
            $("#materias").modal("hide");
        });

        $("#modalCancelar").click(function () {
            $("#materias").modal("hide");
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


        $("#siguiente").click(function () {
            var resp = $('input[name=respuestas]:checked').length;
//            var mate = $('#matval').val();
            var mate = $("input[name=asignatura]").val();
//            console.log('mate:', mate, resp);
            if (resp == 0 || mate === undefined) {
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

        $(".resp").change(function () {
//            console.log('cambia resp');
            if ($('input[name=respuestas]:checked').val() === '${asgn}') {
                $('#divAsignatura').show(500);
            } else {
                $('#divAsignatura').hide(500);
            }
            ;
        });

    });
</script>
</body>
</html>
