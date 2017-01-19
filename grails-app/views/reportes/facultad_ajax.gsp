<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/10/16
  Time: 10:53
--%>

<div class="row">
    <div class="col-md-2 negrilla control-label">Escuela: </div>
    <div class="col-md-10">
        <g:select from="${escuelas}" optionValue="nombre" optionKey="id"  name="escuela" id="escuelaRprt" class="form-control"/>
    </div>
</div>

%{--
<div class="row">
    <div class="col-md-2 negrilla control-label">Período: </div>
    <div class="col-md-6">
        <g:select from="${docentes.Periodo.list()}" optionValue="nombre" optionKey="id"  name="periodo_name" id="periodoReporte" class="form-control"/>
    </div>
</div>--}%
