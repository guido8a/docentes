<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/10/18
  Time: 10:01
--%>

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

<g:each in="${data}" var="d" status="i">
    <p class="izquierda">
        <strong style="font-size: 14pt"><util:renderHTML html="${Facultad.get(fac[i])?.nombre ?: ''}"/></strong>
    </p>

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>

        <tr>
            <th class="back" rowspan="2" style="width: 80%">Variable</th>
            <th class="back" rowspan="2" style="width: 20%">Valor</th>
        </tr>

        </thead>
        <tbody>

        <g:each in="${d}" var="v">
            <tr>
                <td style="width: 80%">${v.value.vrbl}</td>
                <td style="width: 20%; text-align: center" >${v.value.valor}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:each>
</body>
</html>