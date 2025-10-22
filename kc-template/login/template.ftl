<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html>
<html class="h-full bg-gray-50">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <link href="${url.resourcesPath}/css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Google reCAPTCHA -->
    <#if recaptchaRequired??>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    </#if>
    
    <style>
        .gobierno-chile-footer {
            position: relative;
            overflow: hidden;
        }
        .gobierno-chile-footer::before {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 140px;
            height: 5px;
            background: linear-gradient(to right, #0032A0 50%, #D52B1E 50%);
        }
    </style>
</head>

<body class="h-full">
    <div class="min-h-full flex flex-col">
        <!-- Header -->
        <header class="bg-white shadow-sm py-4">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex items-center">
                    <div class="flex items-center">
                        <img class="h-20" src="${url.resourcesPath}/img/Logo_Gobierno_de_Chile.png" alt="Logo Gobierno">
                        <span class="ml-3 text-xl font-medium text-gray-900">Gobierno de Chile</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main content -->
        <main class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
            <div class="max-w-md w-full space-y-8">
                <div>
                    <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                        <#nested "header">
                    </h2>
                </div>

                <div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
                    <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                        <div class="mb-4 p-4 rounded-md <#if message.type = 'success'>bg-green-50 text-green-800<#elseif message.type = 'error'>bg-red-50 text-red-800<#else>bg-blue-50 text-blue-800</#if>">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <#if message.type = 'success'>
                                        <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                        </svg>
                                    <#elseif message.type = 'error'>
                                        <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                        </svg>
                                    <#else>
                                        <svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2h-1V9a1 1 0 00-1-1z" clip-rule="evenodd" />
                                        </svg>
                                    </#if>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm">${kcSanitize(message.summary)?no_esc}</p>
                                </div>
                            </div>
                        </div>
                    </#if>

                    <#nested "form">

                    <#if displayInfo>
                        <#nested "info">
                    </#if>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-gray-800 gobierno-chile-footer">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
                <div class="text-center text-gray-300 text-sm">
                    © ${.now?string('yyyy')} Gobierno de Chile. Todos los derechos reservados.
                </div>
            </div>
        </footer>
    </div>
</body>
</html>
</#macro>
