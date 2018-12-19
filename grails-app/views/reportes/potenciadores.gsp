<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Potenciadores</title>
    <g:if test="${facultad != ''}" >
        <rep:estilos orientacion="p" pagTitle="REPORTE DE POTENCIADORES"/>
    </g:if>
    <g:else>
        <rep:estilos orientacion="h" pagTitle="REPORTE DE POTENCIADORES"/>
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
    <strong style="font-size: 14pt"><util:renderHTML html="${periodo?.universidad?.nombre ?: ''}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${"Potenciadores"}"/></strong>
</p>

<p class="alineado">
    <strong style="font-size: 14pt"><util:renderHTML html="${facultad ?: ''}"/></strong>
</p>


<g:if test="${facultad != ''}">
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>

        <tr>
            <th class="back" rowspan="2" style="width: 30%">Docente</th>
            <th class="back" rowspan="2" style="width: 30%">Materia</th>
            <th class="back" rowspan="2" style="width: 10%">Paralelo</th>
            <th class="back" rowspan="2" style="width: 30%">Causa</th>
        </tr>

        </thead>
        <tbody>
        <g:each in="${res}" var="e" status="j">
            <tr>
                <td style="width: 30%">${e.profnmbr + " " + e.profapll}</td>
                <td style="width: 30%">${e.matedscr}</td>
                <td style="width: 10%" class="alineado">${e.dctaprll}</td>
                <td style="width: 30%" >${e.cb_causa}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:if>
<g:else>
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>
        <tr>
            <th class="back" rowspan="2" style="width: 25%">Facultad</th>
            <th class="back" rowspan="2" style="width: 25%">Docente</th>
            <th class="back" rowspan="2" style="width: 23%">Materia</th>
            <th class="back" rowspan="2" style="width: 7%">Paralelo</th>
            <th class="back" rowspan="2" style="width: 20%">Causa</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${res}" var="e" status="j">
            <tr>
                <td style="width: 25%">${ docentes.Profesor.get(e.prof__id).escuela.facultad.nombre}</td>
                <td style="width: 25%">${e.profnmbr + " " + e.profapll}</td>
                <td style="width: 23%">${e.matedscr}</td>
                <td style="width: 7%" class="alineado">${e.dctaprll}</td>
                <td style="width: 20%" >${e.cb_causa}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:else>

</body>
</html>