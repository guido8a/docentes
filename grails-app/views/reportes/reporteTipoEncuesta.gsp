<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/10/18
  Time: 9:53
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

<%@ page import="docentes.Facultad; docentes.Profesor" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Desempeño por Tipo de Encuesta</title>


    <rep:estilos orientacion="p" pagTitle="DESEMPEÑO POR TIPO DE ENCUESTA"/>


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
    <strong style="font-size: 14pt"><util:renderHTML html="${"Desempeño por Tipo de Encuesta"}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Período: ${periodo?.nombre}" ?: ''}"/></strong>
</p>


<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Autoevaluación Docentes"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${datos1}" var="d1">
        <tr>
            <td style="width: 30%">${docentes.Facultad.get(d1.value).nombre}</td>
            <td style="width: 30%" >${d1.key}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Evaluación del Desempeño Docente"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${datos2}" var="d2">
        <tr>
            <td style="width: 30%">${docentes.Facultad.get(d2.value).nombre}</td>
            <td style="width: 30%" >${d2.key}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Evaluación Directivo a Docente"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${datos3}" var="d3">
        <tr>
            <td style="width: 30%">${docentes.Facultad.get(d3.value).nombre}</td>
            <td style="width: 30%" >${d3.key}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<p class="izquierda">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Evaluación de Pares"}"/></strong>
</p>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>

    <tr>
        <th class="back" rowspan="2" style="width: 80%">Facultad</th>
        <th class="back" rowspan="2" style="width: 20%">Promedio</th>
    </tr>

    </thead>
    <tbody>
    <g:each in="${datos4}" var="d4">
        <tr>
            <td style="width: 30%">${docentes.Facultad.get(d4.value).nombre}</td>
            <td style="width: 30%" >${d4.key}</td>
        </tr>
    </g:each>
    </tbody>
</table>

</body>
</html>