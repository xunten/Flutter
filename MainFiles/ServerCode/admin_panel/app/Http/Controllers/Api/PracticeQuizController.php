<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Level;
use App\Models\Pratice_Leaderborad;
use App\Models\Users;
use App\Models\Classification;
use App\Models\Pratice_Question;
use Illuminate\Http\Request;
use App\Models\Common;
use Validator;
use DB;
use Exception;

class PracticeQuizController extends Controller
{
    private $folder_category = "category";
    private $folder_pratice_question = "pratice_question";
    private $folder_user = "user";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    // Level Master >> Category >> Level >> Question >> Save Report >> Leaderboard
    public function get_levelmaster()
    {
        try {

            $data = Classification::orderby('level_order', 'asc')->get();
            if ($data) {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.no_record'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_category_by_levelmaster(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'question_level_master_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Pratice_Question::select('category_id')->where('question_level_master_id', $request->question_level_master_id)->groupBy('category_id')->with('category')->get();

            $category = [];
            if (count($data)) {
                foreach ($data as $key => $value) {

                    if ($value->category) {
                        $this->common->imageNameToUrl(array($value->category), 'image', $this->folder_category);
                        $category[] = $value->category;
                    }
                }
            }
            return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $category);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_lavel_by_category(Request $request)
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
                            $level[$i]->is_unlock = 0;
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
    public function get_practice_question_by_level(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'category_id' => 'required|numeric',
                'question_level_master_id' => 'required|numeric',
                'level_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $category_id = $request->category_id;
            $question_level_master_id = $request->question_level_master_id;
            $level_id = $request->level_id;

            $level = Level::where('id', $request->level_id)->first();
            $data = Pratice_Question::inRandomOrder()->where('category_id', $category_id)->where('question_level_master_id', $question_level_master_id)->where('level_id', $level_id)->limit($level['total_question'])->get();

            if ($data) {

                $this->common->imageNameToUrl($data, 'image', $this->folder_pratice_question);
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function save_practice_question_report(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'level_id' => 'required|numeric',
                'question_level_master_id' => 'required|numeric',
                'category_id' => 'required|numeric',
                'total_question' => 'required|numeric',
                'question_attended' => 'required|numeric',
                'correct_answers' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $question_level_master_id = $request->question_level_master_id;
            $category_id = $request->category_id;
            $level_id = $request->level_id;
            $questions_attended = $request->question_attended;
            $total_questions = $request->total_question;
            $correct_answers = $request->correct_answers;

            $level_info = Level::where('id', $level_id)->first();
            if ($level_info) {
                $one_que_score = $level_info->score / $total_questions;
                $tot_score = $one_que_score * $correct_answers;
            } else {
                return $this->common->API_Response(400,  __('api_msg.level_not_found'));
            }

            $leaderboard = new Pratice_Leaderborad();
            $leaderboard->user_id = $user_id;
            $leaderboard->level_id = $level_id;
            $leaderboard->question_level_master_id = $question_level_master_id;
            $leaderboard->category_id = $category_id;
            $leaderboard->total_questions = $total_questions;
            $leaderboard->questions_attended = $questions_attended;
            $leaderboard->correct_answers = $correct_answers;
            $leaderboard->score = $tot_score;

            if ($correct_answers >= $level_info->win_question_count) {
                $leaderboard->is_unlock = 1;
            } else {
                $leaderboard->is_unlock = 0;
            }

            if ($leaderboard->save()) {

                $u_score = Users::where('id', $user_id)->first();
                if ($u_score && $leaderboard->is_unlock == 1) {

                    // Plus Pratice Score in User
                    $u_score->increment('pratice_quiz_score', $tot_score);
                }

                return $this->common->API_Response(200,  __('api_msg.record_add_successfully'), []);
            } else {
                return $this->common->API_Response(400,  __('api_msg.data_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_practice_leaderboard(Request $request) // Type = today, month, all
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

                    $data = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->limit('10')->get();
                } else {

                    $data = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
                        $users['user_total_score'] = (int) $data[$i]['users']->pratice_quiz_score;
                        $final[] = $users;
                        $msg['result'] = $final;
                    }
                }

                // --- Single User ---
                if ($type == "today") {

                    $single_data = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
                        ->whereDate('created_at', date('Y-m-d'))->groupBy('user_id')->with('users')
                        ->orderBy('total_score', 'DESC')->orderBy('created_at', 'DESC')->get();
                } else {

                    $single_data = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
                        $single_users['user_total_score'] = (int) $single_data[$i]['users']->pratice_quiz_score;
                        $single_final[] = $single_users;
                        $msg['user'] = $single_final;

                        break;
                    }
                }

                return $msg;
            } else {

                // --- Top 10 User ---
                $data = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
                        $users['user_total_score'] = (int) $data[$i]['users']->pratice_quiz_score;
                        $final[] = $users;
                        $msg['result'] = $final;
                    }
                }

                // --- Single User ---
                $single_data = Pratice_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))
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
                        $single_users['user_total_score'] = (int) $single_data[$i]['users']->pratice_quiz_score;
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
