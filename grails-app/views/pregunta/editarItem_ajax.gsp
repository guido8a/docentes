<div class="row">
    <div class="col-md-1 negrilla control-label">Descripción: </div>
    <div class="col-md-7">
        <g:textField name="editarDescripcion_name" id="descripcionItemEditar" class="form-control required" maxlength="127" value="${item?.descripcion}"/>
    </div>

    <div class="col-md-1 negrilla control-label">Orden: </div>
    <div class="col-md-1">
        <g:textField name="ordenItem_name" id="ordenItemEditar" class="form-control required number" maxlength="2" value="${item?.orden}"/>
    </div>

    <div class="col-md-1 negrilla control-label">Tipo: </div>
    <div class="col-md-1">
        <g:select name="tipoItem_name" id="tipoItemEditar" class="form-control" from="${['A','B']}" value="${item?.tipo}"/>
    </div>
</div>

