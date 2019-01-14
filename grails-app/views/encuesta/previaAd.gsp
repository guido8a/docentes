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
        .logotipo{
            max-width: 20%;
        }
    </style>
</head>
<body>
<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div style="text-align: center;">
    %{--Para personalizar: UNACH: universidad1.jpg, UPEC universidad.jpg y en messages_es.properties la universidad--}%
    <div style="text-align: center;">
        %{--Para personalizar: UNACH: universidad1.jpg, UPEC universidad.jpg y en messages_es.properties la universidad--}%
        <div class="contenedor">
            <div><img src="${logo}" class="logotipo"></div>
            %{--<h3 class="logo_tx"><h1 class="entry-title post-title h2 h1-sm" itemprop="name">${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1>--}%
            <h3 class="logo_tx"><h1 class="entry-title post-title h2 h1-sm" itemprop="name">${universidad}</h1>
                %{--<h4>Sistema para uso exclusivo de la esta Universidad</h4>--}%
        </div>
    </div>


%{--
    <div class="contenedor">
    <div><img src="${resource(dir:'images',file:'universidad.jpeg')}" class="logotipo"></div>
    <h3 class="logo_tx"><h1 class="entry-title post-title h2 h1-sm" itemprop="name">${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1>
        <h4>Sistema para uso exclusivo de la esta Universidad</h4>
        </div>
    </div>
--}%

    <div class="bs-component col-sm-12 panel panel-info ">
        <div class="panel-heading" style="height: 50px; width: 100%">
            <div class="col-md-2 col-xs-3" style="margin-top: -5px"><a href="${g.createLink(action: 'inicio')}" class="btn btn-danger" title="Retornar a la pantalla inicial de Evaluaciones">
                <i class="fa fa-arrow-left"></i>
                Cancelar</a>
            </div>
            <div class="disabled col-md-10 col-xs-9 panel-title">Usted se ha identificado como ${session.informante}</div>
        </div>
    </div>


</div>
<div style="text-align: center; width: 98%; margin-left: auto; margin-right: auto">

    <g:if test="${matr}">
        <h3>Autoevaluación del Docente</h3> Elija la asignatura en la cual se desea evaluar y haga clic en el botón Evaluar correspondiente.
        <table class="table table-condensed table-bordered table-striped">
            <thead>
            <tr>
                %{--<th>Profesor</th>--}%
                <th>Materia</th>
                <th>Curso</th>
                <th>Paralelo</th>
                <th>Evaluar</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${matr}" status="i" var="materia">
                <tr>
                    %{--<td style="font-weight: bold">${materia.profesor}-${materia.prof__id}</td>--}%
                    %{--<td>${materia.matedscr} - prof__id:${materia.prof__id}</td>--}%
                    <td>${materia.matedscr}</td>

                    <td>${materia.crsodscr}</td>
                    %{--<td style="text-align: center">${materia.dctaprll}-${materia.dcta__id}</td>--}%
                    <td style="text-align: center">${materia.dctaprll}</td>
                    <td style="text-align: center">
                        <a href="#" class="btn btn-info btn-sm btnEncuesta" title="Evaluar" data-id="${materia?.dcta__id}"
                            data-asignatura="${materia?.matedscr}<br><br>Curso: ${materia.crsodscr}<br>Paralelo: ${materia.dctaprll}"
                            data-prof="${materia?.prof__id}">
                        <i class="fa fa-pencil"></i> Evaluar</a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </g:if>
    <g:else>
%{--
        <g:link action="encuestaFE" class="btn btn-info col-md-6 col-xs-6 center-block" style="float: inherit; margin: auto">
            <i class="fa fa-pencil"></i> Iniciar Evaluación
        </g:link>
--}%
        <div style="text-align: center;">
            <a href="${g.createLink(action: 'inicio')}" class="btn btn-primary" title="Salir de Evaluaciones">
                <img src="${resource(dir:'images',file:'echo1.png')}">
                Usted ha realizado todas las evaluaciones. ¡Muchas gracias!</a>
        </div>
    </g:else>

    <hr style="border-color: #0A246A; size: 2px"/>
    <div class="col-md-12 col-xs-12"> Desarrollado por: TEDEIN SA &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a></div>

</div>

<script type="text/javascript" src="${resource(dir:'js/jquery/js',file:'jquery-1.4.2.min.js')}"></script>
<script type="text/javascript">
    $(".btnEncuesta").click(function () {
        var id = $(this).data('id');
        var profesor = $(this).data('asignatura');
        var prof = $(this).data('prof');
        var titulo = "Autoevaluar su desempeño en la asignatura:"
        var texto  = "<h4>" + profesor + "</h4>"
        bootbox.confirm({
            title: titulo,
            message: texto,
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
               if (result) {
                    location.href = "${createLink(action: 'encuestaAD')}" + "?prof__id=" + prof + "&dcta__id=" + id
                }
            }
        });
    });

</script>


</body>
</html>
