<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AudioQuizController;
use App\Http\Controllers\Api\Contest_Controller;
use App\Http\Controllers\Api\DailyQuizController;
use App\Http\Controllers\Api\HomeController;
use App\Http\Controllers\Api\NormalQuizController;
use App\Http\Controllers\Api\OneToOneController;
use App\Http\Controllers\Api\PracticeQuizController;
use App\Http\Controllers\Api\TrueFalseQuizController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\VideoQuizController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// ---------------- UserController ----------------
Route::post('registration', [UserController::class, 'registration']);
Route::post('login', [UserController::class, 'login']);
Route::post('profile', [UserController::class, 'profile']);
Route::post('update_profile', [UserController::class, 'update_profile']);

// ---------------- HomeController ----------------
Route::post('general_setting', [HomeController::class, 'genaral_setting']);
Route::post('get_pages', [HomeController::class, 'get_pages']);
Route::post('get_payment_option', [HomeController::class, 'get_payment_option']);
Route::post('get_social_link', [HomeController::class, 'get_social_link']);
Route::post('earn_point', [HomeController::class, 'earn_point']);
Route::post('earn_point_setting', [HomeController::class, 'earn_point_setting']);
Route::post('get_notification', [HomeController::class, 'get_notification']);
Route::post('read_notification', [HomeController::class, 'read_notification']);
Route::post('get_packages', [HomeController::class, 'get_packages']);
Route::post('add_package_transaction', [HomeController::class, 'add_package_transaction']);
Route::post('get_package_transaction', [HomeController::class, 'get_package_transaction']);
Route::post('withdrawal_request', [HomeController::class, 'withdrawal_request']);
Route::post('withdrawal_list', [HomeController::class, 'withdrawal_list']);
Route::post('reward_points', [HomeController::class, 'reward_points']);
Route::post('refer_transaction', [HomeController::class, 'refer_transaction']);
Route::post('get_earn_transaction', [HomeController::class, 'get_earn_transaction']);
Route::post('get_reward_points', [HomeController::class, 'get_reward_points']);
Route::post('get_transaction', [HomeController::class, 'get_transaction']);

// ---------------- Normal Quiz ----------------
Route::post('get_category', [NormalQuizController::class, 'get_category']);
Route::post('get_level', [NormalQuizController::class, 'get_level']);
Route::post('get_question_by_level', [NormalQuizController::class, 'get_question_by_level']);
Route::post('save_question_report', [NormalQuizController::class, 'save_question_report']);
Route::post('get_today_leaderboard', [NormalQuizController::class, 'get_today_leaderboard']);
Route::post('get_leaderboard', [NormalQuizController::class, 'get_leaderboard']);

// ---------------- Practice Quiz ----------------
Route::post('get_levelmaster', [PracticeQuizController::class, 'get_levelmaster']);
Route::post('get_category_by_levelmaster', [PracticeQuizController::class, 'get_category_by_levelmaster']);
Route::post('get_lavel_by_category', [PracticeQuizController::class, 'get_lavel_by_category']);
Route::post('get_practice_question_by_level', [PracticeQuizController::class, 'get_practice_question_by_level']);
Route::post('save_practice_question_report', [PracticeQuizController::class, 'save_practice_question_report']);
Route::post('get_practice_leaderboard', [PracticeQuizController::class, 'get_practice_leaderboard']);

// ---------------- Contest ----------------
Route::post('get_contest', [Contest_Controller::class, 'get_contest']);
Route::post('join_contest', [Contest_Controller::class, 'join_contest']);
Route::post('upcoming_contest', [Contest_Controller::class, 'upcoming_contest']);
Route::post('get_question_by_contest', [Contest_Controller::class, 'get_question_by_contest']);
Route::post('save_contest_question_report', [Contest_Controller::class, 'save_contest_question_report']);
Route::post('get_contest_leaderboard', [Contest_Controller::class, 'get_contest_leaderboard']);
Route::post('get_review_question_by_contest_id', [Contest_Controller::class, 'get_review_question_by_contest_id']);
Route::post('get_winner_by_contest', [Contest_Controller::class, 'get_winner_by_contest']);

// ---------------- Audio Quiz ----------------
Route::post('get_audio_question_by_category', [AudioQuizController::class, 'get_audio_question_by_category']);
Route::post('save_audio_question_report', [AudioQuizController::class, 'save_audio_question_report']);
Route::post('get_audio_leaderboard', [AudioQuizController::class, 'get_audio_leaderboard']);

// ---------------- Video Quiz ----------------
Route::post('get_video_question_by_category', [VideoQuizController::class, 'get_video_question_by_category']);
Route::post('save_video_question_report', [VideoQuizController::class, 'save_video_question_report']);
Route::post('get_video_leaderboard', [VideoQuizController::class, 'get_video_leaderboard']);

// ---------------- True/False Quiz ----------------
Route::post('get_true_false_question_by_category', [TrueFalseQuizController::class, 'get_true_false_question_by_category']);
Route::post('save_true_false_question_report', [TrueFalseQuizController::class, 'save_true_false_question_report']);
Route::post('get_true_false_leaderboard', [TrueFalseQuizController::class, 'get_true_false_leaderboard']);

// ---------------- Daily Quiz ----------------
Route::post('get_daily_quiz_question', [DailyQuizController::class, 'get_daily_quiz_question']);
Route::post('save_daily_quiz_question_report', [DailyQuizController::class, 'save_daily_quiz_question_report']);
Route::post('get_daily_quiz_leaderboard', [DailyQuizController::class, 'get_daily_quiz_leaderboard']);

// ---------------- OneToOneController ----------------
// Route::post('create_one_to_one_challenge', 'Api\OneToOneController@create_one_to_one_challenge');
// Route::post('join_one_to_one_challenge', 'Api\OneToOneController@join_one_to_one_challenge');
// Route::post('get_question_by_one_to_one_challenge', 'Api\OneToOneController@get_question_by_one_to_one_challenge');
// Route::post('save_one_to_one_challenge_report', 'Api\OneToOneController@save_one_to_one_challenge_report');
// Route::post('get_one_to_one_challenge_leaderboard', 'Api\OneToOneController@get_one_to_one_challenge_leaderboard');
// Route::post('get_one_to_one_challenge_by_user_id', 'Api\OneToOneController@get_one_to_one_challenge_by_user_id');
