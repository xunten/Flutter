<?php

namespace App\Http\Middleware;

use Auth;
use Closure;
use Illuminate\Http\Request;
use App\Models\Admin;
use App;
use Illuminate\Support\Facades\Session;

class AuthApi
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next, $guard = null)
    {   
        if (Auth::guard('api')->guest()) {

            // if ($request->ajax() || $request->wantsJson()) {
            //     return redirect(route('login'));
            // } else { 
            //     return redirect(route('login'));
            // } 
        }
        $response = $next($request);
        return $response;
    }
}
