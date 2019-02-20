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
                        <td style="width: 14%">${p?.prof}</td>
                        <td style="width: 20%">${p?.proftitl}</td>
                        <td style="width: 15%">${p?.matedscr}</td>
                        <td style="width: 3%; text-align: center">${p?.clse}</td>
                        <td style="width: 5%;">${p?.crso}</td>
                        <td style="width: 7%; text-align: right">${p?.auto}</td>
                        <td style="width: 8%; text-align: right">${p?.almn}</td>
                        <td style="width: 7%; text-align: right">${p?.ccbb}</td>
                        <td style="width: 7%; text-align: right">${p?.potn}</td>
                        <td style="width: 7%; text-align: right">${p?.fcex}</td>
                        <td style="width: 6%; text-align: center">
                            <button class="btn ${p?.rcmn? 'btn-danger' : 'btn-info'} btnProfesor" type="button"
                                    style="margin-top: 10px" data-id="${p.prof__id}" data-esc="${p.escl__id}"
                                    data-dicta="${p?.dcta__id}" title="Detalle de la Evaluación. ${p?.rcmn? 'Tiene Recomendaciones':''}">
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

    $(".btnProfesor").click(function () {
        var profesor = $(this).data("id");
        var escuela = $(this).data("esc");
        var dicta = $(this).data("dicta");
        location.href="${createLink(controller: 'reportes2', action: 'resultado')}?profesor=" + profesor +
                "&escuela=" + escuela + "&periodo=" + '${periodo}' + "&dicta=" + dicta
    });


</script>