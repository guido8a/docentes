<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="seguridad.Persona" %>

<html xmlns="http://www.w3.org/1999/html">
<head>
    <title>Quanto</title>
    <meta name="layout" content="main"/>
    <style type="text/css">
    @page {
        size: 8.5in 11in;  /* width height */
        margin: 0.25in;
    }

    .item {
        width: 320px;
        height: 230px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }
    .item2 {
        width: 660px;
        height: 160px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    .imagen {
        width: 200px;
        height: 130px;
        margin: auto;
        margin-top: 10px;
    }
    .imagen2 {
        width: 180px;
        height: 130px;
        margin: auto;
        margin-top: 10px;
        margin-right: 40px;
        float: right;
    }

    .texto {
        width: 90%;
        height: 50px;
        padding-top: 0px;
        margin: auto;
        margin: 8px;
        font-size: 16px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 20px;
        /*background-color: #317fbf; */
        background-color: rgba(114, 131, 147, 0.9);
        border: none;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
        color: #0070B0;
        margin-top: 20px;
    }
    </style>
</head>

<body>
<div class="dialog">
    <g:set var="inst" value="${utilitarios.Parametros.get(1)}"></g:set>

    <div style="text-align: center;"><h2 class="titl">
            <p class="text-warning">${inst.institucion}</p>
            <p class="text-warning">Quanto - Docentes</p>
        </h2>
    </div>

    <div class="body ui-corner-all" style="width: 1020px;position: relative;margin: auto;margin-top: 40px;height: 280px; ">


        <a href= "${createLink(controller:'encuesta', action: 'inicio')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'q_docente.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Evaluación al Docente</strong> por Pares, Directivos, Estudiantes y Autoevaluación</span></div>
            </div>
        </div>
        </a>

        <a href= "${createLink(controller:'buscarActividad', action: 'busquedaActividad')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'preguntas.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Encuestas</strong> preguntas y estructura de los distintos tipos de encuesta a aplicarse</span></div>
            </div>
        </div>
        </a>

        <a href= "${createLink(controller:'profesor', action: 'list')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'profesor.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Docentes</strong> registro de personal docente y materias que dicta</span></div>
            </div>
        </div>
        </a>

        <a href= "${createLink(controller:'estudiante', action: 'list')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'estudiante.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Estudiantes</strong> registro de estudiantes y matrícula</span></div>
            </div>
        </div>
        </a>

        <a href= "${createLink(controller:'buscarActividad', action: 'busquedaActividad')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'datos.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Cargar datos</strong> cargar datos desde archivos de hoja de cálculo</span></div>
            </div>
        </div>
        </a>

        <a href= "${createLink(controller:'buscarActividad', action: 'busquedaActividad')}" style="text-decoration: none">
        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'reportes.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto">
                    <span class="text-success"><strong>Reportes</strong> reportes del desempeño académico</span></div>
            </div>
        </div>
        </a>

    </div>


</div>
    <script type="text/javascript">
        $(".fuera").hover(function () {
            var d = $(this).find(".imagen,.imagen2")
            d.width(d.width() + 10)
            d.height(d.height() + 10)

        }, function () {
            var d = $(this).find(".imagen, .imagen2")
            d.width(d.width() - 10)
            d.height(d.height() - 10)
        })


        $(function () {
            $(".openImagenDir").click(function () {
                openLoader();
            });

            $(".openImagen").click(function () {
                openLoader();
            });
        });



    </script>
</body>
</html>
