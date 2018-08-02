<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/08/18
  Time: 10:30
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 30/07/18
  Time: 12:19
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 30/07/18
  Time: 11:51
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/09/16
  Time: 12:02
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Potenciadores</title>
    <g:if test="${facultad != ''}" >
        <rep:estilos orientacion="p" pagTitle="REPORTE DE DESEMPEÑO"/>
    </g:if>
    <g:else>
        <rep:estilos orientacion="h" pagTitle="REPORTE DE DESEMPEÑO"/>
    </g:else>


    <style type="text/css">
    .table {
        margin-top      : 0.5cm;
        width           : 100%;
        border-collapse : collapse;
    }

    .table, .table td, .table th {
        border : solid 1px #444;
    }

    .table td, .table th {
        padding : 3px;
    }

    .text-right {
        text-align : right;
    }

    h1.break {
        page-break-before : always;
    }

    small {
        font-size : 70%;
        color     : #777;
    }

    .table th {
        background     : #326090;
        color          : #fff;
        text-align     : center;
        text-transform : uppercase;
    }

    .actual {
        background : #c7daed;
    }

    .info {
        background : #6fa9ed;
    }

    .text-right {
        text-align : right !important;
    }

    .text-center {
        text-align : center;
    }

    .alineado {
        text-align: center;
    }

    .roto{
        page-break-after: always;
    }


    </style>

</head>

<body>


<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${"DESEMPEÑO"}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${facultad ?: ''}"/></strong>
</p>


<g:if test="${facultad != ''}">
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>

        <tr>
            <th class="back" rowspan="2" style="width: 40%">Docente</th>
            <th class="back" rowspan="2" style="width: 40%">Materia</th>
            <th class="back" rowspan="2" style="width: 10%">Paralelo</th>
            <th class="back" rowspan="2" style="width: 10%">Clase</th>
        </tr>

        </thead>
        <tbody>
        <g:each in="${res}" var="e" status="j">
            <tr>
                <td style="width: 40%">${e.profnmbr + " " + e.profapll}</td>
                <td style="width: 40%">${e.matedscr}</td>
                <td style="width: 10%" class="alineado">${e.dctaprll}</td>
                <td style="width: 10%" class="alineado">${e.clase}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:if>
<g:else>
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>
        <tr>
            <th class="back" rowspan="2" style="width: 30%">Facultad</th>
            <th class="back" rowspan="2" style="width: 30%">Docente</th>
            <th class="back" rowspan="2" style="width: 26%">Materia</th>
            <th class="back" rowspan="2" style="width: 7%">Paralelo</th>
            <th class="back" rowspan="2" style="width: 7%">Clase</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${res}" var="e" status="j">
            <tr>
                <td style="width: 30%">${ docentes.Profesor.get(e.prof__id).escuela.facultad.nombre}</td>
                <td style="width: 30%">${e.profnmbr + " " + e.profapll}</td>
                <td style="width: 26%">${e.matedscr}</td>
                <td style="width: 7%" class="alineado">${e.dctaprll}</td>
                <td style="width: 7%" class="alineado">${e.clase}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:else>

</body>
</html>