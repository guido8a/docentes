<div class="row-fluid" style="width: 99.7%;height: 450px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1060px; height: 450px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${prof}" var="profesor" status="j">
                    <g:if test="${j%2 == 0}">
                        <tr data-id="${profesor.id}" data-dicta="${profesor.dcta__id}">
                    </g:if>
                    <g:set var="fila" value="${fila==1? 0 : 1}"/>
                    <td style="width: 15%"><strong>${profesor?.profesor}</strong><br>Asignatura: ${profesor?.matedscr}<br>Curso: ${profesor?.curso}<br>
                        <span style="border-width: medium; border-color:#3C78C6 !important; border-bottom: solid"> Autoevaluación</span>
                        <span style="border-width: medium; border-color:#FF6384 !important; border-bottom: solid"> Heteroevaluación</span>
                        <span style="margin-top: 10px !important">
                            <a href="#" class="btn btn-primary btn-sm btnGrafico" data-id="${profesor.id}" data-dicta="${profesor.dcta__id}" title="ver gráfico" style="margin-top: 10px">
                                <i class="fa fa-print"></i> Ver Gráfico
                            </a>
                        </span>
                    </td>
                    <td style="width: 35%; text-align: center">
                        <div class="chart-container grafico gf" id="chart-area"  data-id="${profesor.id}" data-dicta="${profesor.dcta__id}">
                            <div id="graf">
                                <canvas id="clases_${j}" ></canvas>
                                <script type="text/javascript">
                                    graficar($("#clases_${j}"), "${profesor.dc}", "${profesor.ad}", ${minimo}, ${optimo}, false);
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

<script type="text/javascript">


    $(".gf").click(function (){

        var id = $(this).data('id');
        var dicta = $(this).data('dicta');
        var periodo = $("#periodoId option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'reportes', action: 'grafico_ajax')}",
            data: {
                profesor: id,
                dicta: dicta,
                periodo: periodo,
                escuela: escuela
            },
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgGrafico",
                    title: "Gráfico de Desempeño Académico", /* poner profesor */
                    message: msg,
                    class: "long",
//                    height: "500px !Important",
                buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        }
                    } //buttons
                }) //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    });

    $(".btnGrafico").click(function () {

        var id = $(this).data('id');
        var dicta = $(this).data('dicta');
        var periodo = $("#periodoId option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        location.href = "${createLink(controller: 'reportes', action: 'reportePoligonos')}?profe=" + id + "&periodo=" + periodo + "&escl=" + escuela + "&dicta=" + dicta
    })

</script>


s
