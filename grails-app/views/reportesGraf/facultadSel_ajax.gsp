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
          optionKey="id" name="facultad_name" id="facultad" class="form-control"
          />

%{--<div class="col-md-1" style="margin-top: 10px;">Escuela:</div>--}%

%{--<div class="col-md-2" id="divEscuela">--}%

<script type="text/javascript">

cargarEscuelas($("#facultad option:selected").val());

$("#facultad").change(function () {
var facultad = $("#facultad option:selected").val();
cargarEscuelas(facultad);
});

function cargarEscuelas (facultad) {
            $.ajax({
                type: 'POST',
                url:'${createLink(controller: 'reportesGraf', action: 'escuelas_ajax')}',
                data:{
                    facultad: facultad
                },
                success: function (msg){
                    $("#divEscuela").html(msg)
                }
            });
    }


</script>