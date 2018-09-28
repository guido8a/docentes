<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/09/18
  Time: 11:17
--%>

    <div class="" style="width: 99.7%;height: 450px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover" width="1070px">
            <tbody>
            <g:each in="${estudiantes}" var="estudiante">
                <tr>
                    <td style="width: 20%">${estudiante?.cedula}</td>
                    <td style="width: 40%">${estudiante?.apellido}</td>
                    <td style="width: 40%">${estudiante?.nombre}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

