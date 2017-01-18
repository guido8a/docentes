<div class="row">
    <div class="col-md-2 negrilla control-label">Período: </div>
    <div class="col-md-6">
        <g:select from="${docentes.Periodo.list()}" optionValue="nombre" optionKey="id"  name="periodo_name"
                  id="periodoReporte" class="form-control"/>
    </div>
</div>

