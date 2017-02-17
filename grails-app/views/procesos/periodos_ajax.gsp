<div class="row">
    <div class="col-md-4"></div>
    <div class="col-md-4" style="margin-top: 10px;">
        Seleccione el periodo:
    </div>

    <div class="col-md-4">
        <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
              class="form-control" from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
    </div>
</div>
