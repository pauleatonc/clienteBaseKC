<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        <p style="font-size:24px;">Iniciar sesión con tu cuenta</p>
    <#elseif section = "form">
        <!-- Elemento oculto para almacenar la descripción del cliente -->
        <div id="client-description" style="display: none;">${client.description!''}</div>
        
        <div id="kc-form" style="display: none;">
            <div id="kc-form-wrapper">
                <#if realm.password>
                    <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                        <div class="mb-4">
                            <label for="username" class="block text-sm font-medium text-gray-700 mb-1">${msg("username")}</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                    </svg>
                                </span>
                                <input tabindex="1" id="username" name="username" value="${(login.username!'')}" 
                                       class="pl-10 w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                                       type="text" autofocus autocomplete="off"
                                       aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                />
                            </div>
                            <#if messagesPerField.existsError('username','password')>
                                <span id="input-error" class="text-red-500 text-sm" aria-live="polite">
                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                </span>
                            </#if>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="block text-sm font-medium text-gray-700 mb-1">${msg("password")}</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                                    </svg>
                                </span>
                                <input tabindex="2" id="password" name="password" 
                                       class="pl-10 w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500" 
                                       type="password" autocomplete="off"
                                       aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                />
                                <span class="absolute inset-y-0 right-0 flex items-center pr-3 cursor-pointer" id="togglePassword">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                    </svg>
                                </span>
                            </div>
                        </div>

                        <div class="flex items-center justify-between mb-4">
                            <#if realm.rememberMe && !usernameEditDisabled??>
                                <div class="flex items-center">
                                    <#if login.rememberMe??>
                                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked
                                               class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                    <#else>
                                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox"
                                               class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                    </#if>
                                    <label for="rememberMe" class="ml-2 block text-sm text-gray-700">
                                        ${msg("rememberMe")}
                                    </label>
                                </div>
                            </#if>
                            <#if realm.resetPasswordAllowed>
                                <a tabindex="5" class="text-sm font-medium text-blue-600 hover:text-blue-500" href="${url.loginResetCredentialsUrl}">
                                    ${msg("doForgotPassword")}
                                </a>
                            </#if>
                        </div>
                        
                        <!-- Google reCAPTCHA -->
                        <#if recaptchaRequired??>
                        <div class="mb-4">
                            <div class="g-recaptcha" data-size="normal" data-sitekey="${recaptchaSiteKey}"></div>
                        </div>
                        </#if>

                        <div id="kc-form-buttons" class="mb-4 border-b border-gray-200 pb-4">
                            <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                            <button tabindex="4" name="login" id="kc-login" type="submit" class="w-full py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                ${msg("doLogIn")}
                            </button>
                        </div>
                    </form>
                </#if>
            </div>
            <h4 class="text-center text-gray-600 mb-4">${msg("identity-provider-login-label")}</h4>
        </div>

        <#if realm.password && social.providers??>
            <div id="kc-social-providers" class="mt-6 pt-4">                
                <ul class="space-y-3">
                    <#list social.providers as p>
                        <li>
                            <#if p.displayName?? && p.displayName == 'Microsoft' || p.alias?? && p.alias == 'microsoft'>
                                <a href="${p.loginUrl}" id="social-${p.alias}" class="flex items-center justify-center w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 microsoft">
                                    <span class="mr-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 23 23">
                                            <path fill="#f3f3f3" d="M0 0h23v23H0z"/>
                                            <path fill="#f35325" d="M1 1h10v10H1z"/>
                                            <path fill="#81bc06" d="M12 1h10v10H12z"/>
                                            <path fill="#05a6f0" d="M1 12h10v10H1z"/>
                                            <path fill="#ffba08" d="M12 12h10v10H12z"/>
                                        </svg>
                                    </span>
                                    Microsoft
                                </a>
                            <#elseif p.displayName?? && (p.displayName == 'ClaveUnica' || p.displayName?contains('Clave')) || p.alias?? && (p.alias == 'claveunica' || p.alias?contains('clave-unica'))>
                                <a href="${p.loginUrl}" id="social-${p.alias}" class="flex items-center justify-center w-full px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white clave-unica focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-50">
                                    <span class="mr-2">
                                        <svg id="Capa_1" data-name="Capa 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="21" height="21">
                                            <defs><style>.cls-1{fill:#fff;fill-rule:evenodd;}</style></defs>
                                            <g id="Atoms-_-Icons-_-white-_-24px-_-logo-_-claveunica" data-name="Atoms-/-Icons-/-white-/-24px-/-logo-/-claveunica">
                                                <path id="cl-icons-43" class="cls-1" d="M11.47,14a.65.65,0,0,1-.21-.54.64.64,0,0,1,.29-.5.68.68,0,0,1,.53-.19.73.73,0,0,1,.49.27.75.75,0,0,1-.08,1,.7.7,0,0,1-.53.19.71.71,0,0,1-.49-.27Zm3.8-8.66A9,9,0,0,1,21,13.57a9,9,0,0,1-18,0A8.78,8.78,0,0,1,8.45,5.32c.37-.09.64-.09.82.36a.76.76,0,0,1-.36,1,7.52,7.52,0,1,0,5.82-.09.66.66,0,0,1-.4-.37.64.64,0,0,1,0-.54.62.62,0,0,1,.37-.39A.64.64,0,0,1,15.27,5.32Zm-7.77,8a4.64,4.64,0,0,1,3.75-4.59V2.33A.91.91,0,0,1,12,1.5h3.31a.75.75,0,0,1,.7.75.78.78,0,0,1-.7.75H12.75V8.76a4.5,4.5,0,0,1,3.75,4.58A4.61,4.61,0,0,1,12,18,4.61,4.61,0,0,1,7.5,13.33Zm7.5.09a3.1,3.1,0,0,0-3-3.12,3.12,3.12,0,0,0,0,6.2A3.09,3.09,0,0,0,15,13.42Z"/>
                                            </g>
                                        </svg>
                                    </span>
                                    ClaveÚnica
                                </a>
                            <#elseif p.alias?? && p.alias?contains('clave-tributaria') || p.displayName?? && p.displayName?contains('Tributaria')>
                                <a href="${p.loginUrl}" id="social-${p.alias}" class="flex items-center justify-center w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-white clave-tributaria hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                    <img src="${url.resourcesPath}/img/logo_ct.png" alt="Clave Tributaria" class="h-8" />
                                </a>
                            <#else>
                                <a href="${p.loginUrl}" id="social-${p.alias}" class="flex items-center justify-center w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                    <#if p.iconClasses?has_content>
                                        <i class="${p.iconClasses!} mr-2"></i>
                                    </#if>
                                    ${p.displayName!}
                                </a>
                            </#if>
                        </li>
                    </#list>
                </ul>
            </div>
        </#if>
    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="text-center mt-4">
                <span class="text-sm text-gray-600">${msg("noAccount")}</span>
                <a tabindex="6" class="text-sm font-medium text-blue-600 hover:text-blue-500" href="${url.registrationUrl}">
                    ${msg("doRegister")}
                </a>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Toggle para el campo de contraseña
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    
    if (togglePassword && passwordInput) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            // Cambiar el ícono
            if (type === 'text') {
                this.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                </svg>`;
            } else {
                this.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>`;
            }
        });
    }
    
    // Función para parsear los parámetros de la descripción
    function parseClientDescription(description) {
        if (!description) return {};
        
        const cleanDescription = description.split('auth?')[0].trim();
        
        const params = {};
        const pairs = cleanDescription.split(';');
        
        pairs.forEach(pair => {
            const [key, value] = pair.split('=');
            if (key && value) {
                params[key.trim()] = value.trim().toLowerCase() === 'true';
            }
        });
        
        return params;
    }

    // Obtener la descripción del cliente
    const clientDescription = document.getElementById('client-description').textContent || '';
    const clientParams = parseClientDescription(clientDescription);
    
    // Mostrar el formulario de Keycloak si está habilitado
    const kcForm = document.getElementById('kc-form');
    if (clientParams['keycloak'] === true) {
        if (kcForm) kcForm.style.display = 'block';
    } else if (!clientDescription.trim()) {
        if (kcForm) kcForm.style.display = 'block';
    } else {
        if (kcForm) kcForm.style.display = 'none';
    }

    // Función para aplicar la lógica de visibilidad de los botones
    function applyButtonVisibilityLogic() {
        const socialProvidersContainer = document.getElementById('kc-social-providers');
        if (!socialProvidersContainer) {
            return false; 
        }

        const allSocialButtons = socialProvidersContainer.querySelectorAll('a');

        if (allSocialButtons.length === 0) {
            if (clientDescription.trim()) {
            } else {
            }
            return true; 
        }
        
        allSocialButtons.forEach(btn => {
            const id = btn.id ? btn.id.toLowerCase() : 'no-id'; 
            const classes = btn.className;
            
            btn.style.display = 'none'; 
            
            if (!clientDescription.trim()) {
                btn.style.display = 'flex';
            } else {
                if (classes.includes('microsoft') && clientParams['microsoft'] === true) {
                    btn.style.display = 'flex';
                } else if (classes.includes('clave-unica') && clientParams['claveunica'] === true) {
                    btn.style.display = 'flex';
                } else if (classes.includes('clave-tributaria') && clientParams['clave-tributaria'] === true) {
                    btn.style.display = 'flex';
                } else {
                }
            }
        });
        return true; 
    }

    // Intentar aplicar la lógica directamente por si los botones ya están
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            if (applyButtonVisibilityLogic()) {
            } else {
                setupObserver();
            }
        });
    } else {
        if (applyButtonVisibilityLogic()) {
        } else {
            setupObserver();
        }
    }
    
    function setupObserver() {
        const targetNode = document.getElementById('kc-social-providers');
        if (targetNode) {
            const observer = new MutationObserver(function(mutationsList, obs) {
                if (applyButtonVisibilityLogic()) {
                    obs.disconnect(); 
                } else {
                }
            });
            observer.observe(targetNode, { childList: true, subtree: true, attributes: true });
        } else {
        }
    }
});
</script>
