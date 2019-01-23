<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 21/01/19
  Time: 14:40
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/18
  Time: 11:13
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 25/09/18
  Time: 11:46
--%>

<g:select from="${facultades}" optionValue="nombre"
          optionKey="id" name="facultad_name" id="facultadE" class="form-control"/>


<script type="text/javascript">

    cargarEscuelas($("#facultadE option:selected").val());

    $("#facultad").change(function () {
        var facultad = $("#facultadE option:selected").val();
        cargarEscuelas(facultad);
    });

    function cargarEscuelas (facultad) {
        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'estudiante', action: 'escuelas_ajax')}',
            async: false,
            data:{
                facultad: facultad
            },
            success: function (msg){
                $("#divEscuela1").html(msg)
            }
        });
    }


</script>