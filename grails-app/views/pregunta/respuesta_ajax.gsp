<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 19/09/16
  Time: 11:21
--%>

<g:select name="respuestaNueva_name"  id="respuestaNueva" optionKey="id" optionValue="descripcion" from="${lista}" class="form-control"/>


<script type="text/javascript">

    cargarCodigo($("#respuestaNueva").val());
    cargarValor($("#respuestaNueva").val());


    $("#respuestaNueva").change(function (msg) {
        var respuesta = $(this).val();
        cargarCodigo(respuesta);
        cargarValor(respuesta);
    });

    function cargarCodigo (resp) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action: 'codigo_ajax')}',
            data:{
                id: resp
            },
            success: function (msg){
                $("#divCodigo").html(msg)
            }
        });
    }

    function cargarValor (resp) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'pregunta', action: 'valoracion_ajax')}',
            data:{
                id: resp
            },
            success: function (msg){
                $("#divValoracion").html(msg)
            }
        });
    }

</script>