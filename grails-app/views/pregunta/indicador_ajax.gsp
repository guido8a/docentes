<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/10/18
  Time: 12:32
--%>

<g:select name="indicador" id="indicadorId" optionKey="id" optionValue="descripcion"
          class="form-control" from="${indicadores}" value="${preguntaInstance?.indicador?.id}" disabled="${preguntaInstance?.estado == 'R'}"/>
