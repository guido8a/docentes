<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/09/16
  Time: 12:18
--%>

<div class="row-fluid"  style="width: 99.7%;height: 350px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 920px; height: 350px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${materias}" var="materia">
                    <tr data-id="${materia.id}">
                        <td style="width: 6%">${materia?.materia?.codigo}</td>
                        <td style="width: 20%">${materia?.materia?.nombre}</td>
                        <td style="width: 11%">${materia?.curso?.nombre}</td>
                        <td style="width: 5%">${materia?.paralelo}</td>
                        <td style="width: 15%">${materia?.profesor?.nombre + " " + materia?.profesor?.apellido}</td>
                        <td style="width: 5%">
                            <a href="#" class="btn btn-success btnAsignarMateria" title="Asignar materia al estudiante" data-id="${materia?.id}">
                                <i class="fa fa-plus"></i>
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

    $(".btnAsignarMateria").click(function () {
        var idMateria = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'estudiante', action: 'asignarMateria_ajax')}',
            data:{
                id: idMateria,
                estudiante: '${estudiante?.id}'
            },
            success: function (msg){
                var parts = msg.split("_");
                if(parts[0] == 'ok'){
                    log(parts[1],"success");
//                    $("#dlgBuscadorMaterias").dialog('close');
                    bootbox.hideAll()
                    cargarMatriculados($("#periodoId").val());
                }else{
                    log(parts[1],"error")
                }
            }
        });
    });
</script>
