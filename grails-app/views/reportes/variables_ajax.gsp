<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 20/01/17
  Time: 11:54
--%>

<div class="row">
    <div class="col-md-2 negrilla control-label">Áreas: </div>
    <div class="col-md-10">
        <g:select from="${variables}" optionValue="descripcion" optionKey="id"  name="variable" id="variableDesem" class="form-control"/>
    </div>
</div>