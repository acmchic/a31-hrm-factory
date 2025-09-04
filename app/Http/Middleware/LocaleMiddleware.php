<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class LocaleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            // Clean request input to avoid UTF-8 issues
            $input = $request->all();
            if (is_array($input)) {
                array_walk_recursive($input, function(&$value) {
                    if (is_string($value)) {
                        $value = mb_convert_encoding($value, 'UTF-8', 'UTF-8');
                    }
                });
                $request->merge($input);
            }
            
            // Locale is enabled and allowed to be change
            if (session()->has('locale') && in_array(session()->get('locale'), ['ar', 'en'])) {
                app()->setLocale(session()->get('locale'));
            } else {
                app()->setLocale('en');
            }

            return $next($request);
            
        } catch (\Exception $e) {
            // If UTF-8 error occurs, just continue with default locale
            app()->setLocale('en');
            return $next($request);
        }
    }
}