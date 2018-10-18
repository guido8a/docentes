<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 18/10/18
  Time: 10:03
--%>

<g:select from="${facultades}" optionValue="nombre"
          optionKey="id" name="facultadF_name" id="facultadF" class="form-control" value="${escuelaCarrera?.escuela?.facultad?.id}"/>

<script type="text/javascript">

    cargarEscuelasF($("#facultadF option:selected").val());

    $("#facultadF").change(function () {
        var facultad = $("#facultadF option:selected").val();
        cargarEscuelasF(facultad);
    });

    function cargarEscuelasF (facultad) {
            $.ajax({
                type: 'POST',
                url:'${createLink(controller: 'escuelaCarrera', action: 'escuela_ajax')}',
                data:{
                    facultad: facultad,
                    xCarr: '${escuelaCarrera?.id}'
                },
                success: function (msg){
                    $("#divEscuelaForm").html(msg)
                }
            });
    }


</script>