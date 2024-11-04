<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Daily_Quiz_Question;
use App\Models\Daily_Quiz_Leaderborad;
use App\Models\Users;
use Illuminate\Http\Request;
use App\Models\Common;
use Validator;
use DB;
use Exception;

class DailyQuizController extends Controller
{
    private $folder_question = "daily_quiz_question";
    private $folder_user = "user";
    public $common;
    public $config_setting;
    public function __construct()
    {
        $this->common = new Common;
        $this->config_setting = $this->common->get_quiz_configuraction();
    }

    // Question >> Save Report >> Leaderboard
    public function get_daily_quiz_question(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;

            $check = Daily_Quiz_Leaderborad::where('user_id', $user_id)->whereDate('created_at', date('Y-m-d'))->first();
            if (isset($check) && $check != null) {
                return $this->common->API_Response(200,  __('api_msg.you_have_played_today'), []);
            }

            $data = Daily_Quiz_Question::inRandomOrder()->limit($this->config_setting['daily_quiz_question'])->get();
            if ($data) {

                $this->common->imageNameToUrl($data, 'image', $this->folder_question);
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function save_daily_quiz_question_report(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'total_question' => 'required|numeric',
                'questions_attended' => 'required|numeric',
                'correct_answers' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $total_questions = $request->total_question;
            $questions_attended = $request->questions_attended;
            $correct_answers = $request->correct_answers;

            $check = Daily_Quiz_Leaderborad::where('user_id', $user_id)->whereDate('created_at', date('Y-m-d'))->first();
            if (isset($check) && $check != null) {
                return $this->common->API_Response(400,  __('api_msg.you_have_played_today'));
            }

            $leaderboard = new Daily_Quiz_Leaderborad();
            $leaderboard->user_id = $user_id;
            $leaderboard->total_questions = $total_questions;
            $leaderboard->questions_attended = $questions_attended;
            $leaderboard->correct_answers = $correct_answers;

            $percentage = ($correct_answers * 100) / $total_questions;
            $leaderboard->score = $percentage;

            $leaderboard->is_win_point = 0;
            if ($this->config_setting['min_daily_quiz_percentage'] <= $percentage) {
                $leaderboard->is_win_point = 1;
            }

            if ($leaderboard->save()) {

                $U_score = Users::where('id', $user_id)->first();
                if ($U_score && $leaderboard->is_win_point == 1) {

                    // Plus Point & Score in User
                    $U_score->increment('total_points', $this->config_setting['daily_quiz_win_point']);

                    // Add Earn Transaction
                    $this->common->add_earn_transaction($user_id, 0, 6, $this->config_setting['daily_quiz_win_point']);
                }
                return $this->common->API_Response(200,  __('api_msg.record_add_successfully'), []);
            } else {

                return $this->common->API_Response(400,  __('api_msg.data_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_daily_quiz_leaderboard(Request $request) // Type = today, month, all
    {
        try {

            $user_id = 0;
            $type = "";
            if ($request->user_id) {
                $user_id = $request->user_id;
            }
            if ($request->type) {
                $type = $request->type;
            }

            $msg['status'] = 200;
            $msg['message'] = __('api_msg.get_record_successfully');
            $msg['result'] = [];
            $msg['user'] = [];

            if ($type == "today" || $type == "month") {

                // --- Top 10 User ---
                if ($type == 'today') {

                    $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();
                } else {

                    $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereYear('created_at', date('Y'))->whereMonth('created_at', date('m'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();
                }

                for ($i = 0; $i < count($data); $i++) {

                    if ($data[$i]['users'] != null && isset($data[$i]['users']) && $data[$i]) {

                        $this->common->imageNameToUrl(array($data[$i]['users']), 'profile_img', $this->folder_user);

                        $users['rank'] = $data[$i]->rank;
                        $users['user_id'] = $data[$i]->user_id;
                        $users['score'] = $data[$i]->total_score;
                        $users['max_score'] = $data[$i]->total_score;
                        $users['fullname'] = $data[$i]['users']->fullname;
                        $users['profile_img'] = $data[$i]['users']->profile_img;
                        $users['name'] = $data[$i]['users']->username;
                        $users['user_total_score'] = (int) $data[$i]['users']->total_score;
                        $users['user_total_point'] = (int) $data[$i]['users']->total_points;

                        $final[] = $users;
                        $msg['result'] = $final;
                    }
                }

                // --- Single User ---
                if ($type == "today") {

                    $single_data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->get();
                } else {

                    $single_data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereYear('created_at', date('Y'))->whereMonth('created_at', date('m'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->get();
                }

                for ($i = 0; $i < count($single_data); $i++) {

                    if ($single_data[$i]['users'] != null && $request->user_id == $single_data[$i]['users']->id) {

                        $this->common->imageNameToUrl(array($single_data[$i]['users']), 'profile_img', $this->folder_user);

                        $single_users['rank'] = $single_data[$i]->rank;
                        $single_users['user_id'] = $single_data[$i]->user_id;
                        $single_users['score'] = round($single_data[$i]->total_score);
                        $single_users['max_score'] = round($single_data[$i]->total_score);
                        $single_users['fullname'] = $single_data[$i]['users']->fullname;
                        $single_users['profile_img'] = $single_data[$i]['users']->profile_img;
                        $single_users['name'] = $single_data[$i]['users']->username;
                        $single_users['user_total_score'] = (int) $single_data[$i]['users']->total_score;
                        $single_users['user_total_point'] = (int) $single_data[$i]['users']->total_points;
                        $single_final[] = $single_users;
                        $msg['user'] = $single_final;

                        break;
                    }
                }

                return $msg;
            } else {

                // --- Top 10 User ---
                $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                    ->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();

                for ($i = 0; $i < count($data); $i++) {

                    if ($data[$i]['users'] != null && isset($data[$i]['users']) && $data[$i]) {

                        $this->common->imageNameToUrl(array($data[$i]['users']), 'profile_img', $this->folder_user);

                        $users['rank'] = $data[$i]->rank;
                        $users['user_id'] = $data[$i]->user_id;
                        $users['score'] = round($data[$i]->total_score);
                        $users['max_score'] = round($data[$i]->total_score);
                        $users['fullname'] = $data[$i]['users']->fullname;
                        $users['profile_img'] = $data[$i]['users']->profile_img;
                        $users['name'] = $data[$i]['users']->username;
                        $users['user_total_score'] = (int) $data[$i]['users']->total_score;
                        $users['user_total_point'] = (int) $data[$i]['users']->total_points;
                        $final[] = $users;
                        $msg['result'] = $final;
                    }
                }

                // --- Single User ---
                $single_data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                    ->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->get();

                for ($i = 0; $i < count($single_data); $i++) {

                    if ($single_data[$i]['users'] != null && $user_id == $single_data[$i]['users']->id) {

                        $this->common->imageNameToUrl(array($single_data[$i]['users']), 'profile_img', $this->folder_user);

                        $single_users['rank'] = $single_data[$i]->rank;
                        $single_users['user_id'] = $single_data[$i]->user_id;
                        $single_users['score'] = round($single_data[$i]->total_score);
                        $single_users['max_score'] = round($single_data[$i]->total_score);
                        $single_users['fullname'] = $single_data[$i]['users']->fullname;
                        $single_users['profile_img'] = $single_data[$i]['users']->profile_img;
                        $single_users['name'] = $single_data[$i]['users']->username;
                        $single_users['user_total_score'] = (int) $single_data[$i]['users']->total_score;
                        $single_users['user_total_point'] = (int) $single_data[$i]['users']->total_points;
                        $single_final[] = $single_users;
                        $msg['user'] = $single_final;

                        break;
                    }
                }

                return $msg;
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
