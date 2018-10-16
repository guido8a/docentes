<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 19/09/16
  Time: 10:19
--%>

<g:if test="${valor != ''}">
    <g:textField name="valoracionRespuesta_name" id="valoracionRespuesta" value="${valor}" class="digits validacionNumero form-control" />
</g:if>
<g:else>
    <g:textField name="valoracionRespuesta_name" id="valoracionRespuesta" value="${respuesta?.valor}" class="digits validacionNumero form-control" />
</g:else>


<script type="text/javascript">


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
        ev.keyCode == 37 || ev.keyCode == 39 ||
        ev.keyCode == 110 || ev.keyCode == 190);
    }

    $(".validacionNumero").keydown(function (ev) {
//        return validarNum(ev);
    }).keyup(function (ev) {
        return validarNum(ev);
    });


</script>
