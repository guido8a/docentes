<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/18
  Time: 11:22
--%>

%{--<div class="row">--}%
    %{--<div class="col-md-2 negrilla control-label">Escuela: </div>--}%
    <div class="col-md-12">
        <g:select from="${escuelas}" optionValue="nombre" optionKey="id"  name="escuela_name" id="escuelaId" class="form-control"/>
    </div>
%{--</div>--}%