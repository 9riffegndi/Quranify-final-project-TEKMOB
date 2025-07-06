// Flutter web bootstrap script
"use strict";

const TIMEOUT_MS = 8000; // Increase timeout to 8 seconds

// Utility function to load script with timeout
async function loadScriptWithTimeout(url, timeout) {
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = url;
    script.defer = true;
    
    const timeoutId = setTimeout(() => {
      reject(new Error(`Loading ${url} took more than ${timeout}ms. Moving on.`));
    }, timeout);
    
    script.onload = () => {
      clearTimeout(timeoutId);
      resolve();
    };
    
    script.onerror = () => {
      clearTimeout(timeoutId);
      reject(new Error(`Failed to load ${url}`));
    };
    
    document.body.appendChild(script);
  });
}

// Main initialization function
async function initFlutterApp() {
  try {
    // Load Flutter JS
    await loadScriptWithTimeout('flutter.js', TIMEOUT_MS);
    
    // Wait for Flutter initialization
    await _flutter.loader.loadEntrypoint({
      serviceWorker: {
        serviceWorkerVersion: window.flutter_service_worker_version || null,
        serviceWorkerUrl: 'flutter_service_worker.js?v=',
      },
      onEntrypointLoaded: async function(engineInitializer) {
        try {
          const appRunner = await engineInitializer.initializeEngine();
          await appRunner.runApp();
        } catch (e) {
          console.error('Error initializing Flutter engine:', e);
        }
      }
    });
  } catch (e) {
    console.warn('Flutter bootstrap error:', e);
    
    // Fallback: try loading flutter.js directly
    const fallbackScript = document.createElement('script');
    fallbackScript.src = 'flutter.js';
    fallbackScript.defer = true;
    document.body.appendChild(fallbackScript);
    
    // Add fallback initialization
    fallbackScript.onload = function() {
      if (window._flutter) {
        window._flutter.loader.loadEntrypoint({
          onEntrypointLoaded: function(engineInitializer) {
            engineInitializer.initializeEngine().then(function(appRunner) {
              appRunner.runApp();
            });
          }
        });
      }
    };
  }
}

// Initialize when document is loaded
if (document.readyState === 'loading') {
  window.addEventListener('DOMContentLoaded', initFlutterApp);
} else {
  initFlutterApp();
}
