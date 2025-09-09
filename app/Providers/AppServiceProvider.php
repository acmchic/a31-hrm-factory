<?php

namespace App\Providers;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Lang;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Only force HTTPS in production with valid certificates
        if ($this->app->environment('production')) {
            URL::forceScheme('https');
        }

        /* preventLazyLoading
         * preventAccessingMissingAttributes
         * preventSilentlyDiscardingAttributes
         * you can enable all of them at once by using the 'Model::shouldBeStrict()'
         */
        // Model::preventAccessingMissingAttributes();
        // Model::preventSilentlyDiscardingAttributes();

        Lang::handleMissingKeysUsing(function (string $key, array $replacements, string $locale) {
            info("Missing translation key [$key] detected.");

            return $key;
        });

        Carbon::setWeekStartsAt(Carbon::SUNDAY);

        Carbon::setWeekendDays([Carbon::FRIDAY, Carbon::SATURDAY]);
    }
}
