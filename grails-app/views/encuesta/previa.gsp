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
        <div class="logo_tx"><h1>${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1>
        %{--<br>Sistema para uso exclusivo de la esta Universidad</div>--}%

    <p class="bs-component">
        <span class="btn btn-default btn-md btn-block disabled">Usted se ha identificado como ${session.informante}</span>
    </p>

    <g:if test="${matr}">
        <h3>Evaluación al Docente</h3> Elija al docente que desea evaluar y haga clic en el botón Evaluar correspondiente.
        <table class="table table-condensed table-bordered table-striped">
            <thead>
            <tr>
                <th>Profesor</th>
                <th>Materia</th>
                <th>Curso</th>
                <th>Paralelo</th>
                <th>Evaluar</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${matr}" status="i" var="materia">
                <tr>
                    <td style="font-weight: bold">${materia.profesor}-${materia.prof__id}</td>
                    <td>${materia.matedscr}</td>

                    <td>${materia.crsodscr}</td>
                    <td style="text-align: center">${materia.dctaprll}-${materia.dcta__id}</td>
                    <td style="text-align: center">
                        <a href="#" class="btn btn-info btn-sm btnEncuesta" title="Evaluar" data-id="${materia?.dcta__id}"
                            data-profesor="${materia?.profesor}" data-prof="${materia?.prof__id}">
                        <i class="fa fa-pencil"></i> Evaluar</a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </g:if>
    <g:else>
        <g:link action="encuestaFE" class="btn btn-info">
            <i class="fa fa-pencil"></i> Iniciar Evaluación
        </g:link>
    </g:else>

    <hr style="border-color: #0A246A; size: 2px"/>
    <div class="pie"> Desarrollado por: TEDEIN SA &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a></div>

</div>

<script type="text/javascript" src="${resource(dir:'js/jquery/js',file:'jquery-1.4.2.min.js')}"></script>
<script type="text/javascript">
    $(".btnEncuesta").click(function () {
        var id = $(this).data('id');
        var profesor = $(this).data('profesor');
        var prof = $(this).data('prof');
        var titulo = "Evbaluar al profesor<br><br><strong>" + profesor + "<stromng>"
        bootbox.confirm(titulo, function (result) {
            if (result) {
                console.log("prof__id", prof, "dcta:", id);
                location.href = "${createLink(action: 'encuestaDC')}" + "?prof__id=" + prof + "&dcta__id=" + id
            }
        });
    });

</script>


</body>
</html>
