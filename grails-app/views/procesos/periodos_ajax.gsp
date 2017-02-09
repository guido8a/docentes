<%@ page import="docentes.Periodo" contentType="text/html;charset=UTF-8" %>
<div class=" form-control row col-md-12" style="height: auto; margin-bottom: 30px;">
    <h4>Borrar los datos de Materias dictadas y Estudiantes Matriculados</h4>
    <div class="col-md-4"></div>
    <div class="col-md-4" style="margin-top: 10px;">
        Seleccione el periodo:
    </div>

    <div class="col-md-4">
        <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
              class="form-control" from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
    </div>
</div>
