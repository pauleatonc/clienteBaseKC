<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "form">
        <!-- Elemento oculto para almacenar la descripción del cliente -->
        <div id="client-description" style="display: none;">${client.description!''}</div>
        
        <form id="kc-register-form" class="space-y-6" action="${url.registrationAction}" method="post">
            <div>
                <label for="firstName" class="block text-sm font-medium text-gray-700">${msg("firstName")}</label>
                <div class="mt-1 relative rounded-md shadow-sm">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </span>
                    <input type="text" id="firstName" class="pl-10 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md" name="firstName" 
                           value="${(register.formData.firstName!'')}" 
                           aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                    />
                </div>
                <#if messagesPerField.existsError('firstName')>
                    <span id="input-error-firstname" class="mt-1 text-sm text-red-600" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div>
                <label for="lastName" class="block text-sm font-medium text-gray-700">${msg("lastName")}</label>
                <div class="mt-1 relative rounded-md shadow-sm">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </span>
                    <input type="text" id="lastName" class="pl-10 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md" name="lastName" 
                           value="${(register.formData.lastName!'')}" 
                           aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                    />
                </div>
                <#if messagesPerField.existsError('lastName')>
                    <span id="input-error-lastname" class="mt-1 text-sm text-red-600" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div>
                <label for="email" class="block text-sm font-medium text-gray-700">${msg("email")}</label>
                <div class="mt-1 relative rounded-md shadow-sm">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                        </svg>
                    </span>
                    <input type="email" id="email" class="pl-10 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md" name="email" 
                           value="${(register.formData.email!'')}" autocomplete="email" 
                           aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                    />
                </div>
                <#if messagesPerField.existsError('email')>
                    <span id="input-error-email" class="mt-1 text-sm text-red-600" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('email'))?no_esc}
                    </span>
                </#if>
            </div>

            <#if !realm.registrationEmailAsUsername>
                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700">${msg("username")}</label>
                    <div class="mt-1 relative rounded-md shadow-sm">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                        </span>
                        <input type="text" id="username" class="pl-10 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md" name="username" 
                               value="${(register.formData.username!'')}" autocomplete="username" 
                               aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                        />
                    </div>
                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="mt-1 text-sm text-red-600" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if passwordRequired??>
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700">${msg("password")}</label>
                    <div class="mt-1 relative rounded-md shadow-sm">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                            </svg>
                        </span>
                        <input type="password" id="password" class="pl-10 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md" name="password" 
                               autocomplete="new-password" 
                               aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                        />
                        <span class="absolute inset-y-0 right-0 flex items-center pr-3 cursor-pointer" id="togglePassword">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </span>
                    </div>
                    <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="mt-1 text-sm text-red-600" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div>
                    <label for="password-confirm" class="block text-sm font-medium text-gray-700">${msg("passwordConfirm")}</label>
                    <div class="mt-1 relative rounded-md shadow-sm">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                            </svg>
                        </span>
                        <input type="password" id="password-confirm" class="pl-10 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md" name="password-confirm" 
                               aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                        />
                        <span class="absolute inset-y-0 right-0 flex items-center pr-3 cursor-pointer" id="togglePasswordConfirm">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </span>
                    </div>
                    <#if messagesPerField.existsError('password-confirm')>
                        <span id="input-error-password-confirm" class="mt-1 text-sm text-red-600" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if recaptchaRequired??>
                <div class="mt-4">
                    <div class="g-recaptcha" data-size="normal" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </#if>

            <div class="mt-6 text-center">
                <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    ${msg("doRegister")}
                </button>
            </div>

            <div class="mt-4 text-center">
                <a href="${url.loginUrl}" class="text-sm font-medium text-blue-600 hover:text-blue-500">
                    ${msg("backToLogin")}
                </a>
            </div>
        </form>
        
        <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle para contraseña
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
            
            // Toggle para confirmación de contraseña
            const togglePasswordConfirm = document.getElementById('togglePasswordConfirm');
            const passwordConfirmInput = document.getElementById('password-confirm');
            
            if (togglePasswordConfirm && passwordConfirmInput) {
                togglePasswordConfirm.addEventListener('click', function() {
                    const type = passwordConfirmInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordConfirmInput.setAttribute('type', type);
                    
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
                
                const params = {};
                const pairs = description.split(';');
                
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
            
            // Si ninguno de los métodos sociales está habilitado, mostrar el formulario de registro
            // De lo contrario, mostrar solo si está específicamente habilitado
            const registerFormEnabled = clientParams['register'] === true || 
                                       (clientParams['microsoft'] !== true && 
                                        clientParams['clave-unica'] !== true && 
                                        clientParams['clave-tributaria'] !== true);
            
            const registerForm = document.getElementById('kc-register-form');
            if (registerForm) {
                registerForm.style.display = registerFormEnabled ? 'block' : 'none';
            }
            
            // Si la descripción del cliente está vacía, mostrar el formulario de registro
            if (!clientDescription.trim() && registerForm) {
                registerForm.style.display = 'block';
            }
        });
        </script>
    </#if>
</@layout.registrationLayout>
