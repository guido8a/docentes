<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/09/16
  Time: 12:51
--%>



%{--<g:select name="materias_name" id="materiasId" optionKey="id" optionValue="${{it.materia.nombre + ' - Curso: ' + it.curso.nombre + ' - Paralelo: ' + it.paralelo + ' - Profesor: ' + it.profesor.nombre + " " + it.profesor.apellido}}"--}%
              %{--class="form-control" from="${dicta}"/>--}%

<g:textField name="materias_name" id="materiasId" class="form-control" placeholder="Seleccione la materia..."/>


<script type="text/javascript">




    $("#materiasId").click(function () {

        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'materia', action:'buscarMateria_ajax')}",
            data    : {
                periodo: '${periodo?.id}',
                id: '${estudiante?.id}'
            },
            success : function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgBuscadorMaterias",
                    title   : "Buscar Materia",
                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax

    });




</script>