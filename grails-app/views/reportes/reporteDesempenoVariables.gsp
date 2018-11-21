
<%@ page import="docentes.Facultad; docentes.Profesor" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Desempeño por Variables</title>


    <rep:estilos orientacion="p" pagTitle="DESEMPEÑO POR VARIABLES"/>


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

    .izquierda {
        text-align : left !important;
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
    <strong style="font-size: 14pt"><util:renderHTML html="${periodo?.universidad?.nombre ?: ''}"/></strong>
</p>


<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Desempeño por Variables"}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Período: ${periodo?.nombre}" ?: ''}"/></strong>
</p>


<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"INTEGRACIÓN DE CONOCIMIENTOS"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad - Carrera</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${data1}" var="d1">
        <tr>
            <td style="width: 30%">${d1.key}</td>
            <td style="width: 30%; text-align: center" >${d1.value}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"DESARROLLO DE ACTITUDES Y VALORES"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad - Carrera</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${data2}" var="d2">
        <tr>
            <td style="width: 30%">${d2.key}</td>
            <td style="width: 30%; text-align: center" >${d2.value}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"DESARROLLO DE HABILIDADES Y DESTREZAS"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad - Carrera</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${data3}" var="d3">
        <tr>
            <td style="width: 30%">${d3.key}</td>
            <td style="width: 30%; text-align: center" >${d3.value}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"INVESTIGACIÓN FORMATIVA"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad - Carrera</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${data4}" var="d4">
        <tr>
            <td style="width: 30%">${d4.key}</td>
            <td style="width: 30%; text-align: center" >${d4.value}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"NORMATIVIDAD INSTITUCIONAL"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad - Carrera</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${data5}" var="d5">
        <tr>
            <td style="width: 30%">${d5.key}</td>
            <td style="width: 30%; text-align: center" >${d5.value}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"EVALUACIÓN DEL APRENDIZAJE"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad - Carrera</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${data6}" var="d6">
        <tr>
            <td style="width: 30%">${d6.key}</td>
            <td style="width: 30%; text-align: center" >${d6.value}</td>
        </tr>
    </g:each>
    </tbody>
</table>

</body>
</html>