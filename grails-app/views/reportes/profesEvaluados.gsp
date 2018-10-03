<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 24/02/17
  Time: 12:46
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
    <title>Profesores que han sido evaluados por los alumnos</title>
    <rep:estilos orientacion="l" pagTitle="REPORTE DE PROFESORES EVALUADOS POR LOS ALUMNOS"/>

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

    .table tbody tr {
        border : solid 1px #444;
    }

    tbody tr td {
        border : solid 1px #444;
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

    .centrado{
        text-align: center;
    }


    </style>

</head>

<body>


<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${periodo?.universidad?.nombre?.toUpperCase() ?: ''}"/></strong>
</p>


<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${titulo}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${facultad?.nombre}"/></strong>
</p>

<g:set var="escuela"/>



<g:each in="${res}" var="e" status="j">

    <g:if test="${e?.escl != escuela}">
        <p class="alineado">
            <strong style="font-size: 14pt"><util:renderHTML html="${e?.escl}"/></strong>
        </p>

        <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>

        <tr>
            <th class="back" rowspan="2" style="width: 30%">Profesor</th>
            <th class="back" rowspan="2" style="width: 30%">Materia</th>
            <th class="back" rowspan="2" style="width: 15%">Curso - Paralelo</th>
            <th class="back" rowspan="2" style="width: 5%">Matriculados</th>
            <th class="back" rowspan="2" style="width: 5%">Evaluado Parcial</th>
            <th class="back" rowspan="2" style="width: 5%">Evaluado Total</th>
            <th class="back" rowspan="2" style="width: 5%">Porcentaje</th>
        </tr>
        </thead>
        </table>

    </g:if>

        <tbody>

        <tr>
            <td style="width: 277px" >${e?.prof}</td>
            <td style="width: 271px">${e?.mate}</td>
            <td style="width: 137px">${e?.crso} - ${e?.prll}</td>
            <td style="width: 80px" class="centrado">${e?.almn}</td>
            <td style="width: 60px" class="centrado">${e?.semi}</td>
            <td style="width: 55px" class="centrado">${e?.eval}</td>
            <td style="width: 65px" class="centrado">${e?.pcnt} %</td>
        </tr>
        </tbody>

    <g:set var="escuela" value="${e?.escl}"/>

</g:each>

</body>
</html>