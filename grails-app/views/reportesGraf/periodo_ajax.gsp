<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 25/09/18
  Time: 11:14
--%>

<g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
          class="form-control" style="width: 160px"
          from="${periodos}"/>


<script type="text/javascript">

    revisarPeriodo($("#periodoId option:selected").val());

    function revisarPeriodo (periodo) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'auxiliares', action: 'comprobarParametros_ajax')}",
            data:{
                periodo: periodo
            },
            success: function (msg) {
                if(msg == 'ok'){
                    $(".btnGuardar").removeClass('hidden');
                    $(".btnDefecto").removeClass('hidden')
                }else{
                    $(".btnGuardar").addClass('hidden');
                    $(".btnDefecto").addClass('hidden')
                }
            }
        });
    }

    $("#periodoId").change(function () {
        revisarPeriodo($("#periodoId option:selected").val())
    });
</script>