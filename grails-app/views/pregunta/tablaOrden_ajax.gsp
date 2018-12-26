<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/12/18
  Time: 15:14
--%>

<div class="" style="width: 100%;height: 450px; overflow-y: auto; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" width="1115px">
        <tbody>
        <g:if test="${preguntas.size() > 0}">
            <g:each in="${preguntas}" var="pregunta">
                <tr style="width: 100%">
                    <td style="width: 8%">${pregunta?.pregunta?.codigo}</td>
                    <td style="width: 70%">${pregunta?.pregunta?.descripcion}</td>
                    <td style="width: 9%">${pregunta?.numero}</td>
                    <td style="width: 9%">
                            <g:textField name="num_name" id="numero" class="form-control number numeroNuevo" style="width: 100%"/>
                    </td>
                    <td style="width: 4%">
                        <a href="#" class="btn btn-sm btn-success btnGuardarOrden" data-id="${pregunta?.id}"><i class="fa fa-save"></i></a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center"><label>No se encontró ninguna pregunta</label></div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnGuardarOrden").click(function () {
        var idPregunta = $(this).data('id');
        var numeroNuevo = $(".numeroNuevo").val();
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'pregunta', action: 'guardarOrden_ajax')}",
            data:{
                id: idPregunta,
                numero: numeroNuevo
            },
            success: function (msg){

            }
        })
    });


</script>