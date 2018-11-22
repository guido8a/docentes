<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 25/09/18
  Time: 11:46
--%>

<g:select from="${facultades}" optionValue="nombre"
          optionKey="id" name="facultad_name" id="facultad" class="form-control"/>

<script type="text/javascript">

    $("#facultad").change(function () {
        var facultad = $("#facultad option:selected").val();
        if(${tipo == '1'}){
            cargarGraficoVariables("tpenBarras", $("#facultad option:selected").val());
        }else{
            cargarGraficoEncuesta("tpenBarras",  $("#facultad option:selected").val())
        }

    });

    if(${tipo == '1'}){
        cargarGraficoVariables("tpenBarras", $("#facultad option:selected").val());
    }else{
        cargarGraficoEncuesta("tpenBarras",  $("#facultad option:selected").val())
    }

</script>