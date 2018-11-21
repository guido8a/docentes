<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 25/09/18
  Time: 11:46
--%>

<g:select from="${facultades}" optionValue="nombre"
          optionKey="id" name="facultad_name" id="facultad" class="form-control"/>

<script type="text/javascript">

    $(function () {
        $(document).ready(function () {
            $("#facultad").change();
        });

        $("#facultad").change(function () {
            var facultad = $("#facultad option:selected").val();
            cargarTablaEscuelas(facultad);
            $(".grafFacultad").click();
        });
    });

    cargarTablaEscuelas($("#facultad option:selected").val());

    function cargarTablaEscuelas (facultad) {
        var universidad = ${universidad?.id}
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'escuelaCarrera', action: 'tablaEscuelaCarreras_ajax')}',
            data:{
                facultad: facultad,
                universidad: universidad
            },
            success: function (msg){
                $("#divTablaEscuelas").html(msg)
            }
        });
    }


</script>