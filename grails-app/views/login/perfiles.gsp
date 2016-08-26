<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <link href="${resource(dir: 'bootstrap-3.1.1/css', file: 'bootstrap-theme-spacelab.css')}" rel="stylesheet">

        <meta name="layout" content="login">
        <title>Perfil</title>
    </head>

    <body>
        <div style="text-align: center; width: 100%; margin-left: 35%; margin-top: 20%">
            <elm:flashMessage tipo="${flash.tipo}" icon="${flash.icon}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

            <g:form name="frmLogin" action="savePer" class="form-signin well" role="form" style="width: 300px;">
                <h2 class="text-center">Perfil</h2>
                <g:select name="prfl" class="form-control" from="${perfilesUsr}" optionKey="id" optionValue="perfil"/>
                <div class="divBtn">
                    <a href="#" class="btn btn-primary btn-lg btn-block btn-login" style="width: 140px; margin: auto">
                        <i class="fa fa-lock"></i> Entrar
                    </a>
                </div>
            </g:form>
        </div>
    <div id="cargando" class="text-center hidden">
        <img src="${resource(dir: 'images', file: 'spinner32.gif')}" alt='Cargando...' width="32px" height="32px"/>
    </div>

        <script type="text/javascript">
            var $frm = $("#frmLogin");
            function doLogin() {
                if ($frm.valid()) {
                    $("#cargando").removeClass('hidden');
                    $(".btn-login").replaceWith($("#cargando"));
                    $("#frmLogin").submit();
                }
            }
            $(function () {
                $frm.validate();
                $(".btn-login").click(function () {
                    doLogin();
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