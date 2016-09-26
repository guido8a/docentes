<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/09/16
  Time: 10:39
--%>


<div class="row">

    <div class="col-md-1 negrilla control-label">Código: </div>
    <div class="col-md-1">
        <g:textField name="codigoPregunta_name" value="${pregunta?.pregunta?.codigo}" class="form-control" readonly="true"/>
    </div>

    <div class="col-md-1 negrilla control-label">Pregunta: </div>
    <div class="col-md-5">
        <g:textField name="descPregunta_name" value="${pregunta?.pregunta?.descripcion}" class="form-control" readonly="true" />
    </div>

    <div class="col-md-1 negrilla control-label">Orden: </div>
    <div class="col-md-1">
        <g:textField name="ordenPregunta_name" id="ordenEditar" value="${pregunta?.numero}" class="form-control number" />
    </div>
</div>