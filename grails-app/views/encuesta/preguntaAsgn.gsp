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
        width: 78%;
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
        padding: 2px 5px;
        margin-top: -2px;
        font-weight: normal;
        border-radius: 8px;
        font-size: 14px;
        border-style: solid;
        border-color: #d0d0ff;
        border-width: 1px;
    }

    .radio-toolbar input[type="radio"]:checked + label{
        font-weight: bold;
        background-color: #fff3d0;
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

        <div class="panel panel-default fila">
            <div class="panel-heading">
                <h3 class="panel-title">Pregunta ${actual} de ${total}</h3>
            </div>

            <div class="panel-body" style="font-size: 1.4em">${pregunta.dscr}</div>
            <input type="hidden" name="preg__id" value="${pregunta.id}">
            <input type="hidden" name="tipopreg" value="${tppr}">
        </div>

        <div class="panel panel-default fila ${tppr == 'Cp' ? 'text-success':'text-info'}">
        %{--<div class="panel panel-default" style="width: 70%; margin: 0 auto">--}%
            <div class="panel-heading">
                <span style="font-weight: bold; font-size: large">Seleccione una ${tppr == 'Cp'? 'Competencia': 'Asignatura'}</span>
            </div>

            <div class="panel-body">
                <g:each in="${materias}" var="m" status="i">

                    <div class="radio-toolbar" style="margin-bottom: 0">
                        <input type="radio" name="materia" value="${m.id}"
                            ${(m.id == resp[1] ? 'checked' : ' ')} id="${m.id}_${i}">
                        <label for="${m.id}_${i}">${m.dscr}</label>
                    </div>
                </g:each>
            </div>
        </div>

    </g:form>

</div>


<div class="row col-md-12 col-xs-12">
    <a class="btn btn-danger col-md-4 col-xs-4" href="#" id="abandonar"><i class="fa fa-trash-o"></i> Abandonar encuesta</a>
    <g:if test="${actual > 1}">
        <a class="btn btn-default col-md-4 col-xs-4" href="#" id="anterior"><i class="fa fa-arrow-left"></i> Anterior</a>
    </g:if>
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
            var resp =  $('input[name=materia]:checked').length;
            if (resp == 0) {
                bootbox.alert({
                    title: "No ha seleccionado una respuesta",
                    message: "Escoja una de las opciones de 'Seleccione una Respuesta' ",
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
