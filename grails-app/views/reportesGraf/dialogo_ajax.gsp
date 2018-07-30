<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 27/07/18
  Time: 10:08
--%>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
    <thead>
    <tr>
        <th class="centrado" rowspan="2">Escuela</th>
        <th class="centrado" rowspan="2">Profesor</th>
        <th class="centrado" rowspan="2">Materia</th>
        <th class="centrado" rowspan="2">Paralelo</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${profesores}" var="profesor">
        <tr>
            <td>${profesor.escldscr}</td>
            <td>${profesor.profnmbr + " " + profesor.profapll}</td>
            <td>${profesor.matedscr}</td>
            <td>${profesor.dctaprll}</td>
        </tr>
    </g:each>
    </tbody>
</table>