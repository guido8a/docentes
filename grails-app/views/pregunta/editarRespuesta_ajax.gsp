<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 19/09/16
  Time: 15:30
--%>

<div class="row">
        <div class="col-md-1 negrilla control-label">Respuesta: </div>
        <div class="col-md-5">
            <g:textField name="respuestaEditar_name" value="${respuesta?.respuesta?.descripcion}" class="form-control" readonly="true" />
        </div>

        <div class="col-md-1 negrilla control-label">Código: </div>
        <div class="col-md-1">
            <g:textField name="codigoEditar_name" value="${respuesta?.respuesta?.codigo}" class="form-control" readonly="true"/>
        </div>

        <div class="col-md-1 negrilla control-label">Valoración: </div>
        <div class="col-md-1">
            <g:textField name="valoracionEditar_name" id="valoracionEditar" value="${respuesta?.valor}" class="form-control number" />
        </div>
</div>