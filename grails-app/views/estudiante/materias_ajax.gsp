<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/09/16
  Time: 12:51
--%>



    <g:select name="materias_name" id="materiasId" optionKey="id" optionValue="${{it.materia.nombre + ' - Curso: ' + it.curso.nombre + ' - Paralelo: ' + it.paralelo + ' - Profesor: ' + it.profesor.nombre + " " + it.profesor.apellido}}"
              class="form-control" from="${dicta}"/>

%{--<div class="col-md-1 negrilla control-label">Nivel: </div>--}%
%{--<div class="col-md-2">--}%

%{--</div>--}%

%{--<div class="col-md-1 negrilla control-label">Paralelo: </div>--}%
%{--<div class="col-md-1">--}%
    %{--<g:textField name="paralelo_name" id="paraleloId" class="form-control number" maxlength="2"/>--}%
%{--</div>--}%


<script type="text/javascript">




    $("#materiasId").change(function () {

    });


    function cargarDatos () {
        $.ajax({

        });
    }


</script>