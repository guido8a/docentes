<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/09/18
  Time: 14:46
--%>
<div class="modal-contenido" style="height: 70px">

    <div class="col-md-5 control-label text-info">
        <label>Fecha de Inicio de Evaluaciones</label>

        <elm:datepicker name="fechaInicio_name" id="fechaInicio" class="datepicker form-control " value="${auxiliar?.fechaInicio}" />
    </div>
    <div class="col-md-5 control-label text-info">
        <label>Fecha de Cierre de Evaluaciones</label>

        <elm:datepicker name="fechaFin_name" id="fechaFin" class="datepicker form-control " value="${auxiliar?.fechaCierre}" />
    </div>

</div>





