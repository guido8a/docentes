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

    body{
        background-image:url('${resource(dir: "images", file: "cb8.jpg")}') !important;
        background-repeat: no-repeat;
        background-size: cover;
        width: 100%;
        height: 100%;
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




    body{font-family: 'Raleway', sans-serif;}

    .row.text-center p {
        font-size: 17px;
        font-weight: 600;
        letter-spacing: -0.3px;
        margin: 3px 0 30px;
        text-transform: uppercase;
    }

    .h3, h3 {
        font-family: 'Raleway', sans-serif;
        font-size: 24px;
        text-transform: uppercase;
        color: WHITE;
    }
    .btn-default {
        background: transparent none repeat scroll 0 0;
        border: 2px solid #fff;
        border-radius: 50px;
        text-shadow: 0 1px 0 #fff;
        font-family: 'Raleway', sans-serif;
    }
    .glyphicon {
        color: white;}
    .caption-text p {
        margin: 18px auto 13px;
        text-align: center;
        width: 91%;
    }
    .btn-default:focus, .btn-default:hover {
        background-color: #3f8825;
        background-position: 0 -15px;
    }

    .cuadro_intro_hover{
        padding: 0px;
        position: relative;
        overflow: hidden;
        height: 200px;
    }
    .cuadro_intro_hover:hover .caption{
        opacity: 1;
        transform: translateY(-150px);
        -webkit-transform:translateY(-150px);
        -moz-transform:translateY(-150px);
        -ms-transform:translateY(-150px);
        -o-transform:translateY(-150px);
    }
    .cuadro_intro_hover img{
        z-index: 4;
    }
    .cuadro_intro_hover .caption{
        position: absolute;
        top:150px;
        -webkit-transition:all 0.3s ease-in-out;
        -moz-transition:all 0.3s ease-in-out;
        -o-transition:all 0.3s ease-in-out;
        -ms-transition:all 0.3s ease-in-out;
        transition:all 0.3s ease-in-out;
        width: 100%;
    }
    .cuadro_intro_hover .blur{
        background-color: rgba(0,0,0,0.7);
        height: 300px;
        z-index: 5;
        position: absolute;
        width: 100%;
    }
    .cuadro_intro_hover .caption-text{
        z-index: 10;
        color: #fff;
        position: absolute;
        height: 300px;
        text-align: center;
        top:-20px;
        width: 100%;
    }

    .card {
        margin-top: 20px;
        padding: 30px;
        background-color: rgba(214, 224, 226, 0.2);
        -webkit-border-top-left-radius:5px;
        -moz-border-top-left-radius:5px;
        border-top-left-radius:5px;
        -webkit-border-top-right-radius:5px;
        -moz-border-top-right-radius:5px;
        border-top-right-radius:5px;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
    }
    .card.hovercard {
        position: relative;
        padding-top: 0;
        overflow: hidden;
        text-align: center;
        background-color: #fff;
        background-color: rgba(255, 255, 255, 1);
    }
    .card.hovercard .card-background {
        height: 100px;
    }
    .card-background img {
        -webkit-filter: blur(25px);
        -moz-filter: blur(25px);
        -o-filter: blur(25px);
        -ms-filter: blur(25px);
        filter: blur(25px);
        margin-left: -100px;
        margin-top: -200px;
        min-width: 130%;
    }
    .card.hovercard .useravatar {
        position: absolute;
        top: 15px;
        left: 0;
        right: 0;
    }
    .card.hovercard .useravatar img {
        width: 300px;
        height: 120px;
        max-width: 300px;
        max-height: 120px;
    }
    .card.hovercard .card-info {
        position: absolute;
        bottom: 14px;
        left: 0;
        right: 0;
    }
    .card.hovercard .card-info .card-title {
        padding:0 5px;
        font-size: 20px;
        line-height: 1;
        color: #262626;
        background-color: rgba(255, 255, 255, 0.1);
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
    }
    .card.hovercard .card-info {
        overflow: hidden;
        font-size: 12px;
        line-height: 20px;
        color: #737373;
        /*color: WHITE;*/
        text-overflow: ellipsis;
    }
    .card.hovercard .bottom {
        padding: 0 20px;
        margin-bottom: 17px;
    }
    .btn-pref .btn {
        -webkit-border-radius:0 !important;
    }



    </style>
</head>

<body>



<div class="dialog">
    <g:set var="inst" value="${utilitarios.Parametros.get(1)}"/>

    %{--<div class="card hovercard" style="z-index: 1000">--}%
    %{--<div class="card-background">--}%
    %{--</div>--}%
    <div class="useravatar" style="text-align: center;">
        <img alt="" src="${resource(dir: 'images', file: 'quanto.png')}">
    </div>
    %{--</div>--}%

    <div style="text-align: center;"><h1 class="titulo" style="font-size: 26px;">
        ${message(code: 'nombre')}
        %{--Sistema para Gestión de Conocimiento para la Mejora de la</br>Enseñanza - Aprendizaje</h1>--}%
    </div>
    <div style="text-align: center;"><h1 class="titl" style="font-size: 26px;">${univ.nombre}</h1></div>

    <div class="body ui-corner-all" style="width: 1020px;position: relative;margin: auto;margin-top: 40px;height: 280px; ">


        <div class="cuadro_intro_hover item ui-corner-all" style="background-color:#cccccc;">
            <p style="text-align:center;" class="imagen">
                <img src="${resource(dir: 'images', file: 'q_docente.png')}" width="100%" height="100%" class="img-responsive" alt=""/>
            </p>
            <div class="caption">
                <div class="blur"></div>
                <div class="caption-text">
                    <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Evaluaciones</h3>
                    <p><strong>Evaluación al Docente por Pares, Directivos, Estudiantes y Autoevaluación</strong></p>
                    <a class=" btn btn-default" href="${createLink(controller:'encuesta', action: 'inicio')}" target="_blank">
                        <span class="glyphicon glyphicon-plus"> Continuar</span></a>
                </div>
            </div>
        </div>

        <div class="cuadro_intro_hover item ui-corner-all" style="background-color:#cccccc;">
            <p style="text-align:center;" class="imagen">
                <img src="${resource(dir: 'images', file: 'preguntas.png')}" width="100%" height="100%" class="img-responsive" alt=""/>
            </p>
            <div class="caption">
                <div class="blur"></div>
                <div class="caption-text">
                    <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Encuestas</h3>
                    <p><strong>Preguntas y estructura de los distintos tipos de encuesta a aplicarse</strong></p>
                    <a class=" btn btn-default" href="${m_preg}"><span class="glyphicon glyphicon-plus"> Continuar</span></a>
                </div>
            </div>
        </div>

        <div class="cuadro_intro_hover item ui-corner-all" style="background-color:#cccccc;">
            <p style="text-align:center;" class="imagen">
                <img src="${resource(dir: 'images', file: 'profesor.png')}" width="100%" height="100%" class="img-responsive" alt=""/>
            </p>
            <div class="caption">
                <div class="blur"></div>
                <div class="caption-text">
                    <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Docente</h3>
                    <p><strong>Registro de personal docente y materias que dicta</strong></p>
                    <a class=" btn btn-default" href="${m_prof}"><span class="glyphicon glyphicon-plus"> Continuar</span></a>
                </div>
            </div>
        </div>

        <div class="cuadro_intro_hover item ui-corner-all" style="background-color:#cccccc;">
            <p style="text-align:center;" class="imagen">
                <img src="${resource(dir: 'images', file: 'estudiante.png')}" width="100%" height="100%" class="img-responsive" alt=""/>
            </p>
            <div class="caption">
                <div class="blur"></div>
                <div class="caption-text">
                    <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Estudiante</h3>
                    <p><strong>Registro de estudiantes y matrícula</strong></p>
                    <a class=" btn btn-default" href="${m_estd}"><span class="glyphicon glyphicon-plus"> Continuar</span></a>
                </div>
            </div>
        </div>

        <div class="cuadro_intro_hover item ui-corner-all" style="background-color:#cccccc;">
            <p style="text-align:center;" class="imagen">
                <img src="${resource(dir: 'images', file: 'datos.png')}" width="100%" height="100%" class="img-responsive" alt=""/>
            </p>
            <div class="caption">
                <div class="blur"></div>
                <div class="caption-text">
                    <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Cargar Datos</h3>
                    <p><strong>Cargar datos desde archivos de hoja de cálculo</strong></p>
                    <a class=" btn btn-default" href="${m_prcs}"><span class="glyphicon glyphicon-plus"> Continuar</span></a>
                </div>
            </div>
        </div>

        <div class="cuadro_intro_hover item ui-corner-all" style="background-color:#cccccc;">
            <p style="text-align:center;" class="imagen" >
                <img src="${resource(dir: 'images', file: 'reportes.png')}" width="100%" height="100%" class="img-responsive" alt=""/>
            </p>
            <div class="caption">
                <div class="blur"></div>
                <div class="caption-text">
                    <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Reportes</h3>
                    <p><strong>Reportes del desempeño académico</strong></p>
                    <a class=" btn btn-default" href="${m_rprt}"><span class="glyphicon glyphicon-plus"> Continuar</span></a>
                </div>
            </div>
        </div>
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
