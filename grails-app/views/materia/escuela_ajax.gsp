<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/09/16
  Time: 11:48
--%>

<g:select name="escuela" id="escuelaId" optionKey="id" optionValue="nombre"
          class="form-control" from="${escuelas}"/>


<script type="text/javascript">


        cargarTablaMaterias($("#escuelaId").val());

        function cargarTablaMaterias (escuela) {
            $.ajax({
                type: 'POST',
                url:'${createLink(controller: 'materia', action: 'tablaMaterias_ajax')}',
                data:{
                    id: escuela
                },
                success: function (msg){
                    $("#tablaMaterias").html(msg)
                }
            });
        }

        $("#escuelaId").change(function (){
            var escuela = $("#escuelaId").val();
            cargarTablaMaterias(escuela)
        });


</script>