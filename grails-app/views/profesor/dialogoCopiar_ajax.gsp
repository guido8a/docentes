<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 12/09/16
  Time: 11:55
--%>


<div class="row">
    <div class="col-md-10">
        Materias a asignar desde el período <strong>${copiar?.nombre}</strong> hacia el período <strong>${actual?.nombre}</strong>
    </div>
</div>

<div class="row">
    <div class="col-md-10">
        <ul>
            <g:each in="${materias}" var="materia">
                <li>${materia.materia.nombre}</li>
            </g:each>
        </ul>
    </div>
</div>