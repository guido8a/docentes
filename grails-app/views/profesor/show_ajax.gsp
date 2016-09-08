
<%@ page import="docentes.Profesor" %>

<g:if test="${!profesorInstance}">
    <elm:notFound elem="Profesor" genero="o" />
</g:if>
<g:else>

    <g:if test="${profesorInstance?.cedula}">
        <div class="row">
            <div class="col-md-2 text-info">
                Cedula
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="cedula"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.apellido}">
        <div class="row">
            <div class="col-md-2 text-info">
                Apellido
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="apellido"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.estado}">
        <div class="row">
            <div class="col-md-2 text-info">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.evaluar}">
        <div class="row">
            <div class="col-md-2 text-info">
                Evaluar
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="evaluar"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.fechaFin}">
        <div class="row">
            <div class="col-md-2 text-info">
                Fecha Fin
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${profesorInstance?.fechaFin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-2 text-info">
                Fecha Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${profesorInstance?.fechaInicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.fechaNacimiento}">
        <div class="row">
            <div class="col-md-2 text-info">
                Fecha Nacimiento
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${profesorInstance?.fechaNacimiento}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.observacion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Observacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="observacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.sexo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Sexo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="sexo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${profesorInstance?.titulo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Titulo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${profesorInstance}" field="titulo"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>