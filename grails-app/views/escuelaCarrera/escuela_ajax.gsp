<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 18/10/18
  Time: 10:04
--%>

<g:select from="${escuelas}" optionValue="nombre"
          optionKey="id" name="escuelaF_name" id="escuelaF" class="form-control required" value="${escuelaCarrera?.escuela?.id}"/>