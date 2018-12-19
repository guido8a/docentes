<div class="row-fluid" style="width: 99.7%;height: 450px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1060px; height: 450px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${prof}" var="profesor" status="j">
                    <tr data-id="${profesor.id}">
                        <td style="width: 20%">${profesor?.nombre + " " + profesor?.apellido}</td>
                        <td style="width: 20%">${profesor?.apellido}</td>
                        <td style="width: 5%; font-size: 11px">prll</td>
                        <td style="width: 55%; text-align: center">
                            <div class="chart-container grafico" id="chart-area">
                                <div id="graf">
                                    <canvas id="clases_${j}" style="margin-top: 30px"></canvas>
                                    <script type="text/javascript">
                                        graficar($("#clases_${j}"));
                                    </script>
                                </div>
                            </div>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

