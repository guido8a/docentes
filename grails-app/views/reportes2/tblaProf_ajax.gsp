<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/17
  Time: 12:49
--%>

<div class="row-fluid" style="width: 99.7%;height: 450px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1060px; height: 450px;">
            <table class="table table-condensed table-bordered">
                <tbody>
                <g:each in="${data}" var="p" status="j">
                    <tr data-id="${p.prof__id}" class="${p?.potn>0? 'potn': ''}" style="font-weight: ${p?.fcex>0? 'bold': ''};
                      background-color: ${p?.ccbb>0? '#ffefef': ''}">
                        <td style="width: 15%">${p?.prof}</td>
                        <td style="width: 20%">${p?.proftitl}</td>
                        <td style="width: 15%">${p?.matedscr}</td>
                        <td style="width: 3%;">${p?.clse}</td>
                        <td style="width: 5%;">${p?.crso}</td>
                        <td style="width: 7%;">${p?.auto}</td>
                        <td style="width: 7%;">${p?.almn}</td>
                        <td style="width: 7%;">${p?.ccbb}</td>
                        <td style="width: 7%;">${p?.potn}</td>
                        <td style="width: 7%;">${p?.fcex}</td>
                        <td style="width: 6%; text-align: center">
                                <button class="btn ${p?.rcmn? 'btn-danger' : 'btn-info'} btnAlumnos" type="button" style="margin-top: 10px"
                                        data-id="${p.prof__id}" data-esc="${p.escl__id}" title="Detalle de la Evaluación. ${p?.rcmn? 'Tiene Recomendaciones':''}">
                                    <i class="fa fa-search-plus"></i>
                                </button>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

/*
    $(".btnIM").click(function () {
        var idProfe = $(this).data('id');
        var nomProfe = $(this).data('nom');
        var perio = ${params.periodo};

        bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de enviar este reporte al profesor " + "<b style='color: rgba(63,113,186,0.9)'>" + nomProfe + "</b>" + "?", function (result) {
            if (result) {
                %{--location.href = "${createLink(controller: 'reportes', action: 'reporteEnviarProfesores')}?profesor=" + idProfe + "&periodo=" + perio--}%

                openLoader("Enviando...");
                $.ajax({
                    type: 'POST',
                    url: "${createLink(controller: 'reportes', action: 'reporteEnviarProfesores')}",
                    data:{
                        profesor: idProfe,
                        periodo: perio
                    },
                    success: function (msg){
                        closeLoader();
                        var parts = msg.split("_");
                        if(parts[0] == 'ok'){
                            log("Email enviado correctamente", "success")
                        }else{
                            log(parts[1], "error")
                        }
                    }
                });



            }
        });
    });
*/




</script>