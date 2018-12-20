<div class="row-fluid" style="width: 99.7%;height: 450px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1060px; height: 450px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${prof}" var="profesor" status="j">
                    <g:if test="${j%2 == 0}">
                        <tr data-id="${profesor.id}">
                    </g:if>
                        <g:set var="fila" value="${fila==1? 0 : 1}"></g:set>
                        <td style="width: 15%"><strong>${profesor?.profesor}</strong><br>Asignatura: ${profesor?.matedscr}<br>Curso: ${profesor?.curso}<br>
                            <span style="border-width: medium; border-color:#3C78C6 !important; border-bottom: solid"> Autoevaluación</span>
                            <span style="border-width: medium; border-color:#FF6384 !important; border-bottom: solid"> Heteroevaluación</span>
                            <span style="margin-top: 10px !important">
                            <g:link controller="reportes" action="" class="btn btn-primary btn-sm"
                                    title="Ver gráfico" style="margin-top: 10px">
                                <i class="fa fa-chevron-left"></i> Ver Gráfico
                            </g:link>
                            </span>
                        </td>
                        <td style="width: 35%; text-align: center">
                            <div class="chart-container grafico" id="chart-area">
                                <div id="graf">
                                    <canvas id="clases_${j}" ></canvas>
                                    <script type="text/javascript">
                                        graficar($("#clases_${j}"), "${profesor.dc}", "${profesor.ad}");
                                    </script>
                                </div>
                            </div>
                        </td>
                    <g:if test="${j%2 == 1}">
                        </tr>
                    </g:if>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

