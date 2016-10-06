
<%@ page import="utilitarios.Auxiliares" %>

<g:if test="${!auxiliaresInstance}">
    <elm:notFound elem="Auxiliares" genero="o" />
</g:if>
<g:else>

    <g:if test="${auxiliaresInstance?.ajusteExagerado}">
        <div class="row">
            <div class="col-md-2 text-info">
                Ajuste Exagerado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="ajusteExagerado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.ajusteModerado}">
        <div class="row">
            <div class="col-md-2 text-info">
                Ajuste Moderado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="ajusteModerado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.cuelloBotella}">
        <div class="row">
            <div class="col-md-2 text-info">
                Cuello Botella
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="cuelloBotella"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.curso}">
        <div class="row">
            <div class="col-md-2 text-info">
                Curso
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="curso"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.dias}">
        <div class="row">
            <div class="col-md-2 text-info">
                Dias
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="dias"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.factorExterno}">
        <div class="row">
            <div class="col-md-2 text-info">
                Factor Externo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="factorExterno"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.fechaCierre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Fecha Cierre
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${auxiliaresInstance?.fechaCierre}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.maximoAutoevaluacion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Maximo Autoevaluacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="maximoAutoevaluacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.maximoDirectivos}">
        <div class="row">
            <div class="col-md-2 text-info">
                Maximo Directivos
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="maximoDirectivos"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.maximoEstudiantes}">
        <div class="row">
            <div class="col-md-2 text-info">
                Maximo Estudiantes
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="maximoEstudiantes"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.maximoPares}">
        <div class="row">
            <div class="col-md-2 text-info">
                Maximo Pares
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="maximoPares"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.maximoProfesores}">
        <div class="row">
            <div class="col-md-2 text-info">
                Maximo Profesores
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="maximoProfesores"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.minimo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Minimo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="minimo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.numeroRondas}">
        <div class="row">
            <div class="col-md-2 text-info">
                Numero Rondas
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="numeroRondas"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.optimo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Optimo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="optimo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.paralelo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Paralelo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="paralelo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.password}">
        <div class="row">
            <div class="col-md-2 text-info">
                Password
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliaresInstance}" field="password"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${auxiliaresInstance?.periodo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Periodo
            </div>
            
            <div class="col-md-3">
                ${auxiliaresInstance?.periodo?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>