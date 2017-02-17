<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Carga de archivo</title>
    </head>

    <body>
        <div class="well">
            <g:link class="btn btn-primary" controller="procesos" action="cargarDatos" id="${obra}">Regresar a cargar datos</g:link>
            <div>
            ${raw(html)}

            </div>

            %{--<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase} col-md-12" contenido="${flash.message}"></elm:flashMessage>--}%

            <g:link class="btn btn-primary" controller="procesos" action="cargarDatos" id="${obra}">Regresar a cargar datos</g:link>
        </div>
    </body>
</html>