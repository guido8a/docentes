
<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}"/>


<div class="row">
    <div class="col-md-3 negrilla control-label">Pregunta: </div>
    <div class="col-md-8">
        <g:textArea name="preguntaDia_name" class="form-control" value="${pregunta?.descripcion}" readonly="true" style="height: 130px; resize: none"/>
    </div>
</div>
<div class="row">
    <div class="col-md-3 negrilla control-label">Recomendación Actual: </div>
    <div class="col-md-8">
        <g:textArea name="recom_name" value="${rcpr ? rcpr?.recomendacion?.descripcion : ''}" class="form-control" readonly="true" style="height: 130px; resize: none;"/>
    </div>
</div>
<div class="row">
    <div class="col-md-3 negrilla control-label">Recomendaciones: </div>
    <div class="col-md-8">
        <g:select from="${docentes.Recomendacion.list().sort{it.descripcion}}" name="recomendacionS_name" id="recomendacionId"
                  optionKey="id" optionValue="descripcion"  class="form-control selectpicker" data-divider="true" value="${rcpr?.recomendacion?.id}" />
    </div>
</div>

<script type="text/javascript">

    $(function () {
        $('.selectpicker').selectpicker({
            width      : "100%",
            limitWidth : true,
            style      : "btn-primary",
            size: 'auto',
            header: 'Seleccione..'
        });
    })

</script>