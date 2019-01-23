<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 09/10/18
  Time: 11:19
--%>

%{--<g:select name="escuela_name" id="escuelaAsig" optionKey="id" optionValue="nombre"--}%
          %{--class="form-control" from="${escuelas}" value="${profesor ? profesor?.escuela?.id : ''}"/>--}%

<g:select name="escuela_name" id="escuelaAsig" optionKey="id" optionValue="nombre"
          class="form-control" from="${escuelas}" value=""/>

<script type="text/javascript">


    $("#escuelaAsig").change(function (msg) {
        var escuela = $("#escuelaAsig option:selected").val();
        cargarComboMaterias(escuela);
    });


    cargarComboMaterias($("#escuelaAsig").val());

    function cargarComboMaterias (escuela) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor',action: 'materias_ajax')}',
            data:{
                escuela: escuela
            },
            success: function (msg){
                $("#divMaterias").html(msg)
            }
        });
    }

</script>