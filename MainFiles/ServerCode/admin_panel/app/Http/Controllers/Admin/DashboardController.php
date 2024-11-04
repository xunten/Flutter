<?php

namespace App\Http\Controllers\Admin;

use App;
use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Contest;
use App\Models\Language;
use App\Models\Level;
use App\Models\Question;
use App\Models\Common;
use App\Models\Pratice_Question;
use App\Models\Audio_Question;
use App\Models\Video_Question;
use App\Models\TrueFalse_Question;
use App\Models\Daily_Quiz_Question;
use App\Models\Subscription_Plan;
use App\Models\Transaction;
use App\Models\Users;
use App\Models\Video_Leaderborad;
use App\Models\Page;
use App\Models\Pratice_Leaderborad;
use App\Models\QuestioLeaderboard;
use App\Models\Daily_Quiz_Leaderborad;
use App\Models\Audio_Leaderborad;
use App\Models\TrueFalse_Leaderborad;
use DB;
use URL;
use Exception;

class DashboardController extends Controller
{
    private $folder = "contest";
    private $folder1 = "user";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    public function dashboard()
    {
        try {

            $question = Question::count();
            $pratice_question = Pratice_Question::count();
            $audio_question = Audio_Question::count();
            $video_question = Video_Question::count();
            $true_false_question = TrueFalse_Question::count();
            $daily_quiz_question = Daily_Quiz_Question::count();

            $params['total_user'] = Users::count();
            $params['total_category'] = Category::count();
            $params['total_level'] = level::count();
            $params['total_question'] = $question + $pratice_question + $audio_question + $video_question + $true_false_question + $daily_quiz_question;
            $params['total_earning'] = Transaction::sum('transaction_amount');
            $params['total_this_month_earning'] = Transaction::whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->sum('transaction_amount');
            $params['total_package'] = Subscription_Plan::count();
            $params['total_contest'] = Contest::count();

            // User Statistice
            $user_data = [];
            $user_month = [];
            $d = date('t', mktime(0, 0, 0, date('m'), 1, date('Y')));

            for ($i = 1; $i < 13; $i++) {
                $Sum = Users::whereYear('created_at', date('Y'))->whereMonth('created_at', $i)->count();
                $user_data['sum'][] = (int) $Sum;
            }
            for ($i = 1; $i <= $d; $i++) {

                $Sum = Users::whereYear('created_at', date('Y'))->whereMonth('created_at', date('m'))->whereDay('created_at', $i)->count();
                $user_month['sum'][] = (int) $Sum;
            }
            $params['user_year'] = json_encode($user_data);
            $params['user_month'] = json_encode($user_month);

            // Plan Earning Statistice
            $subscription = Subscription_Plan::get();
            $pack_data = [];
            foreach ($subscription as $row) {

                $sum = array();
                for ($i = 1; $i < 13; $i++) {

                    $Sum = Transaction::where('plan_subscription_id', $row->id)->whereYear('created_at', date('Y'))->whereMonth('created_at', $i)->sum('transaction_amount');
                    $sum[] = (int) $Sum;
                }
                $pack_data['label'][] = $row->name;
                $pack_data['sum'][] = $sum;
            }
            $params['package'] = json_encode($pack_data);

            // Upcomming Contest
            $params['upcomming_contest'] = Contest::select('*')->where('start_date', '>=', date('Y-m-d H:i:s'))->orderBy('start_date', 'asc')->take(1)->get();
            $this->common->imageNameToUrl($params['upcomming_contest'], 'image', $this->folder);

            // Pratice Quiz Top User
            $pratice_quiz = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'))->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->first();
            if ($pratice_quiz != null && isset($pratice_quiz) && $pratice_quiz['users'] != null && isset($pratice_quiz['users'])) {
                $this->common->imageNameToUrl(array($pratice_quiz['users']), 'profile_img', $this->folder1);
            }

            // Normal Quiz Top User
            $normal_quiz = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'))->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->first();
            if ($normal_quiz != null && isset($normal_quiz) && $normal_quiz['users'] != null && isset($normal_quiz['users'])) {
                $this->common->imageNameToUrl(array($normal_quiz['users']), 'profile_img', $this->folder1);
            }

            // Audio Quiz Top User
            $audio_quiz = Audio_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'))->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->first();
            if ($audio_quiz != null && isset($audio_quiz) && $audio_quiz['users'] != null && isset($audio_quiz['users'])) {
                $this->common->imageNameToUrl(array($audio_quiz['users']), 'profile_img', $this->folder1);
            }

            // Video Quiz Top User
            $video_quiz = Video_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'))->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->first();
            if ($video_quiz != null && isset($video_quiz) && $video_quiz['users'] != null && isset($video_quiz['users'])) {
                $this->common->imageNameToUrl(array($video_quiz['users']), 'profile_img', $this->folder1);
            }

            // True/False Quiz Top User
            $true_false_quiz = TrueFalse_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'))->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->first();
            if ($true_false_quiz != null && isset($true_false_quiz) && $true_false_quiz['users'] != null && isset($true_false_quiz['users'])) {
                $this->common->imageNameToUrl(array($true_false_quiz['users']), 'profile_img', $this->folder1);
            }

            // Daily Quiz Top User
            $daily_quiz = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'))->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->first();
            if ($daily_quiz != null && isset($daily_quiz) && $daily_quiz['users'] != null && isset($daily_quiz['users'])) {
                $this->common->imageNameToUrl(array($daily_quiz['users']), 'profile_img', $this->folder1);
            }

            $params['pratice_quiz_top_user'] = $pratice_quiz;
            $params['normal_quiz_top_user'] = $normal_quiz;
            $params['daily_quiz_top_user'] = $daily_quiz;
            $params['true_false_quiz_top_user'] = $true_false_quiz;
            $params['audio_quiz_top_user'] = $audio_quiz;
            $params['video_quiz_top_user'] = $video_quiz;

            return view('admin.dashboard', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function Page()
    {
        try {
            $currentURL = URL::current();

            $link_array = explode('/', $currentURL);
            $page = end($link_array);

            $data = Page::where('id', $page)->first();
            if (isset($data)) {
                return view('page', ['result' => $data]);
            } else {
                return view('errors.404');
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function language($id)
    {
        try {
            Language::where('status', 1)->update(['status' => 0]);

            $language = Language::where('id', $id)->first();
            if (isset($language->id)) {
                $language->status = 1;
                if ($language->save()) {
                    App::setLocale($language->lang_code);
                    session()->put('locale', $language->lang_code);
                    return back()->with('success', __('Label.Language Change Successfully.'));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
