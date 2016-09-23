<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/09/16
  Time: 13:24
--%>

<div class="row-fluid"  style="width: 99.7%;height: 400px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1050px; height: 400px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${preguntas}" var="pregunta">
                    <tr data-id="${pregunta.id}">
                        <td style="width: 8%">${pregunta?.pregunta?.codigo}</td>
                        <td style="width: 7%">${pregunta?.numero}</td>
                        <td style="width: 55%">${pregunta?.pregunta?.descripcion}</td>
                        <td style="width: 7%">
                            <a href="#" class="btn btn-success btnEditarPregunta" title="Editar el orden de la pregunta" data-id="${pregunta?.id}">
                                <i class="fa fa-pencil"></i>
                            </a>
                            <a href="#" class="btn btn-danger btnBorrarPregunta" title="Borrar la pregunta " data-id="${pregunta?.id}">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(".btnBorrarPregunta").click(function () {
        var idItem = $(this).data("id");
        bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de borrar esta pregunta?", function (result) {
            if (result) {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'prte', action: 'borrarPregunta_ajax')}',
                    data:{
                        id: idItem
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            log("Item borrado correctamente","success");
                            cargarTablaItems();
                        }else{
                            log("Error al borrar el item","error")
                        }
                    }
                });
            }
        });
    });
</script>