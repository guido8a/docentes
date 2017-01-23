<util:renderHTML html="${msg}"/>

<style type="text/css">
table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}
</style>

<g:set var="clase" value="${'principal'}"/>

    <div style="overflow-y: auto; height:${msg == '' ? 300 : 275}px; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1060px">
        <g:each in="${bases}" var="dato" status="z">

            <tr id="${dato.id}" data-id="${dato.id}" class="${clase}">
                <td width="340px">
                    ${dato?.profesor}
                </td>

                <td width="400px" style="color:#186063">
                    ${dato?.matedscr}
                </td>

                <td width="160px">
                    ${dato.crsodscr}
                </td>

                <td width="60px" class="text-info">
                    ${dato.dctaprll}
                </td>
                <td width="60px" class="text-info" style="text-align: center">
                    <a href="#" class="btn btn-info btn-xs btnEncuesta" title="Evaluar" data-id="${dato.id}"
                        data-profesor="${dato?.profesor}<br><ul><li>Materia: ${dato.matedscr} </li><li>Curso: ${dato.crsodscr}</li><li>Paralelo: ${dato.dctaprll}</li></ul>">
                        <i class="fa fa-pencil"></i></a>
                </td>
            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">

    $(".btnEncuesta").click(function () {
        var id = $(this).data('id');
        var profesor = $(this).data('profesor');
        var accion = ""
        var titulo = "<span style='font-size: 18px; color:#004166'>Evaluar al profesor<br><br><strong>" + profesor + "<stromng></span>"
        if(${session.par}) {
            accion = "${createLink(action: 'encuestaPR')}"
        } else {
            accion = "${createLink(action: 'encuestaDR')}"
        }

        bootbox.confirm(titulo, function (result) {
            if (result) {
                console.log("llama a ", accion);
                location.href = accion + "?prof__id=" + id
            }
        });
    });

</script>
