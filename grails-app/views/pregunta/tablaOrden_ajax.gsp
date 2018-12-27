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
            <g:each in="${preguntas}" var="pregunta" status="j">
                <tr style="width: 100%">
                    <td style="width: 8%">${pregunta?.pregunta?.codigo}</td>
                    <td style="width: 70%">${pregunta?.pregunta?.descripcion}</td>
                    <td style="width: 9%">${pregunta?.numero}</td>
                    <td style="width: 9%">
                        <g:textField name="num_name" id="numero_${j}" maxlength="3" class="form-control validacionNumero" style="width: 100%"/>
                    </td>
                    <td style="width: 4%">
                        <a href="#" class="btn btn-sm btn-success btnGuardarOrden" data-id="${pregunta?.id}" data-r="${j}"><i class="fa fa-save"></i></a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center"><label>No se encontró ninguna pregunta para este tipo de encuesta</label></div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnGuardarOrden").click(function () {
        var re = $(this).data("r");
        var idPregunta = $(this).data('id');
        var numeroNuevo = $("#numero_" + re).val();
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'pregunta', action: 'guardarOrden_ajax')}",
            data:{
                id: idPregunta,
                numero: numeroNuevo
            },
            success: function (msg){
                if(msg == 'ok'){
                    log("Orden cambiado correctamente","success");
                    setTimeout(function () {
                        location.reload(true);
                    }, 1000);
                }else{
                    log("Error al cambiar el orden","error");
                }
            }
        })
    });

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39);
//        ev.keyCode == 110 || ev.keyCode == 190);
    }

    $(".validacionNumero").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function (ev) {
//        return validarNum(ev);
    });
</script>