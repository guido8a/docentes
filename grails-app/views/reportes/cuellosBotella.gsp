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
    <title>Cuellos de Botella</title>
    <rep:estilos orientacion="p" pagTitle="REPORTE DE CUELLOS DE BOTELLA"/>

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
    <strong style="font-size: 14pt"><util:renderHTML html="${"Cuellos de Botella"}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${facultad ?: 'Todas las Facultades'}"/></strong>
</p>





<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 33%">Nombres y Apellidos</th>
        <th class="back" rowspan="2" style="width: 36%">Materia</th>
        <th class="back" rowspan="2" style="width: 4%">Paralelo</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${res}" var="e" status="j">
        <tr>
            <td style="width: 30%">${e.profnmbr + " " + e.profapll}</td>
            <td style="width: 50%">${e.matedscr}</td>
            <td style="width: 20%" class="alineado">${e.dctaprll}</td>
        </tr>
    </g:each>
    </tbody>
</table>


</body>
</html>