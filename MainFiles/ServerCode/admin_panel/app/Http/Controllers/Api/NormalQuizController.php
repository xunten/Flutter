<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Level;
use App\Models\Question;
use App\Models\QuestioLeaderboard;
use App\Models\Users;
use App\Models\Earnpoint_Setting;
use Illuminate\Http\Request;
use App\Models\Common;
use Validator;
use DB;
use Exception;

class NormalQuizController extends Controller
{
    private $folder_question = "question";
    private $folder_user = "user";
    private $folder_category = "category";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    // Category >> Level >> Question >> Save Report >> Today Leaderboard >> Leaderboard
    public function get_category()
    {
        try {

            $data = Category::latest()->get();
            if ($data) {

                $this->common->imageNameToUrl($data, 'image', $this->folder_category);
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_level(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'category_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $level = Level::orderBy('level_order', 'asc')->get();
            $category = category::latest()->get();
            if (count($level) && count($category)) {

                foreach ($category as $key => $value) {

                    if ($value->id == $request->category_id) {

                        $result = $level;

                        for ($i = 0; $i < count($level); $i++) {

                            $level[$i]->category_id = $value->id;

                            if ($i == 0) {

                                $level[$i]->is_unlock = 1;
                                $lock = $this->common->Level_Is_unlock($request->user_id, $request->category_id, $level[$i]->id);

                                if ($lock && $lock->correct_answers >= $lock->win_question_count) {
                                    if ($i + 1 < count($level)) {
                                        $level[$i]->is_unlock = 1;
                                        $level[$i + 1]->is_unlock = 1;
                                    }
                                } else {
                                    if ($i + 1 < count($level)) {
                                        $level[$i + 1]->is_unlock = 0;
                                    }
                                }
                            } else {

                                $lock = $this->common->Level_Is_unlock($request->user_id, $request->category_id, $level[$i]->id);

                                if ($lock && $lock->correct_answers >= $lock->win_question_count) {
                                    if ($i + 1 < count($level)) {
                                        $level[$i]->is_unlock = 1;
                                        $level[$i + 1]->is_unlock = 1;
                                    }
                                } else {
                                    if ($i + 1 < count($level)) {
                                        $level[$i + 1]->is_unlock = 0;
                                    }
                                }
                            }
                        }
                        break;
                    } else {
                        $result = [];
                    }
                }
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $result);
            } else {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_question_by_level(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'category_id' => 'required|numeric',
                'level_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $level = Level::where('id', $request->level_id)->first();
            $data = Question::inRandomOrder()->where('level_id', $request->level_id)->where('category_id', $request->category_id)->limit($level['total_question'])->get();

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
    public function save_question_report(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'level_id' => 'required|numeric',
                'user_id' => 'required|numeric',
                'category_id' => 'required|numeric',
                'total_question' => 'required|numeric',
                'questions_attended' => 'required|numeric',
                'correct_answers' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $level_id = $request->level_id;
            $user_id = $request->user_id;
            $category_id = $request->category_id;
            $total_questions = $request->total_question;
            $questions_attended = $request->questions_attended;
            $correct_answers = $request->correct_answers;

            $level_info = Level::where('id', $level_id)->first();
            if ($level_info) {
                $one_que_score = $level_info->score / $total_questions;
                $tot_score = $one_que_score * $correct_answers;
            } else {
                return $this->common->API_Response(400,  __('api_msg.level_not_found'));
            }

            $leaderboard = new QuestioLeaderboard();
            $leaderboard->user_id = $user_id;
            $leaderboard->level_id = $level_id;
            $leaderboard->question_level_master_id = 0;
            $leaderboard->category_id = $category_id;
            $leaderboard->total_questions = $total_questions;
            $leaderboard->questions_attended = $questions_attended;
            $leaderboard->correct_answers = $correct_answers;
            $leaderboard->score = $tot_score;

            if ($request->correct_answers >= $level_info->win_question_count) {
                $leaderboard->is_unlock = 1;
            } else {
                $leaderboard->is_unlock = 0;
            }

            if ($leaderboard->save()) {

                $U_score = Users::where('id', $user_id)->first();
                $PassLevelPoint = Earnpoint_Setting::where('type', 1)->first();

                if ($U_score && $leaderboard->is_unlock == 1 && $PassLevelPoint) {

                    // Plus Point & Score in User
                    $U_score->increment('total_score', $tot_score);
                    $U_score->increment('total_points', $PassLevelPoint->value);

                    // Add Earn Transaction
                    $this->common->add_earn_transaction($user_id, 0, 2, $PassLevelPoint->value);
                }

                return $this->common->API_Response(200,  __('api_msg.record_add_successfully'), []);
            } else {
                return $this->common->API_Response(400,  __('api_msg.data_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_today_leaderboard(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'level_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $msg['status'] = 200;
            $msg['message'] = __('api_msg.get_record_successfully');
            $msg['result'] = [];
            $msg['user'] = [];

            // --- Top 10 User ---
            $data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();

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
                    $final[] = $users;
                    $msg['result'] = $final;
                }
            }

            // --- Single User ---
            $single_data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->get();

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
                    $single_final[] = $single_users;
                    $msg['user'] = $single_final;

                    break;
                }
            }

            return $msg;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_leaderboard(Request $request) // Type = today, month, all
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

                    $data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();
                } else {

                    $data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereYear('created_at', date('Y'))->whereMonth('created_at', date('m'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();
                }

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
                        $final[] = $users;
                        $msg['result'] = $final;
                    }
                }

                // --- Single User ---
                if ($type == "today") {

                    $single_data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->get();
                } else {

                    $single_data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
                        $single_final[] = $single_users;
                        $msg['user'] = $single_final;

                        break;
                    }
                }

                return $msg;
            } else {

                // --- Top 10 User ---
                $data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
                        $final[] = $users;
                        $msg['result'] = $final;
                    }
                }

                // --- Single User ---
                $single_data = QuestioLeaderboard::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
