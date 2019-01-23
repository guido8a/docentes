<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/09/16
  Time: 15:18
--%>

<g:if test="${materias}">
    <div class="row-fluid"  style="width: 99.7%;height: 300px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 100%; height: 300px;">
                <table class="table table-condensed table-bordered table-striped" style="font-size: 11px">
                    <tbody>
                    <g:each in="${materias}" var="materia">
                        <tr data-id="${materia.id}">
                            <td style="width: 7%">${materia?.materiaDictada?.materia?.codigo}</td>
                            <td style="width: 37%">${materia?.materiaDictada?.materia?.nombre}</td>
                            <td style="width: 6%">${materia?.materiaDictada?.curso?.nombre}</td>
                            <td style="width: 5%">${materia?.materiaDictada?.paralelo}</td>
                            <td style="width: 30%">${materia?.materiaDictada?.profesor?.nombre + ' ' + materia?.materiaDictada?.profesor?.apellido}</td>
                            <td style="width: 18%">${materia?.materiaDictada?.escuela?.nombre}</td>
                            <td style="width: 5%"><a href="#" class="btn btn-danger btnBorrar btn-sm" data-id="${materia.id}"  title="Retirar materia asignada al profesor">
                                <i class="fa fa-trash"></i>
                            </a></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:if>
<g:else>
    <div class="row-fluid"  style="width: 99.7%;height: 200px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 1060px; height: 200px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <tr>
                        <td style="width: 100%"><div class="text-info text-center not-found"><i class="fa-2x pull-center text-shadow">No tiene ninguna materia asignada en este período.</i></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:else>

<script type="text/javascript">
    $(".btnBorrar").click(function () {
        var idM = $(this).data("id");
        bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'>" +
                "</i> Está seguro de retirar esta materia del alumno?", function (result){
                if(result){
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'estudiante', action: 'borrarMateriaMatriculada_ajax')}',
                        data:{
                            id: idM
                        },
                        success: function (msg){
                            if(msg == 'ok'){
                                log("Materia retirada correctamente","success");
                                cargarMatriculados($("#periodoE option:selected").val(),$("#escuelaE option:selected").val());
                            }else{
                                log("Error al retirar la materia","error")
                            }
                        }
                    });
                }
                });
    });

</script>
