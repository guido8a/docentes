<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main_q" />
    <title>Quanto Docentes</title>

    <style>
        .pie{
            background: #d0d0d0;
            width: 100%;
            height: 20px;
            font-family: serif;
            font-style: italic;
            font-size: 10pt;
            text-align: center;
            z-index: 2;
            margin-top: -15px;
        }
        th {
            text-align: center;
            background-color: #3d4854;
            color: #ffab19;
        }
    </style>
</head>
<body>
<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div style="text-align: center;">
    %{--Para personalizar: UNACH: universidad1.jpg, UPEC universidad.jpg y en messages_es.properties la universidad--}%
    <div class="contenedor">
        <div class="logo"><img src="${resource(dir:'images',file:'universidad.jpeg')}" height="100px"></div>
        <div class="logo_tx"><h1>${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1></div>
    </div>
        %{--<br>Sistema para uso exclusivo de la esta Universidad</div>--}%
    <p class="bs-component">
        <span class="btn btn-primary btn-md btn-block disabled" style="cursor: default; color: #ffffc0 ">
            <strong>Usted se ha identificado como ${session.informante}</strong></span>
    </p>
    <g:if test="${auto}">
    <g:link action="encuestaAD" class="btn btn-primary"><i class="fa fa-pencil"></i> Autoevaluación</g:link>
    </g:if>
    <g:if test="${pares}">
        <a href="${g.createLink(action: 'docentes', params: [tipo: 'PR'])}" class="btn btn-primary" title="Evaluación de los Pares a los Profesores">
            <i class="fa fa-pencil"></i>
            Evaluación de los Pares a los Profesores</a>
    </g:if>
    <g:if test="${drtv}">
        <a href="${g.createLink(action: 'docentes', params: [tipo: 'DR'])}" class="btn btn-primary" id="btnDrtv" title="Evaluación de los Directivos a los Profesores">
            <i class="fa fa-pencil"></i>
            Evaluación de los Directivos a los Profesores</a>
    </g:if>

    <div id="tabla">
    </div>

    <hr style="border-color: #0A246A; size: 2px"/>
    <div class="pie"> Desarrollado por: TEDEIN SA &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a></div>

</div>

<script type="text/javascript" src="${resource(dir:'js/jquery/js',file:'jquery-1.4.2.min.js')}"></script>
<script type="text/javascript">
    $("#btnPares").click(function () {
        $("#tabla").html("").append($("<div style='width:100%; text-align: center;'/>").append(spinnerSquare64));
        $.ajax({
            type: "POST",
            url: "${g.createLink(action: 'buscarProfesor')}",
            success: function (msg) {
                $("#tabla").html(msg);
            },
            error: function (msg) {
                $("#tabla").html("Ha ocurrido un error");
            }
        });

    });

</script>


</body>
</html>
