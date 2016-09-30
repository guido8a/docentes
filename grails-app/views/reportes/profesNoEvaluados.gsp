<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/09/16
  Time: 12:02
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Reporte de profesores NO evaluados</title>
    <rep:estilos orientacion="p" pagTitle="REPORTE DE PROFESORES NO EVALUADOS"/>

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
    <strong style="font-size: 14pt"><util:renderHTML html="${titulo}"/></strong>
</p>


<g:each in="${escuelas}" var="e" status="j">

    <p class="alineado">
        <strong style="font-size: 14pt"><util:renderHTML html="${e}"/></strong>
    </p>

    <table class="table table-condensed table-bordered table-striped table-hover roto" style="width: 100%">
        <thead>

        <tr>
            <th class="back" rowspan="2" style="width: 7%">Cédula</th>
            <th class="back" rowspan="2" style="width: 35%">Nombres y Apellidos</th>
            <th class="back" rowspan="2" style="width: 25%">Materia</th>
            <th class="back" rowspan="2" style="width: 10%">Curso</th>
            <th class="back" rowspan="2" style="width: 7%">Paralelo</th>
        </tr>

        </thead>
        <tbody>
        <g:each in="${res}" var="r">
            <g:if test="${e == r.escldscr}">
                <tr>
                    <td style="width: 7%">${r[1]}</td>
                    <td style="width: 35%">${r[2]}</td>
                    <td style="width: 25%">${r[3]}</td>
                    <td style="width: 10%" class="alineado">${r[4]}</td>
                    <td style="width: 7%" class="alineado">${r[5]}</td>
                </tr>
            </g:if>
            <g:else>
                %{--<tr class="roto"></tr>--}%
            </g:else>
        </g:each>
        </tbody>
    </table>
</g:each>







</body>
</html>