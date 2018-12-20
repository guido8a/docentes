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
                        <td style="width: 15%">${profesor?.profesor + " " + profesor?.matedscr + " " + profesor?.curso + j}</td>
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

