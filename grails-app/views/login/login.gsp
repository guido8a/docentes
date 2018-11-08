<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <link href="${resource(dir: 'bootstrap-3.1.1/css', file: 'bootstrap-theme-spacelab.css')}" rel="stylesheet">

    <meta name="layout" content="login">
    <title>Login</title>

    <style type="text/css">
    .archivo {
        width: 100%;
        float: left;
        margin-top: 30px;
        text-align: center;
    }

    .negrilla{

        height:35px;
        line-height: 35px;
    }

    .rotate{
        -webkit-transform : rotate(-20deg);
        -moz-transform    : rotate(-20deg);
    }
    .mensaje-svt{
        width: 300px;
        height: 30px;
        padding: 3px;
        border: 1px solid #A94442;
        display: none;
        background: #F2DEDE;
        color: #ff1e25;
    }
    .mensaje-svt:before, .mensaje-svt:after{
        position: absolute;
        content: "";
        width: 0px;
        height: 0px;
        border: 1px solid #A94442;
    }
    .mensaje-svt:before{
        left:303px;
        top:6px;
        width: 16px;
        height: 16px;
        background: #F2DEDE;
        -webkit-border-radius: 8px;
        -moz-border-radius: 8px;
        border-radius: 8px;
    }
    .mensaje-svt:after{
        left:322px;
        top:12px;
        width: 12px;
        height: 12px;
        background: #F2DEDE;
        -webkit-border-radius: 6px;
        -moz-border-radius: 6px;
        border-radius: 6px;
    }
    </style>
</head>

<body>

<div style="text-align: center; margin-top: 20px; height: ${(flash.message) ? '650' : '580'}px;" class="well">

    <h1 class="titl" style="font-size: 24px; color: #06a">Ingreso al Sistema</h1>
    <elm:flashMessage tipo="${flash.tipo}" icon="${flash.icon}"
                      clase="${flash.clase}">${flash.message}</elm:flashMessage>

    <div class="dialog ui-corner-all" style="height: 295px;padding: 10px;width: 910px;margin: auto;margin-top: 5px">
        <div>
            <img src="${resource(dir: 'images', file: 'quanto.png')}" style="padding: 40px;"/>
        </div>

        <div style="width: 100%;height: 20px;float: left;margin-top: 30px;text-align: center">
            <a href="#" id="ingresar" class="btn btn-primary btn-sm" style="width: 120px; margin: auto">
                <i class="icon-off"></i>Ingresar</a>
        </div>

        <div class="archivo">
            Para mayor información puede consultar el
            <a href="${createLink(uri: '/quanto.pdf')}"><img
                    src="${resource(dir: 'images', file: 'pdf_pq.png')}"/>descriptivo del sistema</a>

%{--
                <a href="#" id="ingresar" class="badge badge-pill badge-primary" >
                    Ingresar</a>
--}%

    </div>


        <p class="text-info pull-right" style="font-size: 10px; margin-top: 20px">
            Desarrollado por: TEDEIN S.A. Versión ${message(code: 'version', default: '1.1.0x')}
        </p>
    </div>
</div>


<div class="modal fade" id="modal-ingreso" tabindex="-1" role="dialog" aria-labelledby=""
     aria-hidden="true">
    <div class="modal-dialog" id="modalBody" style="width: 380px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Ingreso a Quanto</h4>
            </div>

            <div class="modal-body" style="width: 280px; margin: auto">
                <g:form name="frmLogin" action="validar" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-md-5" for="login">Usuario</label>

                        <div class="controls col-md-5">
                            %{--<input type="text" id="login" placeholder="Usuario">--}%
                            <input name="login" id="login" type="text" class="form-control required"
                                   placeholder="Usuario" required autofocus style="width: 160px;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-5" for="pass">Contraseña</label>

                        <div class="controls col-md-5">
                            %{--<input type="password" id="pass" placeholder="Usuario">--}%
                            <input name="pass" id="pass" type="password" class="form-control required"
                                   placeholder="Contraseña" required style="width: 160px;">
                        </div>
                    </div>

                    <div class="divBtn" style="width: 100%">
                        <a href="#" class="btn btn-primary btn-lg btn-block" id="btn-login"
                           style="width: 140px; margin: auto">
                            <i class="fa fa-lock"></i> Ingresar
                        </a>
                    </div>

                </g:form>
            </div>
        </div>

        <div style=" position: absolute;left: 32px;bottom: 3px;" class=" mensaje-svt ui-corner-all" id="msg-container" >
            <button type="button" class="close" id="close-mensaje">&times;</button>
            <p>
                <i class="fa fa-warning fa-1x pull-left  " style="margin-right: 5px;margin-top: 2px" ></i>
                <span id="msg"></span>
            </p>
        </div>

    </div>
</div>

<div id="cargando" class="text-center hidden">
    <img src="${resource(dir: 'images', file: 'spinner32.gif')}" alt='Cargando...' width="32px" height="32px"/>
</div>



<script type="text/javascript">
    var $frm = $("#frmLogin");
//    function doLogin() {
//        if ($frm.valid()) {
//            $("#cargando").removeClass('hidden');
//            $(".btn-login").replaceWith($("#cargando"));
//            $("#frmLogin").submit();
//        }
//    }




    function doLogin() {
        var band=true
        $("#msg-container").fadeOut();
        if($("#login").val()=="" || $("#pass").val()=="")
            band=false;
        if (band) {

            $("#cargando").removeClass('hidden');
            $(".btn-login").replaceWith($("#cargando"));
            $("#frmLogin").submit();


            %{--$.ajax({--}%
                %{--type    : "POST",--}%
                %{--url     : "${g.createLink(action: 'validar')}",--}%
                %{--data    : $(".frm-login").serialize(),--}%
                %{--success : function (msg) {--}%
                    %{--if(!msg.match("error")){--}%
                        %{--$("#data").html(msg)--}%
                    %{--}else{--}%
                        %{--var parts=msg.split("_")--}%
                        %{--$("#msg").html(parts[1])--}%
                        %{--$("#msg-container").fadeIn("slow")--}%
                    %{--}--}%
                %{--}--}%
            %{--});--}%
        }else{
            $("#msg").html("Ingrese su usuario y contraseña");
            $("#msg-container").fadeIn("slow")
        }
    }




    function doPass() {
        if ($("#frmPass").valid()) {
            $("#btn-pass").replaceWith(spinner);
            $("#frmPass").submit();
        }
    }

    $(function () {

        $("#close-mensaje").click(function(){
            $(this).parent().fadeOut("slow")
        });


        $("#ingresar").click(function () {
            var initModalHeight = $('#modal-ingreso').outerHeight();
            //alto de la ventana de login: 270
            $("#modalBody").css({'margin-top': ($(document).height() / 2 - 135)}, {'margin-left': $(window).width() / 2});
            $("#modal-ingreso").modal('show');

            setTimeout(function () {
                $("#login").focus();
            }, 500);

        });

        $("#btnOlvidoPass").click(function () {
            $("#recuperarPass-dialog").modal("show");
            $("#modal-ingreso").modal("hide");
        });

        $frm.validate();
        $("#btn-login").click(function () {
            doLogin();
        });

        $("#btn-pass").click(function () {
            doPass();
        });

        $("input").keyup(function (ev) {
            if (ev.keyCode == 13) {
                doLogin();
            }
        })
    });


</script>

</body>
</html>