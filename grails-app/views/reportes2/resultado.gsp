<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 31/01/19
  Time: 14:45
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Resultados</title>
    <script src="${resource(dir: 'js', file: 'Chart.js')}"></script>
</head>

<body>

<div class="btn-toolbar toolbar">
    <g:link id="btnRegresar" action="porProfesor" class="btn btn-primary"><i class="fa fa-chevron-left"></i> Regresar a Resultados por profesor</g:link>
</div>

<div style="text-align: center; margin-top: 0px">
    <h3>Evaluación de ${profesorP?.nombre + " " + profesorP?.apellido}</h3>
</div>


<div class="chart-container grafico" id="chart-area" style="height: 510px; margin-bottom: 50px">
    <div id="graf" style="margin-left: 80px">
        <canvas id="nuevoGrafico" ></canvas>
    </div>
</div>


%{--<div style="position: absolute; left: 10%; top: 40%; width: 250px;">--}%
    <div id="tabla0" style="margin-left: 5%; margin-top: 20px; width: 100%; border-style: solid; border-width: 1px; border-color: #888">
    <table class="table table-condensed table-bordered table-striped">
        <tbody style="font-size: 12px">
        <g:each in="${vrbl}" var="va" status="j">
                <td style="color: #bf2523">${va.sigla}</td>
                <td>${va.descripcion}</td>
        </g:each>
        </tbody>
    </table>
</div>


<div id="tabla" style="margin-left: 5%; margin-top: 20px; width: 100%; border-style: solid; border-width: 1px; border-color: #888">

    <h3 style="color: #3f71ba; text-align: center">Cuellos de Botella</h3>

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>
        <tr>
            <th class="centrado" rowspan="2" style="width: 20%">Asignatura</th>
            <th class="centrado" rowspan="2" style="width: 8%">Paralelo</th>
            <th class="centrado" rowspan="2" style="width: 16%">Tipo</th>
            <th class="centrado" rowspan="2" style="width: 46%">Causa</th>
            <th class="centrado" rowspan="2" style="width: 10%">Frecuencias</th>
        </tr>
        </thead>

        <tbody>
        <g:each in="${cuellos}" var="cuello">
            <tr style="font-size: 12px">
                <td>${cuello?.mate}</td>
                <td>${cuello?.prll}</td>
                <td>${cuello?.tipo}</td>
                <td>${cuello?.causa}</td>
                <td>${cuello?.frec}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>



<div id="tabla2" style="margin-left: 5%; margin-top: 10px; width: 100%; border-style: solid; border-width: 1px; border-color: #888">

   <h3 style="color: #3f71ba; text-align: center">Potenciadores de Nivel</h3>

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>
        <tr>
            <th class="centrado" rowspan="2" style="width: 20%">Asignatura</th>
            <th class="centrado" rowspan="2" style="width: 8%">Paralelo</th>
            <th class="centrado" rowspan="2" style="width: 16%">Tipo</th>
            <th class="centrado" rowspan="2" style="width: 46%">Causa</th>
            <th class="centrado" rowspan="2" style="width: 10%">Frecuencias</th>
        </tr>
        </thead>

        <tbody>
        <g:each in="${potenciadores}" var="potenciador">
            <tr style="font-size: 12px">
                <td>${potenciador?.mate}</td>
                <td>${potenciador?.prll}</td>
                <td>${potenciador?.tipo}</td>
                <td>${potenciador?.causa}</td>
                <td>${potenciador?.frec}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div id="tabla3" style="margin-left: 5%; margin-top: 10px; width: 100%; border-style: solid; border-width: 1px; border-color: #888">

    <h3 style="color: #3f71ba; text-align: center">Factores de Éxito</h3>

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>
        <tr>
            <th class="centrado" rowspan="2" style="width: 20%">Asignatura</th>
            <th class="centrado" rowspan="2" style="width: 8%">Paralelo</th>
            %{--<th class="centrado" rowspan="2" style="width: 14%">Tipo</th>--}%
            <th class="centrado" rowspan="2" style="width: 62%">Causa</th>
            <th class="centrado" rowspan="2" style="width: 10%">Frecuencias</th>
        </tr>
        </thead>

        <tbody>
        <g:each in="${factores}" var="factor">
            <tr style="font-size: 12px">
                <td>${factor?.mate}</td>
                <td>${factor?.prll}</td>
                %{--<td>${factor?.tipo}</td>--}%
                <td>${factor?.causa}</td>
                <td>${factor?.frec}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div id="tabla4" style="margin-left: 5%; margin-top: 10px; width: 100%; border-style: solid; border-width: 1px; border-color: #888">

    <h3 style="color: #3f71ba; text-align: center">Recomendaciones</h3>

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
        <thead>
        <tr>
            <th class="centrado" rowspan="2" style="width: 90%">Descripción</th>
            <th class="centrado" rowspan="2" style="width: 10%">Grado</th>
        </tr>
        </thead>

        <tbody>
        <g:each in="${recomendaciones}" var="recomendacion">
            <tr style="font-size: 12px">
                <td>${recomendacion?.rcmndscr}</td>
                <td>${recomendacion?.ref}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div style="height: 10px">

</div>

<script type="text/javascript">


    graficar($("#nuevoGrafico"), "${prof[0]}", "${prof[1]}", ${minimo}, ${optimo}, true);
    var myChart;

    function graficar(area, serie1, serie2, vlmn, vlop, etqt) {
        var canvas = area;

        var data1 = serie1.split("_");
        var data2 = serie2.split("_");
        var vl = parseInt(vlmn);
        var op = parseInt(vlop);
        var minimo = [vl, vl, vl, vl, vl, vl];
        var optimo = [op, op, op, op, op, op];
        var chartData = {
            type: 'radar',
            data: {
                labels: ['IC', 'DAC', 'DHA', 'IF', 'NI', 'EA'],
                datasets: [
                    {
                        label: ["Autoevaluación"],
                        fill: true,
                        backgroundColor: "rgba(80,140,198,0.2)",
                        borderColor: "rgba(60,120,198,1)",
                        pointBorderColor: "#fff",
                        pointBackgroundColor: "rgba(179,181,198,1)",
                        data: data2,
                        borderDash: [12,6]
                    },
                    {
                        label: ["Heteroevaluación"],
                        backgroundColor: "rgba(255,99,132,0.2)",
                        borderColor: "rgba(255,99,132,1)",
                        pointBorderColor: "#fff",
                        pointBackgroundColor: "rgba(255,99,132,1)",
                        data: data1
                    },
                    {   label: ["Mínimo"],
                        backgroundColor: "rgba(255,240,240,0.2)",
                        borderColor: "rgba(200,40,40, 0.3)",
                        borderWidth: 2,
                        data: minimo},
                    {   label: ["Óptimo"],
                        backgroundColor: "rgba(240,240,255,0.2)",
                        borderColor: "rgba(0,0,200, 0.2)",
                        borderWidth: 2,
                        data: optimo}
                ]

            },
            options: {
                legend: {
                    display: etqt,
                    labels: {
                        fontColor: 'rgb(20, 80, 100)',
                        fontSize: 14
                    }
                },
                scale: {
                    ticks: {
                        beginAtZero: true,
                        min: 0,
                        max: 100,
                        stepSize: 20
                    },
                    pointLabels: {
                        fontColor: 'rgb(20, 80, 160)',
                        fontSize: 12
                    }
                }

            }
        };

        myChart = new Chart(canvas, chartData, 1)
    }

</script>



</body>

</html>