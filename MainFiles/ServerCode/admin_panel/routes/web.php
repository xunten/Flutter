<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;
use App\Http\Controllers\Auth\AdminController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\LevelController;
use App\Http\Controllers\Admin\ClassificationController;
use App\Http\Controllers\Admin\PageController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\PraticeQuizController;
use App\Http\Controllers\Admin\NormalQuizController;
use App\Http\Controllers\Admin\AudioQuizController;
use App\Http\Controllers\Admin\VideoQuizController;
use App\Http\Controllers\Admin\TrueFalseQuizController;
use App\Http\Controllers\Admin\DailyQuizController;
use App\Http\Controllers\Admin\ContestController;
use App\Http\Controllers\Admin\ContestQuestionController;
use App\Http\Controllers\Admin\WithdrawalController;
use App\Http\Controllers\Admin\NotificationController;
use App\Http\Controllers\Admin\PackageController;
use App\Http\Controllers\Admin\TransactionController;
use App\Http\Controllers\Admin\PaymentController;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\Admin\EarningSettingController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Artisan
Route::get('artisan', function () {

    Artisan::call('config:clear');
    Artisan::call('config:cache');
    Artisan::call('cache:clear');
    Artisan::call('view:clear');
    Artisan::call('route:clear');

    return "<h1>All Config Cache Clear Successfully.</h1>";
});

// Login-Logout
Route::get('login', [AdminController::class, 'getLogin'])->name('adminLogin');
Route::post('login', [AdminController::class, 'postLogin'])->name('adminLoginPost');
Route::get('logout', [AdminController::class, 'logout'])->name('adminLogout');

Route::get('pages/{id}', [DashboardController::class, 'Page'])->name('admin.pages');

Route::group(['middleware' => 'authadmin'], function () {

    Route::get('dashboard', [DashboardController::class, 'dashboard'])->name('dashboard');
    Route::get('language/{id}', [DashboardController::class, 'language'])->name('language');
    Route::resource('category', CategoryController::class)->only(['index']);
    Route::resource('level', LevelController::class)->only(['index']);
    Route::resource('classification', ClassificationController::class)->only(['index']);
    Route::resource('page', PageController::class)->only(['index']);
    Route::resource('user', UserController::class)->only(['index']);
    Route::resource('praticequestion', PraticeQuizController::class)->only(['index']);
    Route::get('praticequestionexport', [PraticeQuizController::class, 'export'])->name('praticequestion_export');
    Route::post('praticequestionimport', [PraticeQuizController::class, 'import'])->name('praticequestion_import');
    Route::get('praticeleaderboard', [PraticeQuizController::class, 'leaderboard'])->name('praticeleaderboard');
    Route::resource('normalquestion', NormalQuizController::class)->only(['index']);
    Route::get('normalquestionexport', [NormalQuizController::class, 'export'])->name('normalquestion_export');
    Route::post('normalquestionimport', [NormalQuizController::class, 'import'])->name('normalquestion_import');
    Route::get('normalleaderboard', [NormalQuizController::class, 'leaderboard'])->name('normalleaderboard');
    Route::resource('audioquestion', AudioQuizController::class)->only(['index']);
    Route::get('audioquestionexport', [AudioQuizController::class, 'export'])->name('audioquestion_export');
    Route::post('audioquestionimport', [AudioQuizController::class, 'import'])->name('audioquestion_import');
    Route::get('audioleaderboard', [AudioQuizController::class, 'leaderboard'])->name('audioleaderboard');
    Route::resource('videoquestion', VideoQuizController::class)->only(['index']);
    Route::get('videoquestionexport', [VideoQuizController::class, 'export'])->name('videoquestion_export');
    Route::post('videoquestionimport', [VideoQuizController::class, 'import'])->name('videoquestion_import');
    Route::get('videoleaderboard', [VideoQuizController::class, 'leaderboard'])->name('videoleaderboard');
    Route::resource('truefalsequestion', TrueFalseQuizController::class)->only(['index']);
    Route::get('truefalsequestionexport', [TrueFalseQuizController::class, 'export'])->name('truefalsequestion_export');
    Route::post('truefalsequestionimport', [TrueFalseQuizController::class, 'import'])->name('truefalsequestion_import');
    Route::get('truefalseleaderboard', [TrueFalseQuizController::class, 'leaderboard'])->name('truefalseleaderboard');
    Route::resource('dailyquizquestion', DailyQuizController::class)->only(['index']);
    Route::get('dailyquizquestionexport', [DailyQuizController::class, 'export'])->name('dailyquizquestion_export');
    Route::post('dailyquizquestionimport', [DailyQuizController::class, 'import'])->name('dailyquizquestion_import');
    Route::get('dailyquizleaderboard', [DailyQuizController::class, 'leaderboard'])->name('dailyquizleaderboard');
    Route::resource('contests', ContestController::class)->only(['index']);
    Route::resource('contestquestion', ContestQuestionController::class)->only(['index']);
    Route::get('contestquestionexport', [ContestQuestionController::class, 'export'])->name('contestquestion_export');
    Route::post('contestquestionimport', [ContestQuestionController::class, 'import'])->name('contestquestion_import');
    Route::resource('withdrawal', WithdrawalController::class)->only(['index', 'show']);
    Route::resource('notification', NotificationController::class)->only(['index']);
    Route::resource('package', PackageController::class)->only(['index']);
    Route::resource('transaction', TransactionController::class)->only(['index']);
    Route::resource('payment', PaymentController::class)->only(['index']);
    Route::get('setting', [SettingController::class, 'index'])->name('setting');
    Route::post('setting/app', [SettingController::class, 'app'])->name('setting.app');
    Route::post('setting/currency', [SettingController::class, 'currency'])->name('setting.currency');
    Route::post('setting/changepassword', [SettingController::class, 'changepassword'])->name('setting.changepassword');
    Route::post('setting/admob/android', [SettingController::class, 'admobAndroid'])->name('setting.admob.android');
    Route::post('setting/admob/ios', [SettingController::class, 'admobIos'])->name('setting.admob.ios');
    Route::post('setting/facebookad/android', [SettingController::class, 'facebookadAndroid'])->name('setting.facebookad.android');
    Route::post('setting/facebookad/ios', [SettingController::class, 'facebookadIos'])->name('setting.facebookad.ios');
    Route::post('setting/sociallink', [SettingController::class, 'SaveSocialLink'])->name('settingSocialLink');
    Route::get('smtp/index', [SettingController::class, 'smtpIndex'])->name('smtp.index');
    Route::post('smtp/save', [SettingController::class, 'smtpSave'])->name('smtp.save');
    Route::get('quizconfiguration', [SettingController::class, 'quizConfiguration'])->name('quizConfiguration');
    Route::post('quizconfiguration/save', [SettingController::class, 'quizConfigurationSave'])->name('quizConfigurationSave');
    Route::get('earningsetting', [EarningSettingController::class, 'index'])->name('earningsetting');
    Route::post('earningsetting/earning', [EarningSettingController::class, 'earningSetting'])->name('earning_settingSave');
    Route::post('earningsetting/setearningpoint', [EarningSettingController::class, 'setEarningPoint'])->name('setearningpoint');
    Route::post('earningsetting/spinwheelpoint', [EarningSettingController::class, 'spinWheelPoint'])->name('spinwheelpoint');
    Route::post('earningsetting/dailyloginpoint', [EarningSettingController::class, 'dailyLoginPoint'])->name('dailyloginpoint');
    Route::post('earningsetting/getfreecongpoint', [EarningSettingController::class, 'getFreeCongPoint'])->name('getfreecongpoint');

    /* Hide One Vs One */
    Route::get('one_to_one/{type?}', 'OneToOneController@index')->name('one_to_one_challenge');
    Route::get('one_to_oneleaderboard/{type?}', 'OneToOneController@leaderboard')->name('one_to_one_leaderboard');

    Route::group(['middleware' => 'checkadmin'], function () {

        Route::resource('category', CategoryController::class)->only(['store', 'update', 'destroy']);
        Route::resource('level', LevelController::class)->only(['store', 'update', 'destroy']);
        Route::resource('classification', ClassificationController::class)->only(['store', 'update', 'destroy']);
        Route::resource('page', PageController::class)->only(['edit', 'update']);
        Route::resource('user', UserController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('praticequestion', PraticeQuizController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('normalquestion', NormalQuizController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('audioquestion', AudioQuizController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('videoquestion', VideoQuizController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('truefalsequestion', TrueFalseQuizController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('dailyquizquestion', DailyQuizController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('contests', ContestController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::get('contest/make_winner/{id}', [ContestController::class, 'make_winner'])->name('contest_makewinner');
        Route::get('contestleaderboard/{id}', [ContestController::class, 'leaderboard'])->name('contestleaderboard');
        Route::resource('contestquestion', ContestQuestionController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('notification', NotificationController::class)->only(['create', 'store', 'destroy']);
        Route::get('notificationsetting', [NotificationController::class, 'setting'])->name('notification_setting');
        Route::post('notificationsetting', [NotificationController::class, 'settingsave'])->name('notification_settingsave');
        Route::resource('package', PackageController::class)->only(['create', 'store', 'edit', 'update', 'destroy']);
        Route::resource('transaction', TransactionController::class)->only(['create', 'store',]);
        Route::any('search_user', [TransactionController::class, 'searchUser'])->name('searchUser');
        Route::resource('payment', PaymentController::class)->only(['edit', 'update']);
    });
});
