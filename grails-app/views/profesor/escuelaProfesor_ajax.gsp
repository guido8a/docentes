<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 05/09/16
  Time: 13:14
--%>

<g:select name="escuela" id="escuelaId" optionKey="id" optionValue="nombre"
          class="form-control" from="${escuelas}" value="${profesor ? profesor?.escuela?.id : ''}"/>