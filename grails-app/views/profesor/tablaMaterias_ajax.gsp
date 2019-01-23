<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/09/16
  Time: 11:42
--%>

<g:if test="${materias}">
    <div class="row-fluid"  style="width: 99.7%;height: 300px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 1060px; height: 300px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <g:each in="${materias}" var="materia">
                        <tr data-id="${materia.id}">
                            <td style="width: 8%">${materia?.materia?.codigo}</td>
                            <td style="width: 34%">${materia?.materia?.nombre}</td>
                            <td style="width: 15%">${materia?.curso?.nombre}</td>
                            <td style="width: 8%">${materia?.paralelo}</td>
                            <td style="width: 25%">${materia?.escuela?.nombre}</td>
                            <td style="width: 5%"><a href="#" class="btn btn-danger btnBorrar" data-id="${materia.id}" data-nombre="${materia?.materia?.nombre}"  title="Retirar materia asignada al profesor">
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
        var nom = $(this).data("nombre");

        bootbox.dialog({
            title: "Alerta",
            message: "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>¿Está seguro que desea eliminar la asignación de la materia? Esta acción no se puede deshacer.</p>",
            buttons: {
                cancelar: {
                    label: "Cancelar",
                    className: "btn-primary",
                    callback: function () {
                    }
                },
                eliminar: {
                    label: "<i class='fa fa-trash-o'></i> Eliminar",
                    className: "btn-danger",
                    callback: function () {
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'profesor', action: 'borrarMateria_ajax')}',
                            data:{
                                id: idM
                            },
                            success: function (msg){
                                if(msg == 'ok'){
                                    log("Materia borrada correctamente","success");
                                    cargarTablaMaterias($("#periodo option:selected").val(), $("#universidadId option:selected").val());
                                }else{
                                    log("Error al borrar la materia","error")
                                }
                            }
                        });
                    }
                }
            }
        });




    });

</script>

